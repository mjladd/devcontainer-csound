# Complete Guide: Fine-tuning CodeLlama for Csound

## From Dataset Upload to Local Editor Integration

---

## Overview

This guide walks you through the complete workflow of fine-tuning CodeLlama on Hugging Face for Csound programming assistance, then integrating the resulting model into your local development environment. The process consists of five main phases: dataset preparation, model training, deployment, local integration, and ongoing iteration.

---

## Phase 1: Dataset Preparation & Upload

### 1.1 Dataset Format

Your dataset should be formatted as JSONL (JSON Lines) or JSON with the following structure:

```json
{
  "instruction": "Write a Csound instrument that generates a sine wave at 440Hz",
  "input": "",
  "output": "instr 1\n  a1 oscil 0.5, 440, 1\n  out a1\nendin"
}
```

For instruction-following tasks, include three fields:

- **instruction:** The task or question - What you want the model to do
- **input:** Optional context - Additional information (can be empty)
- **output:** The expected response - The code or answer you want

Alternative formats that work well:

```json
// Conversational format
{
  "messages": [
    {"role": "user", "content": "How do I create an envelope in Csound?"},
    {"role": "assistant", "content": "Use the linseg opcode..."}
  ]
}

// Code completion format
{
  "prompt": "instr 1\n  ; Create ADSR envelope\n  ",
  "completion": "aEnv madsr 0.01, 0.1, 0.7, 0.5"
}
```

### 1.2 Dataset Quality Tips

- Include diverse examples covering common Csound tasks (instruments, effects, opcodes)
- Add examples of both correct code and common mistakes with explanations
- Include code at different complexity levels (beginner to advanced)
- Add examples of debugging and error correction
- Aim for at least 500-1000 high-quality examples for good results

### 1.3 Upload Dataset to Hugging Face

First, create a Hugging Face account and get an access token:

1. Go to [huggingface.co/join](https://huggingface.co/join) and create an account
2. Navigate to Settings → Access Tokens
3. Create a new token with 'write' permissions

Then upload your dataset using Python:

```python
pip install huggingface_hub datasets

from datasets import load_dataset
from huggingface_hub import login

# Login with your token
login(token="your_token_here")

# Load your local dataset
dataset = load_dataset("json", data_files="csound_dataset.jsonl")

# Push to Hugging Face Hub
dataset.push_to_hub("your-username/csound-code-dataset")
```

---

## Phase 2: Fine-tuning with LoRA/QLoRA

We'll use QLoRA (Quantized Low-Rank Adaptation), which allows you to fine-tune large models efficiently on consumer GPUs by using 4-bit quantization and low-rank adapters.

### 2.1 Training Environment Options

You have several options for where to train:

- **Google Colab (Recommended for beginners)** - Free T4 GPU, easy setup, good for CodeLlama-7B
- **Hugging Face Spaces** - Paid GPU access, integrated with your datasets
- **Local GPU** - If you have an NVIDIA GPU with 12GB+ VRAM

### 2.2 Complete Training Script

Here's a complete script you can run in Google Colab or locally:

```python
# Install required packages
!pip install -q accelerate peft bitsandbytes transformers trl datasets

import torch
from datasets import load_dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    BitsAndBytesConfig,
    TrainingArguments,
)
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer

# Configuration
model_name = "codellama/CodeLlama-7b-hf"
dataset_name = "your-username/csound-code-dataset"
output_dir = "./csound-codellama-lora"

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_name)
tokenizer.pad_token = tokenizer.eos_token
tokenizer.padding_side = "right"
```

```python
# QLoRA configuration for 4-bit quantization
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True,
)

# Load base model with quantization
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=bnb_config,
    device_map="auto",
    trust_remote_code=True,
)

# Prepare model for k-bit training
model = prepare_model_for_kbit_training(model)

# LoRA configuration
lora_config = LoraConfig(
    r=16,  # Rank of the update matrices
    lora_alpha=32,  # Scaling factor
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

# Add LoRA adapters to model
model = get_peft_model(model, lora_config)
```

```python
# Load and prepare dataset
dataset = load_dataset(dataset_name, split="train")

# Format function to create prompts
def format_instruction(example):
    if example.get("input"):
        text = f"""### Instruction:
{example["instruction"]}

### Input:
{example["input"]}

### Response:
{example["output"]}"""
    else:
        text = f"""### Instruction:
{example["instruction"]}

### Response:
{example["output"]}"""
    return {"text": text}

# Apply formatting
formatted_dataset = dataset.map(format_instruction)
```

```python
# Training arguments
training_args = TrainingArguments(
    output_dir=output_dir,
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-4,
    fp16=True,
    save_total_limit=3,
    logging_steps=10,
    save_strategy="epoch",
    warmup_ratio=0.05,
    lr_scheduler_type="cosine",
)

# Create trainer
trainer = SFTTrainer(
    model=model,
    train_dataset=formatted_dataset,
    peft_config=lora_config,
    dataset_text_field="text",
    max_seq_length=2048,
    tokenizer=tokenizer,
    args=training_args,
)

# Start training
trainer.train()

# Save the LoRA adapters
trainer.model.save_pretrained(output_dir)
```

### 2.3 Understanding the Training Parameters

- **r=16** - Rank of LoRA matrices. Higher = more capacity but more memory. 8-64 is typical
- **lora_alpha=32** - Scaling factor. Usually 2x the rank
- **learning_rate=2e-4** - How fast the model learns. 1e-4 to 3e-4 is good for LoRA
- **num_train_epochs=3** - How many times to go through the entire dataset
- **per_device_train_batch_size=4** - How many examples per GPU. Adjust based on VRAM

### 2.4 Upload Trained Model to Hugging Face

After training completes, upload your model:

```python
from huggingface_hub import login

# Login
login(token="your_token_here")

# Upload the LoRA adapters
trainer.model.push_to_hub("your-username/csound-codellama-lora")
tokenizer.push_to_hub("your-username/csound-codellama-lora")
```

---

## Phase 3: Testing Your Fine-tuned Model

Before integrating with your editor, test the model to ensure it works:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

# Load base model
base_model = AutoModelForCausalLM.from_pretrained(
    "codellama/CodeLlama-7b-hf",
    device_map="auto",
    torch_dtype=torch.float16,
)

# Load LoRA adapters
model = PeftModel.from_pretrained(
    base_model,
    "your-username/csound-codellama-lora"
)

tokenizer = AutoTokenizer.from_pretrained("your-username/csound-codellama-lora")
```

```python
# Test the model
prompt = """### Instruction:
Write a Csound instrument that creates a low-pass filtered sawtooth wave

### Response:
"""

inputs = tokenizer(prompt, return_tensors="pt").to("cuda")
outputs = model.generate(
    **inputs,
    max_new_tokens=200,
    temperature=0.7,
    do_sample=True,
    top_p=0.95,
)

response = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(response)
```

---

## Phase 4: Local Editor Integration

Now we'll set up a local API server and integrate it with your code editor. There are several approaches:

### 4.1 Option A: Local API Server (Recommended)

Create a simple FastAPI server that loads your model:

```python
# Install dependencies
pip install fastapi uvicorn transformers peft accelerate torch

# Save as csound_server.py
from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

app = FastAPI()

# Load model once at startup
print("Loading model...")
base_model = AutoModelForCausalLM.from_pretrained(
    "codellama/CodeLlama-7b-hf",
    device_map="auto",
    torch_dtype=torch.float16,
)

model = PeftModel.from_pretrained(
    base_model,
    "your-username/csound-codellama-lora"
)

tokenizer = AutoTokenizer.from_pretrained(
    "your-username/csound-codellama-lora"
)
print("Model loaded!")
```

```python
class CompletionRequest(BaseModel):
    prompt: str
    max_tokens: int = 100
    temperature: float = 0.7

@app.post("/complete")
def complete(request: CompletionRequest):
    # Format prompt
    formatted_prompt = f"""### Instruction:
{request.prompt}

### Response:
"""

    # Generate
    inputs = tokenizer(formatted_prompt, return_tensors="pt").to(model.device)
    outputs = model.generate(
        **inputs,
        max_new_tokens=request.max_tokens,
        temperature=request.temperature,
        do_sample=True,
        top_p=0.95,
    )

    # Decode and extract only the response
    full_response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    response_only = full_response.split("### Response:")[-1].strip()

    return {"completion": response_only}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

Start the server:

```bash
python csound_server.py
```

### 4.2 VS Code Extension Integration

Create a VS Code extension or use Continue.dev (an open-source AI code assistant) to connect to your local server:

Install Continue.dev extension from VS Code marketplace, then configure it:

```json
// .continue/config.json
{
  "models": [
    {
      "title": "Csound CodeLlama",
      "provider": "openai",
      "model": "gpt-3.5-turbo",
      "apiBase": "http://localhost:8000",
      "apiType": "openai"
    }
  ]
}
```

### 4.3 Custom VS Code Extension

For full control, create a simple VS Code extension:

```javascript
// extension.js
const vscode = require('vscode');
const axios = require('axios');

function activate(context) {
    let disposable = vscode.commands.registerCommand(
        'csound-assistant.complete',
        async () => {
            const editor = vscode.window.activeTextEditor;
            if (!editor) return;

            const document = editor.document;
            const position = editor.selection.active;
            const textBeforeCursor = document.getText(
                new vscode.Range(new vscode.Position(0, 0), position)
            );

            try {
                const response = await axios.post(
                    'http://localhost:8000/complete',
                    { prompt: textBeforeCursor, max_tokens: 150 }
                );

                editor.edit(editBuilder => {
                    editBuilder.insert(position, response.data.completion);
                });
            } catch (error) {
                vscode.window.showErrorMessage(
                    'Csound Assistant Error: ' + error.message
                );
            }
        }
    );

    context.subscriptions.push(disposable);
}

module.exports = { activate };
```

### 4.4 Option B: Use llama.cpp for Faster Inference

For faster, more efficient inference, convert your model to GGUF format and use llama.cpp:

```python
# First, merge LoRA adapters with base model
from transformers import AutoModelForCausalLM
from peft import PeftModel

base_model = AutoModelForCausalLM.from_pretrained("codellama/CodeLlama-7b-hf")
model = PeftModel.from_pretrained(base_model, "your-username/csound-codellama-lora")

# Merge and save
merged_model = model.merge_and_unload()
merged_model.save_pretrained("./csound-codellama-merged")

# Convert to GGUF using llama.cpp tools
# (See llama.cpp documentation for conversion steps)
```

### 4.5 Option C: Use Ollama (Easiest for Local Use)

Ollama provides the simplest way to run models locally with automatic optimization:

```bash
# Install Ollama from ollama.ai

# Create a Modelfile
FROM codellama:7b
PARAMETER temperature 0.7
PARAMETER top_p 0.95

TEMPLATE """
### Instruction:
{{ .Prompt }}

### Response:
"""

SYSTEM "You are a helpful Csound programming assistant."

# Create the model
ollama create csound-assistant -f Modelfile

# Run the model
ollama run csound-assistant
```

Note: With Ollama, you'll need to quantize your merged model first, or use their API to fine-tune directly.

---

## Phase 5: Using Your Csound Assistant

### 5.1 In VS Code

Once integrated, you can use your assistant in several ways:

- **Autocomplete** - Start typing Csound code and trigger completions with a keyboard shortcut
- **Code generation** - Write a comment describing what you need, then ask for completion
- **Error fixing** - Select problematic code and ask for corrections
- **Documentation** - Ask for explanations of Csound opcodes and patterns

### 5.2 Example Workflow

Here's how you might use it while coding:

```csound
; You type:
; Create a reverb effect using freeverb

; Press your completion shortcut, the assistant generates:
instr 99
  ainL, ainR ins
  aL, aR freeverb ainL, ainR, 0.9, 0.5
  outs aL, aR
endin
```

---

## Phase 6: Iteration & Improvement

Your model will improve over time as you:

1. **Collect feedback** - Save examples where the model performs poorly
2. **Add to dataset** - Include corrected versions in your training data
3. **Re-train** - Run fine-tuning again with the expanded dataset
4. **Test** - Verify improvements on a held-out test set
5. **Deploy** - Update your local server with the new model

---

## Troubleshooting Common Issues

### Out of Memory During Training

- Reduce batch_size to 1 or 2
- Increase gradient_accumulation_steps to compensate
- Use a smaller model variant (CodeLlama-7b instead of 13b)
- Reduce max_seq_length from 2048 to 1024 or 512

### Model Generates Nonsense

- Check your dataset format - ensure instructions and outputs are properly paired
- Lower the learning rate (try 1e-4 instead of 2e-4)
- Increase training epochs or dataset size
- Adjust temperature during inference (lower = more deterministic)

### Slow Inference

- Convert to GGUF format and use llama.cpp
- Use smaller context windows (reduce max_tokens)
- Consider using a smaller base model
- Enable GPU inference if running on CPU

---

## Additional Resources

- **Hugging Face Documentation:** [huggingface.co/docs](https://huggingface.co/docs)
- **PEFT/LoRA Tutorial:** [huggingface.co/docs/peft](https://huggingface.co/docs/peft)
- **CodeLlama Model Card:** [huggingface.co/codellama](https://huggingface.co/codellama)
- **Continue.dev:** [continue.dev](https://continue.dev)
- **Ollama:** [ollama.ai](https://ollama.ai)

---

## Quick Summary

The complete workflow in brief:

1. **Prepare** - Format your dataset as JSONL with instruction/output pairs
2. **Upload** - Push dataset to Hugging Face Hub
3. **Train** - Fine-tune CodeLlama with QLoRA on Colab or your GPU
4. **Deploy** - Upload trained adapters to Hugging Face
5. **Serve** - Run local FastAPI server or use Ollama
6. **Integrate** - Connect VS Code extension to your local server
7. **Iterate** - Collect feedback and improve your dataset over time

---

*This guide provides a complete path from raw data to a working code assistant. Start with the training script in Phase 2, test it with a small dataset, then expand once you see good results. Good luck with your Csound assistant!*
