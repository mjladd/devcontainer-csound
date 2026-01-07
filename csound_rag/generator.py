"""
Generator for Csound RAG Assistant.

Queries Ollama with retrieved context to generate responses.
"""

from typing import Iterator

import ollama


SYSTEM_PROMPT = """You are an expert Csound programming assistant. You help users write Csound code, understand opcodes, debug issues, and learn synthesis techniques.

Use the reference material provided to give accurate, helpful answers. When providing code examples:
- Use proper Csound syntax with <CsoundSynthesizer> tags for complete examples
- Explain what the code does and why
- Mention relevant opcodes and their parameters

If the reference material doesn't contain enough information to fully answer the question, say so and provide what help you can based on your general knowledge.

Be concise but thorough. Prefer showing working code over lengthy explanations."""


class CsoundGenerator:
    """Generates responses using Ollama."""

    DEFAULT_MODEL = "codellama"

    def __init__(self, model: str | None = None):
        """Initialize generator with model name."""
        self.model = model or self.DEFAULT_MODEL

        # Check if Ollama is available
        try:
            ollama.list()
        except Exception as e:
            raise ConnectionError(
                f"Could not connect to Ollama. Make sure it's running: {e}"
            )

    def check_model(self) -> bool:
        """Check if the configured model is available."""
        try:
            models = ollama.list()
            model_names = [m["name"].split(":")[0] for m in models.get("models", [])]
            return self.model in model_names or f"{self.model}:latest" in [m["name"] for m in models.get("models", [])]
        except Exception:
            return False

    def pull_model(self):
        """Pull the model if not available."""
        print(f"Pulling model {self.model}...")
        ollama.pull(self.model)

    def generate(
        self,
        query: str,
        context: str,
        stream: bool = True,
    ) -> str | Iterator[str]:
        """
        Generate a response using Ollama.

        Args:
            query: User's question
            context: Retrieved context from corpus
            stream: If True, return iterator of chunks

        Returns:
            Complete response string, or iterator of chunks if streaming
        """
        prompt = self._build_prompt(query, context)

        if stream:
            return self._stream_response(prompt)
        else:
            return self._get_response(prompt)

    def _build_prompt(self, query: str, context: str) -> str:
        """Build the full prompt with context and query."""
        return f"""## Reference Material

{context}

## Question

{query}

## Answer

"""

    def _get_response(self, prompt: str) -> str:
        """Get complete response from Ollama."""
        response = ollama.generate(
            model=self.model,
            prompt=prompt,
            system=SYSTEM_PROMPT,
            options={
                "temperature": 0.3,  # Lower temperature for more focused responses
                "num_ctx": 8192,  # Context window
            },
        )
        return response["response"]

    def _stream_response(self, prompt: str) -> Iterator[str]:
        """Stream response chunks from Ollama."""
        stream = ollama.generate(
            model=self.model,
            prompt=prompt,
            system=SYSTEM_PROMPT,
            stream=True,
            options={
                "temperature": 0.3,
                "num_ctx": 8192,
            },
        )

        for chunk in stream:
            yield chunk["response"]

    def list_models(self) -> list[str]:
        """List available Ollama models."""
        try:
            models = ollama.list()
            return [m["name"] for m in models.get("models", [])]
        except Exception:
            return []
