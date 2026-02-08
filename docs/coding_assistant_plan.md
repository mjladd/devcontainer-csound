# Building a Csound coding assistant with RAG and fine-tuning

**Qwen3-Coder already supports Csound natively** — it lists the language among its 300+ supported languages, giving this project a strong foundation. The optimal implementation combines a RAG pipeline for grounding responses in your specific corpus with QLoRA fine-tuning via Unsloth for deeper syntactic fluency, all served through a Typer+Rich CLI that streams responses from Ollama. This plan covers every component from embedding strategy to deployment, with specific code patterns, tool choices, and step-by-step procedures throughout.

The recommended stack is **ChromaDB + nomic-embed-text + rank-bm25** for retrieval, **Unsloth + QLoRA** for fine-tuning, and **Typer + Rich + prompt_toolkit** for the CLI interface. Total development effort spans roughly four phases: RAG pipeline (~1 week), CLI tool (~1 week), fine-tuning pipeline (~1–2 weeks), and integration/testing (~1 week).

---

## 1. RAG pipeline: embeddings, vector store, and retrieval

### Embedding model selection

For a niche language like Csound, **general-purpose embedding models outperform code-specific ones**. Code-specific models (Nomic Embed Code, CodeSage, Voyage Code 3) train on mainstream languages — Python, Java, JavaScript — and Csound's syntax (`instr`/`endin` blocks, opcodes like `oscili`, `moogladder`, score `f` statements) is radically different. A strong general model captures structural patterns and English-language comments more effectively.

**Primary recommendation: `nomic-embed-text` via Ollama.** Pull it with `ollama pull nomic-embed-text`. It provides **768 dimensions**, an **8,192-token context window** (enough to capture full instrument definitions), and Apache 2.0 licensing. It requires prefixes: `search_document:` for indexing and `search_query:` for queries. An alternative worth considering is `qwen3-embedding` for ecosystem synergy with Qwen3-Coder.

```python
import ollama

def embed_document(text: str) -> list[float]:
    response = ollama.embed(model="nomic-embed-text", input=f"search_document: {text}")
    return response["embeddings"][0]

def embed_query(text: str) -> list[float]:
    response = ollama.embed(model="nomic-embed-text", input=f"search_query: {text}")
    return response["embeddings"][0]
```

A critical technique for niche languages: **prepend natural-language descriptions to each code chunk before embedding**. This bridges the gap between user queries in English and Csound code tokens, dramatically improving retrieval accuracy.

### Vector database: ChromaDB for simplicity

For a single-user CLI tool, **ChromaDB** offers the best balance of simplicity, persistence, and ecosystem compatibility. It runs in-process (no server), persists to disk with one line of configuration, and supports metadata filtering for targeting specific file types or instrument numbers.

```python
import chromadb

client = chromadb.PersistentClient(path="./csound_vectordb")
collection = client.get_or_create_collection(
    name="csound_examples",
    metadata={"hnsw:space": "cosine"}
)

collection.add(
    documents=["instr 1\n  aOut oscili 0.5, 440\n  out aOut\nendin"],
    metadatas=[{
        "filename": "simple_sine.orc",
        "instrument_number": "1",
        "opcodes": "oscili,out",
        "file_type": "orc",
        "description": "Simple sine wave oscillator at 440Hz"
    }],
    ids=["csound_corpus/simple_sine.orc#instr1"]
)
```

**LanceDB** is a strong alternative if you want built-in hybrid search without extra dependencies. It stores data on disk (not memory-constrained), supports SQL-like filtering, and is used by AnythingLLM and Continue for local code RAG.

### Chunking strategies for Csound files

Csound's structure is highly regular, making **regex-based structure-aware chunking** effective even without a tree-sitter grammar. Each file type requires a different strategy:

**Orchestra files (.orc):** Split on `instr`/`endin` boundaries. Each instrument definition is a natural semantic unit. Also extract UDOs (`opcode`/`endop` blocks) and the global header section (sr, ksmps, nchnls, 0dbfs) as separate chunks.

```python
import re

def chunk_orc_file(content: str, filename: str) -> list[dict]:
    chunks = []
    # Instrument blocks
    for match in re.finditer(r'(instr\s+(\d+|"\w+").*?endin)', content, re.DOTALL):
        chunks.append({
            "text": match.group(1).strip(),
            "metadata": {
                "filename": filename, "chunk_type": "instrument",
                "instrument_number": match.group(2), "file_type": "orc"
            }
        })
    # UDO blocks
    for match in re.finditer(r'(opcode\s+(\w+).*?endop)', content, re.DOTALL):
        chunks.append({
            "text": match.group(1).strip(),
            "metadata": {
                "filename": filename, "chunk_type": "udo",
                "udo_name": match.group(2), "file_type": "orc"
            }
        })
    # Global header
    header = re.match(r'(.*?)(?=instr\s+\d+)', content, re.DOTALL)
    if header and header.group(1).strip():
        chunks.append({
            "text": header.group(1).strip(),
            "metadata": {"filename": filename, "chunk_type": "header", "file_type": "orc"}
        })
    return chunks
```

**Score files (.sco):** Group function table definitions (`f` statements) together and cluster note events (`i` statements) by instrument number.

**CSD files (.csd):** Parse the XML-like structure to extract `<CsInstruments>` and `<CsScore>` sections, then apply the .orc and .sco chunking respectively. For small files under ~2,000 tokens, also store the **complete .csd as a single chunk** — this gives the model access to holistic examples showing how orchestra and score work together.

**Enrichment before embedding** — prepend a natural-language description to each chunk:

```python
def enrich_chunk(chunk: dict) -> str:
    meta = chunk["metadata"]
    parts = []
    if meta.get("chunk_type") == "instrument":
        parts.append(f"Csound instrument {meta.get('instrument_number')} from {meta['filename']}")
    elif meta.get("chunk_type") == "complete_csd":
        parts.append(f"Complete Csound example from {meta['filename']}")
    header = ". ".join(parts)
    return f"{header}\n\n{chunk['text']}" if header else chunk["text"]
```

### Hybrid retrieval with BM25 + semantic search

**Hybrid search is essential for Csound.** BM25 catches exact opcode names (`oscili`, `vco2`, `moogladder`) and score syntax tokens that semantic search may miss. Semantic search catches conceptual similarity when users ask in natural language ("how to make a filter sweep"). Use **Reciprocal Rank Fusion (RRF)** to combine results with equal weighting (0.5/0.5), adjustable per query type.

```python
from rank_bm25 import BM25Okapi
import numpy as np

class HybridRetriever:
    def __init__(self, collection, documents):
        self.collection = collection
        tokenized = [doc.lower().split() for doc in documents]
        self.bm25 = BM25Okapi(tokenized)

    def search(self, query: str, top_k: int = 5) -> list:
        # Semantic via ChromaDB
        semantic = self.collection.query(query_texts=[query], n_results=top_k * 2)
        # BM25 keyword search
        bm25_scores = self.bm25.get_scores(query.lower().split())
        bm25_top = np.argsort(bm25_scores)[-top_k * 2:][::-1]
        # Reciprocal Rank Fusion
        fused = {}
        k = 60
        for rank, doc_id in enumerate(semantic['ids'][0]):
            fused[doc_id] = fused.get(doc_id, 0) + 0.5 / (k + rank + 1)
        for rank, idx in enumerate(bm25_top):
            fused[idx] = fused.get(idx, 0) + 0.5 / (k + rank + 1)
        return sorted(fused.items(), key=lambda x: x[1], reverse=True)[:top_k]
```

Retrieve **top 10–15 initially**, then either re-rank with a cross-encoder (`BAAI/bge-reranker-v2-m3` via sentence-transformers) or simply take the top **3–5 after RRF fusion**. Research consistently shows 3–5 high-quality examples outperform 10+ mediocre ones. With Qwen3-Coder's **256K context window**, budget roughly 3,000–6,000 tokens for RAG context.

### Prompt construction with retrieved context

Format retrieved examples with clear separators and metadata headers. Address the "lost in the middle" problem by placing the most relevant example first and second-most relevant last:

```python
def build_rag_prompt(query: str, chunks: list[dict]) -> tuple[str, str]:
    context_parts = []
    for i, chunk in enumerate(chunks):
        meta = chunk.get("metadata", {})
        source = f"[Source: {meta.get('filename', 'unknown')}"
        if meta.get('instrument_number'):
            source += f", instr {meta['instrument_number']}"
        source += "]"
        context_parts.append(f"--- Example {i+1} {source} ---\n{chunk['text']}")

    context_block = "\n\n".join(context_parts)
    user_message = f"""Here are relevant Csound code examples from the corpus:

{context_block}

---

Based on these examples, {query}"""
    return user_message
```

---

## 2. Fine-tuning Qwen3-Coder for Csound fluency

### The fine-tuning workflow for Ollama

**Ollama cannot fine-tune models directly** — it is strictly an inference/serving platform. The workflow is: fine-tune externally → convert to GGUF → import into Ollama via a Modelfile. Three import paths exist:

- **Path A (recommended):** Merge LoRA weights and export as a single GGUF file
- **Path B:** Import safetensors adapter on top of a base model
- **Path C:** Import a GGUF-format LoRA adapter separately, referencing the base model

**Qwen3-Coder-30B-A3B** (the "Flash" variant) is the practical fine-tuning target. Despite having 30B total parameters, its MoE architecture activates only **3.3B parameters** per token. With QLoRA via Unsloth, it fits in approximately **17.5 GB VRAM** — feasible on an RTX 4090 or A100.

### QLoRA with Unsloth: the recommended approach

**QLoRA is the clear winner** for this use case. Sebastian Raschka's experiments confirmed it achieves virtually identical quality to full LoRA while saving ~33% GPU memory. Unsloth provides 2× faster training, 70% less VRAM usage, and **built-in GGUF/Ollama export** with automatic Modelfile generation.

```python
from unsloth import FastLanguageModel

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Qwen3-14B-unsloth-bnb-4bit",  # or Qwen3-Coder-30B-A3B
    max_seq_length=4096,
    load_in_4bit=True,
)

model = FastLanguageModel.get_peft_model(
    model,
    r=32,                    # LoRA rank — start here, increase to 64 if needed
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj"],
    lora_alpha=32,           # Equal to rank
    lora_dropout=0,          # Required for 4-bit QLoRA
    bias="none",
    use_gradient_checkpointing="unsloth",
)
```

**Recommended hyperparameters:** LoRA rank **r=32** (increase to 64 for complex domain knowledge), alpha equal to rank, learning rate **2e-4**, **1–3 epochs**, batch size 2 with gradient accumulation of 4, adamw_8bit optimizer.

### Two-phase training strategy

The ideal approach for teaching a niche language:

**Phase 1 — Continued pre-training on raw Csound code.** Expose the model to raw `.orc`, `.sco`, `.csd` files to learn syntax, opcodes, and idioms at a fundamental level. This builds the model's "vocabulary" for Csound.

**Phase 2 — Instruction tuning on Q&A pairs.** Train on structured instruction-response pairs to teach the model how to respond to Csound programming requests. If resources are limited, skip Phase 1 and go directly to instruction tuning — the Stanford Fortran fine-tuning study showed that adding instructions to raw data greatly improves results for underrepresented languages.

### Data preparation

Structure training data in **ChatML format** (Qwen3's native template) as ShareGPT conversations:

```json
{
  "conversations": [
    {"from": "system", "value": "You are a Csound programming expert."},
    {"from": "human", "value": "Write a Csound instrument that generates FM synthesis with a 3:1 modulation ratio"},
    {"from": "gpt", "value": "instr 1\n  iFreq = p4\n  iModRatio = 3\n  kModIndex linseg 5, p3*0.3, 10, p3*0.7, 0.5\n  kEnv madsr 0.01, 0.2, 0.7, 0.3\n  aOut foscil p5, iFreq, 1, iModRatio, kModIndex, -1\n  outs aOut * kEnv, aOut * kEnv\nendin"}
  ]
}
```

Create training pairs across six categories: **instrument generation**, **code explanation**, **code completion**, **score generation**, **bug fixing**, and **full .csd generation**. Generate synthetic pairs from raw code files using a powerful model (GPT-4, Claude, or Qwen3-Coder itself) with the Self-Instruct approach. Aim for **1,000–3,000 high-quality examples** across all categories. Data augmentation strategies include variable renaming, parameter variation, opcode substitution, and multi-turn conversation chaining.

### GGUF export and Ollama import

With Unsloth, export is a single line:

```python
model.save_pretrained_gguf("csound-coder", tokenizer, quantization_method="q4_k_m")
```

This merges LoRA weights, converts to GGUF, quantizes, and generates the Ollama Modelfile automatically. For manual conversion, the pipeline is: merge LoRA → `convert_hf_to_gguf.py` → `llama-quantize` → create Ollama Modelfile → `ollama create`.

**Quantization recommendation: Q4_K_M or Q5_K_M.** For Qwen3-Coder, Unsloth's benchmarks showed Q4_K_M scores **60.9% vs 61.8% for bf16** on the Aider Polyglot benchmark — minimal degradation. Use an **importance matrix** (imatrix) calibrated on Csound code samples for better domain-specific accuracy at lower bit widths.

The Modelfile for Ollama:

```dockerfile
FROM ./csound-coder-q4_k_m.gguf

TEMPLATE """{{- if .System }}<|im_start|>system
{{ .System }}<|im_end|>
{{ end }}<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
{{ .Response }}<|im_end|>
"""

SYSTEM "You are a Csound programming expert..."
PARAMETER temperature 0.7
PARAMETER top_p 0.8
PARAMETER num_ctx 32768
PARAMETER stop "<|im_end|>"
```

```bash
ollama create csound-coder -f Modelfile
ollama run csound-coder "Write a Karplus-Strong plucked string instrument"
```

---

## 3. CLI tool architecture with Typer and Rich

### Framework choice and project structure

**Typer + Rich + prompt_toolkit** is the optimal combination. Typer handles CLI structure with Python type hints (built on Click), Rich provides syntax-highlighted code output with Csound-specific lexers (Pygments includes `CsoundOrchestraLexer` and `CsoundScoreLexer`), and prompt_toolkit powers the interactive REPL with history, auto-suggestions, and multiline editing.

```
csound-assist/
├── pyproject.toml
├── README.md
├── src/
│   └── csound_assist/
│       ├── __init__.py
│       ├── __main__.py          # python -m csound_assist support
│       ├── cli.py               # Typer app, all subcommands
│       ├── client.py            # Ollama client wrapper
│       ├── config.py            # TOML config loading
│       ├── rag.py               # RAG pipeline (embedding, retrieval)
│       ├── chat.py              # Interactive chat session
│       ├── prompts.py           # System prompts, templates
│       ├── chunker.py           # Csound file chunking
│       ├── validator.py         # Csound code validation
│       ├── display.py           # Rich output formatting
│       └── logging.py           # Loguru setup
├── tests/
└── examples/
    └── config.toml
```

### Subcommand design

```python
import typer
from rich.console import Console
from rich.syntax import Syntax
from rich.panel import Panel

app = typer.Typer(name="csound-assist", help="AI-powered Csound coding assistant")
console = Console()

@app.command()
def generate(
    description: str = typer.Argument(..., help="Natural language description"),
    output: str = typer.Option(None, "-o", "--output", help="Output file path"),
    temperature: float = typer.Option(0.7, "-t", "--temperature"),
):
    """Generate Csound code from a description."""
    # 1. Retrieve relevant examples via RAG
    # 2. Build prompt with context
    # 3. Stream response from Ollama
    # 4. Extract code and optionally write to file

@app.command()
def explain(
    file: typer.FileText = typer.Argument(None, help="Csound file to explain"),
    code: str = typer.Option(None, "-c", "--code", help="Code snippet"),
):
    """Explain Csound code in detail."""
    # Detect piped input: not sys.stdin.isatty()

@app.command()
def debug(
    file: typer.FileText = typer.Argument(..., help="Csound file with errors"),
    error: str = typer.Option(None, "-e", "--error", help="Error message from Csound"),
):
    """Debug Csound code and suggest fixes."""

@app.command()
def complete(file: typer.FileText = typer.Argument(..., help="Partial Csound file")):
    """Autocomplete partial Csound code."""

@app.command()
def chat():
    """Start an interactive chat session."""

@app.command()
def reindex(
    full: bool = typer.Option(False, "--full", help="Full rebuild"),
    watch: bool = typer.Option(False, "--watch", help="Watch for changes"),
):
    """Update the RAG vector index."""
```

### Ollama integration with streaming

The official `ollama` Python library provides direct API access. **Streaming is essential** for responsive CLI output. Qwen3-Coder's recommended parameters are temperature=0.7, top_p=0.8, top_k=20, repetition_penalty=1.05.

```python
import ollama
from ollama import ResponseError

def stream_response(messages: list, model: str = "qwen3-coder", config: dict = None):
    stream = ollama.chat(
        model=model,
        messages=messages,
        stream=True,
        options={
            "temperature": 0.7,
            "top_p": 0.8,
            "top_k": 20,
            "repeat_penalty": 1.05,
            "num_ctx": 32768,
            "num_predict": 65536,
        },
    )
    content = ""
    for chunk in stream:
        if chunk.message.content:
            print(chunk.message.content, end="", flush=True)
            content += chunk.message.content
    print()
    return content

def ensure_model(model_name: str):
    try:
        ollama.show(model_name)
    except ResponseError as e:
        if e.status_code == 404:
            console.print(f"[yellow]Pulling {model_name}...[/yellow]")
            ollama.pull(model_name)
        else:
            raise
```

### Interactive chat with prompt_toolkit

```python
from prompt_toolkit import PromptSession
from prompt_toolkit.history import FileHistory
from prompt_toolkit.auto_suggest import AutoSuggestFromHistory

class ChatSession:
    def __init__(self, model="qwen3-coder"):
        self.model = model
        self.messages = [{"role": "system", "content": SYSTEM_PROMPT}]

    def send(self, user_input: str) -> str:
        self.messages.append({"role": "user", "content": user_input})
        response = stream_response(self.messages, self.model)
        self.messages.append({"role": "assistant", "content": response})
        return response

    def truncate_history(self, max_messages=50):
        if len(self.messages) > max_messages:
            system = [m for m in self.messages if m["role"] == "system"]
            self.messages = system + self.messages[-(max_messages - len(system)):]

def interactive_chat(model: str):
    session = ChatSession(model=model)
    prompt_session = PromptSession(
        history=FileHistory(".csound_assist_history"),
        auto_suggest=AutoSuggestFromHistory(),
    )
    console.print("[bold green]Csound Assistant[/] (type /help, Ctrl+D to exit)")
    while True:
        try:
            user_input = prompt_session.prompt("csound> ")
        except (KeyboardInterrupt, EOFError):
            break
        if user_input.startswith("/"):
            handle_slash_command(user_input, session)
            continue
        session.send(user_input)
```

### Configuration via TOML

Store settings in `~/.config/csound-assist/config.toml`:

```toml
[model]
name = "qwen3-coder:30b"
host = "http://localhost:11434"

[parameters]
temperature = 0.7
top_p = 0.8
num_ctx = 32768

[rag]
examples_dirs = ["csound_score_examples", "corpus", "csound_corpus"]
embedding_model = "nomic-embed-text"
num_results = 5
min_similarity = 0.65

[output]
theme = "monokai"
line_numbers = true
```

Use `tomllib` (stdlib since Python 3.11) for reading. Provide a `dataclass`-based Config class with sensible defaults so the tool works out-of-the-box without a config file.

---

## 4. Csound-specific knowledge the system must encode

### Syntax fundamentals for the system prompt

The AI must understand Csound's **three-tier rate system**: i-rate variables (prefix `i`, computed once at note start), k-rate (prefix `k`, updated every control period), and a-rate (prefix `a`, updated every audio sample). Global variables add a `g` prefix (`gaSignal`, `gkLevel`). String variables use `S`. The **header block** (`sr`, `ksmps`, `nchnls`, `0dbfs`) is mandatory in every orchestra.

Instruments are defined with `instr N`...`endin` (numbered or named). User Defined Opcodes use `opcode name, outtypes, intypes`...`endop`. Score events use single-letter statements: `i` for instrument events, `f` for function tables (GEN routines), `t` for tempo, `s` for section breaks, `e` for end. The unified `.csd` format wraps everything in `<CsoundSynthesizer>` with `<CsOptions>`, `<CsInstruments>`, and `<CsScore>` sections.

### Essential opcode clusters

The system prompt should encode awareness of the most common opcode patterns:

- **Oscillators:** `poscil` (preferred, internal sine table), `vco2` (band-limited saw/square/tri), `oscili` (interpolating table lookup), `foscil` (FM synthesis), `buzz`/`gbuzz` (additive)
- **Envelopes:** `madsr` (MIDI-ready ADSR, **the default choice**), `linseg`/`linsegr` (multi-segment linear), `expseg`/`expsegr` (exponential, cannot use zero), `linen` (simple attack-sustain-release)
- **Filters:** `moogladder` (high-quality Moog LPF, **the go-to**), `butterlp`/`butterhp` (Butterworth), `rezzy` (resonant), `tone`/`atone` (first-order)
- **Effects:** `reverbsc` (Schroeder reverb, **standard choice**), `freeverb`, `delay`/`vdelay`, `pan2`
- **Output:** `outs` (stereo, **always use this**), `out` (mono)

### Code validation via Csound itself

**Csound's compiler is the linter.** Three validation flags exist:

- **`csound --syntax-check-only file.csd`** — parses orchestra and score syntax, exits immediately without rendering. Returns exit code 0 on success. This is the fastest validation.
- **`csound -I file.csd`** — allocates and initializes all instruments (catches init-time errors like undefined function tables) but skips performance.
- **`csound -n file.csd`** — full processing without audio output (catches runtime errors too).

For programmatic validation from Python, use **ctcsound**:

```python
import ctcsound

def validate_csound(csd_text: str) -> tuple[bool, str]:
    cs = ctcsound.Csound()
    cs.setOption("--syntax-check-only")
    cs.setOption("-d")  # suppress displays
    result = cs.compileCsdText(csd_text)
    valid = (result == ctcsound.CSOUND_SUCCESS)
    del cs
    return valid, "" if valid else "Compilation errors detected"
```

### Common AI mistakes to guard against

The system prompt and post-processing should watch for these frequent errors: missing `endin` closures, omitting header parameters, wrong variable prefix for an opcode's rate, referencing undefined function tables, using zero in `expseg` (must use 0.001), forgetting `0dbfs = 1`, and wrong p-field counts in score events vs. instrument expectations.

---

## 5. System prompt engineering and task templates

### Core system prompt structure

The system prompt follows a five-part pattern: **role definition → domain rules → output format → RAG instructions → constraints**. Keep it under ~2,500 tokens to leave budget for RAG context and conversation.

```python
SYSTEM_PROMPT = """You are an expert Csound programmer and sound designer. You help users write, debug, explain, and optimize Csound code.

## Csound Rules
- Use CSD format (<CsoundSynthesizer> wrapper) for complete instruments
- Always include header: sr=44100, ksmps=32, nchnls=2, 0dbfs=1 (unless specified otherwise)
- Variables must use correct rate prefixes: a (audio), k (control), i (init), S (string)
- Instruments: instr N ... endin. UDOs: opcode name, outtypes, intypes ... endop
- Prefer poscil over oscil (internal sine table, no f-statement needed)
- Prefer vco2 for band-limited waveforms, madsr for envelopes, moogladder for filters
- Use outs for stereo output, reverbsc for reverb

## Output Format
- Wrap Csound code in ```csound code blocks
- Include comments explaining non-obvious DSP operations
- For complete instruments, include the full CSD wrapper with score events

## Critical Constraints
- ONLY use opcodes from Csound's official documentation
- Do NOT hallucinate opcode names or invent parameters
- Do NOT mix Csound with SuperCollider, Pure Data, or other languages
- If unsure about an opcode's syntax, state that uncertainty

## When Reference Examples Are Provided
- Use them for correct syntax and idiomatic patterns
- Adapt patterns to the user's request; do not copy verbatim
- If examples don't cover what's needed, say so clearly"""
```

### Task-specific templates

Use separate prompt templates for each operation mode. The **generation template** instructs the model to identify the DSP technique, choose appropriate opcodes from references, and produce complete runnable code. The **debug template** directs the model to check for rate mismatches, missing closures, score/orchestra mismatches, and common pitfalls. The **autocomplete template** tells the model to infer intent from context and output only the completion.

Include a **condensed opcode cheat sheet** (~50–100 most common opcodes with signatures) in the system prompt. This acts as grounding, reducing hallucinated opcode names. Example:

```
## Quick Reference
aout poscil kamp, kcps [, ifn]
aout vco2 kamp, kcps [, imode] [, kpw]
kenv madsr iatt, idec, islev, irel
aout moogladder asig, kcf, kres
outs asig1, asig2
aL, aR reverbsc asig, asig, kfblvl, kfco
```

### RAG context formatting in prompts

Format retrieved examples with clear separators and metadata. Address the "lost in the middle" problem: place the **most relevant example first** (primacy bias) and the **second-most relevant last** (recency bias). Filter by a minimum similarity threshold (0.65 cosine similarity) and cap at **3–5 examples** — research consistently shows diminishing returns beyond this.

---

## 6. Maintenance, versioning, and incremental updates

### Incremental RAG index updates

Use **hash-based change detection** to avoid re-embedding unchanged files. Maintain a manifest file mapping file paths to SHA-256 hashes. On sync, compare hashes to detect additions, modifications, and deletions. ChromaDB's `upsert` method handles add-or-update in a single call.

```python
import hashlib, json
from pathlib import Path

class IncrementalIndexer:
    def __init__(self, collection, manifest_path="file_manifest.json"):
        self.collection = collection
        self.manifest = json.loads(Path(manifest_path).read_text()) if Path(manifest_path).exists() else {}

    def sync(self, directories: list[str]):
        current = {}
        for d in directories:
            for f in Path(d).rglob("*.csd"):
                fid = str(f.resolve())
                current[fid] = hashlib.sha256(f.read_bytes()).hexdigest()

        added = {k: v for k, v in current.items() if k not in self.manifest or self.manifest[k] != v}
        deleted = [k for k in self.manifest if k not in current]

        for fid in added:
            chunks = chunk_file(Path(fid))
            for i, chunk in enumerate(chunks):
                self.collection.upsert(
                    ids=[f"{fid}::chunk_{i}"],
                    documents=[enrich_chunk(chunk)],
                    metadatas=[chunk["metadata"]]
                )

        if deleted:
            for fid in deleted:
                self.collection.delete(where={"filename": fid})

        self.manifest = current
        Path("file_manifest.json").write_text(json.dumps(self.manifest))
        return {"upserted": len(added), "deleted": len(deleted)}
```

Expose this as a CLI command: `csound-assist reindex` for incremental, `csound-assist reindex --full` for complete rebuild, `csound-assist reindex --watch` for file-watching mode via the `watchdog` library.

### Model version management

Use a naming convention like `csound-coder-v1.0`, `csound-coder-v1.1` for Ollama model tags. Keep training data in JSONL format for easy expansion. When the corpus grows, train a new LoRA from the previous checkpoint on the expanded dataset (incremental fine-tuning). Implement simple A/B testing by logging which model version served each query and collecting user feedback (thumbs up/down after each response).

### Logging with Loguru

Log queries, RAG retrieval scores, model latency, and user feedback in structured JSON format:

```python
from loguru import logger

logger.add(
    "~/.csound-assist/logs/csound-assist_{time:YYYY-MM-DD}.log",
    serialize=True,         # JSON output for analysis
    rotation="10 MB",
    retention="30 days",
    compression="gz",
)

logger.info("interaction", query=user_query[:100], model=model_name,
            rag_top_score=0.82, latency_ms=1250, tokens=340)
```

---

## 7. Installation, configuration, and example workflows

### Installation steps

```bash
# 1. Install Ollama
curl -fsSL https://ollama.com/install.sh | sh   # Linux
# or: brew install ollama                          # macOS

# 2. Pull required models
ollama pull qwen3-coder:30b       # Main LLM (~18GB)
ollama pull nomic-embed-text      # Embedding model (~274MB)

# 3. Install the CLI tool
pip install csound-assist          # From PyPI
# or from source:
git clone https://github.com/user/csound-assist && cd csound-assist
pip install -e ".[dev]"

# 4. Initialize (creates config and builds initial index)
csound-assist init --examples-dir ./csound_score_examples ./corpus ./csound_corpus

# 5. Verify
csound-assist --version
csound-assist generate "a simple sine wave at 440Hz"
```

### Example workflow: generating a new instrument

```bash
$ csound-assist generate "a plucked string using Karplus-Strong synthesis"

┌─ Generated Csound Code ─────────────────────────────┐
│  1 │ <CsoundSynthesizer>                            │
│  2 │ <CsOptions>                                    │
│  3 │ -odac                                          │
│  4 │ </CsOptions>                                   │
│  5 │ <CsInstruments>                                │
│  6 │ sr = 44100                                     │
│  7 │ ksmps = 32                                     │
│  8 │ nchnls = 2                                     │
│  9 │ 0dbfs = 1                                      │
│ 10 │                                                │
│ 11 │ instr 1                                        │
│ 12 │   iFreq = p4                                   │
│ 13 │   iAmp = p5                                    │
│ 14 │   ; Noise burst excitation                     │
│ 15 │   aExcite noise iAmp, 0                        │
│ 16 │   aExcite linen aExcite, 0, 0.01, 0.005       │
│ 17 │   ; Delay line for pitch                       │
│ 18 │   aDelay init 0                                │
│ 19 │   aDelay delayr 1/iFreq                        │
│ 20 │   aOut deltap 1/iFreq                          │
│ 21 │   delayw aExcite + aOut * 0.996                │
│ 22 │   outs aOut, aOut                              │
│ 23 │ endin                                          │
│ 24 │ </CsInstruments>                               │
│ 25 │ <CsScore>                                      │
│ 26 │ i 1 0 2 440 0.8                                │
│ 27 │ i 1 0.5 2 554 0.7                              │
│ 28 │ e                                              │
│ 29 │ </CsScore>                                     │
│ 30 │ </CsoundSynthesizer>                           │
└──────────────────────────────────────────────────────┘
✓ Syntax validation passed

$ csound-assist generate -o plucked.csd "a plucked string"
Written to plucked.csd
```

### Example workflow: debugging a score

```bash
$ csound-assist debug broken.csd --error "INIT ERROR: Invalid ftable no."

Analysis:
  Line 15 references function table 2 (aOut oscili 0.5, 440, 2)
  but the score only defines table 1 (f 1 0 4096 10 1).

Fix: Add the missing table definition to your score:
  f 2 0 4096 10 1 0.5 0.3 0.25
Or use poscil instead of oscili (has built-in sine table):
  aOut poscil 0.5, 440
```

### Example workflow: pipe-based explanation

```bash
$ cat my_instrument.orc | csound-assist explain

This orchestra defines a subtractive synthesizer (instrument 1):
- vco2 generates a band-limited sawtooth wave at the frequency in p4
- moogladder applies a resonant low-pass filter with envelope-controlled cutoff
- madsr creates an ADSR envelope (0.1s attack, 0.3s decay, 0.7 sustain, 0.5s release)
- The output is stereo via outs with the envelope applied to amplitude
```

### Complete dependencies

```toml
# pyproject.toml [project] dependencies
dependencies = [
    "typer>=0.12",
    "rich>=13.0",
    "ollama>=0.4",
    "prompt-toolkit>=3.0",
    "pygments>=2.17",
    "chromadb>=1.4",
    "rank-bm25>=0.2.2",
    "loguru>=0.7",
    "watchdog>=4.0",       # For reindex --watch
]
```

---

## Conclusion: a phased implementation roadmap

The most important architectural insight is that **RAG and fine-tuning serve complementary purposes** — RAG grounds the model in your specific corpus and prevents hallucination, while fine-tuning deepens the model's syntactic fluency and coding style for Csound. Start with RAG alone (it delivers immediate value with no training cost), then layer fine-tuning as training data accumulates.

**Phase 1 (Week 1):** Build the RAG pipeline — chunker, ChromaDB indexing, hybrid retrieval. Index all files in `csound_score_examples`, `corpus`, and `csound_corpus`. Test retrieval quality with sample queries.

**Phase 2 (Week 2):** Build the CLI tool — Typer subcommands, Ollama streaming integration, interactive chat mode, config loading, Rich output formatting, pipe support.

**Phase 3 (Weeks 3–4):** Prepare fine-tuning data by generating 1,000+ instruction-completion pairs from the corpus using Self-Instruct. Fine-tune with Unsloth QLoRA, export to GGUF, import into Ollama. Compare RAG-only vs RAG+fine-tuned model.

**Phase 4 (Week 5):** Add validation via `csound --syntax-check-only`, implement incremental reindexing, logging, feedback collection, and write user documentation.

The system's unique strength lies in the combination: even if Qwen3-Coder already knows Csound syntax from pretraining, RAG retrieval from your specific example corpus ensures generated code reflects your project's conventions and patterns, while fine-tuning on curated pairs teaches the model your preferred coding style and the specific opcodes most relevant to your work.
