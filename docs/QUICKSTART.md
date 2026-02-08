# Csound Assist - Quick Start Guide

## Prerequisites

1. Python 3.11+ installed
2. Access to Ollama server at `http://d01.consul:3000/`
3. `qwen3-coder` and `nomic-embed-text` models available on the server

## Installation

```bash
# Install in development mode
uv pip install -e "."

# Verify installation
csound-assist --help

# Check Ollama connectivity
curl http://d01.consul:3000/api/tags
```

## First-Time Setup

### 1. Build the Index

The assistant needs to index the corpus before it can answer questions:

```bash
# Index all documentation, CSD examples, and training data
csound-assist index --reset

# Verify the index
csound-assist stats
```

Expected output:

```
Index Statistics
  chunks: 30000+
  embedding_model: nomic-embed-text
  bm25_available: Yes
```

### 2. Test the Connection

```bash
csound-assist search "FM synthesis"
```

## Commands

### Generate Csound Code

```bash
# Simple generation
csound-assist generate "FM bell with bright attack"

# With synthesis technique hint
csound-assist generate "analog-style bass" -t subtractive

# Save to file (auto-validates)
csound-assist generate "granular texture" -o output.csd
```

### Explain Existing Code

```bash
csound-assist explain my_instrument.csd
csound-assist explain my_instrument.csd --detail deep
cat file.csd | csound-assist explain
```

### Complete Partial Code

```bash
csound-assist complete partial.csd --line 25
```

### Debug with Error Context

```bash
csound-assist debug broken.csd -e "INIT ERROR: Invalid ftable no."
```

### Search the Corpus

```bash
csound-assist search "plucked string physical model"
csound-assist search "moogladder" --limit 10
```

### Interactive Chat

```bash
csound-assist chat
```

Slash commands in chat: `/help`, `/clear`, `/save`, `/load`, `/model`, `/rag on|off`, `/exit`

### Validate CSD Syntax

```bash
csound-assist validate my_instrument.csd
```

## MCP Server (Editor Integration)

Add to Claude Desktop config (`claude_desktop_config.json`):

```json
{"mcpServers": {"csound-assist": {"command": "csound-assist", "args": ["mcp"]}}}
```

## Tips for Better Results

1. **Be specific**: "FM brass with vibrato" > "brass sound"
2. **Name the technique**: `-t fm` or mention "using granular synthesis"
3. **Specify requirements**: stereo, MIDI, real-time, output format
4. **Use `--error`**: paste exact Csound error messages for debugging
5. **Use chat mode**: for multi-turn iterative refinement

## Configuration

Edit `csound_assist_config.yaml` in the project root, or `~/.config/csound-assist/config.yaml`.

```bash
# Show current config
csound-assist config --show

# Clear response cache
csound-assist config --clear-cache
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Connection refused" | Check Ollama server is running |
| "Model not found" | Pull model: `ollama pull qwen3-coder` |
| "Embedding model mismatch" | Run `csound-assist index --reset` |
| "Empty results" | Run `csound-assist index` to build index |
| Slow responses | Enable caching in config |
