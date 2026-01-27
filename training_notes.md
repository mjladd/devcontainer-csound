# Training Notes for CSound

## Models

- DeepSeek-Coder
- Qwen-Coder 7B
- CodeLlama

## RAG vs Fine-Tuning

- RAG: keep a small base model but retrieve relevant CSound snippits and docs at query time
- Fine-tune: update the model weights with the corpus

## Steps

- collect working `.csd` files, docs, and tutorials
- normalize these docs by ensuring consistent encoding and adding minimal metadata (file names, purpose, tags for synthesis types)
- chunk and index
  - split large files into relavannt chunks (individual instruments, opcode examples)
- create embeddings for each chunk and store in local vector store (FAISS, Chroma)
- fine-tuning
  - turn the corpus into supervised pairs
  - Instruction: Write an instrument that does X
  - Output: appropriate corresponding CSound code
  - Instruction: explain this CSound snippit
  - Output: the explaination
  - use LoRA / QLoRA for fine-tuning

## Chunk Structure

- treat each instrument or opcode demonstration as one chunk

```shell
csound_corpus/
  instruments/
  effects/
  examples/
```

```json
{
  "instruction": "Write a CSound instrument that generates a sine wave with an ADSR envelope",
  "input": "",
  "output": "<valid CSound code>"
}
```

```json
{
  "instruction": "Fix the rate mismatch error in this CSound code",
  "input": "aSig oscil kAmp, kFreq",
  "output": "aSig oscil aAmp, kFreq ; oscil requires a-rate amplitude"
}
```

```json
[
  {
    "id": "inst_001",
    "file": "csound_corpus/instruments/pad.csd",
    "title": "Warm pad instrument with reverb",
    "tags": ["instrument", "pad", "reverb"],
    "description": "A basic warm pad with ADSR envelope and global reverb send.",
    "code": "instr 1\n  aOsc vco2 0.5, p4\n  aEnv madsr 0.1, 0.2, 0.7, 0.5\n  aSig = aOsc * aEnv\n  outs aSig, aSig\nendin"
  },
  {
    "id": "fx_001",
    "file": "csound_corpus/effects/chorus.csd",
    "title": "Simple chorus effect",
    "tags": ["effect", "chorus"],
    "description": "Applies a basic chorus using multiple delayed, modulated taps.",
    "code": "instr 2\n  aIn inch 1\n  aCh chorus aIn, 0.02, 0.3, 0.7\n  out aCh\nendin"
  }
]

```

## Online Fine-Tuning

- hugging-face: hosted inference and low-code fine-tuning
