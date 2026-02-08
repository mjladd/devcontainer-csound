"""
Ollama LLM client wrapper with streaming support.

Provides connection verification, model availability checks,
and configurable generation parameters.
"""

import logging
from typing import Generator

try:
    from ollama import Client as OllamaClient
    HAS_OLLAMA = True
except ImportError:
    HAS_OLLAMA = False
    OllamaClient = None

from csound_assist.config import OllamaConfig

logger = logging.getLogger(__name__)


class LLMClient:
    """
    Wrapper around the Ollama client for LLM interactions.

    Provides streaming, connection checks, and parameter management.
    """

    def __init__(self, config: OllamaConfig | None = None):
        if not HAS_OLLAMA:
            raise ImportError("ollama is required. Install with: pip install ollama")

        self.config = config or OllamaConfig()
        self._client = OllamaClient(host=self.config.base_url)

    def check_connection(self) -> bool:
        """Verify Ollama server is reachable."""
        try:
            self._client.list()
            return True
        except Exception as e:
            logger.error("Ollama connection failed: %s", e)
            return False

    def check_model(self, model: str | None = None) -> bool:
        """Check if the specified model is available."""
        model = model or self.config.model
        try:
            self._client.show(model)
            return True
        except Exception:
            return False

    def list_models(self) -> list[str]:
        """List available models on the Ollama server."""
        try:
            response = self._client.list()
            return [m["name"] for m in response.get("models", [])]
        except Exception:
            return []

    def generate(
        self,
        messages: list[dict],
        model: str | None = None,
        temperature: float | None = None,
        stream: bool = False,
    ) -> str | Generator[str, None, None]:
        """
        Generate a response from the LLM.

        Args:
            messages: Chat messages [{"role": "...", "content": "..."}]
            model: Override model name
            temperature: Override temperature
            stream: If True, returns a generator yielding tokens

        Returns:
            Complete response string, or generator if stream=True
        """
        model = model or self.config.model
        temp = temperature if temperature is not None else self.config.temperature

        options = {
            "temperature": temp,
            "top_p": self.config.top_p,
            "num_ctx": self.config.num_ctx,
        }

        if stream:
            return self._stream(messages, model, options)

        try:
            response = self._client.chat(
                model=model,
                messages=messages,
                options=options,
            )
            return response["message"]["content"]
        except Exception as e:
            logger.error("LLM generation error: %s", e)
            raise

    def _stream(
        self,
        messages: list[dict],
        model: str,
        options: dict,
    ) -> Generator[str, None, None]:
        """Stream response tokens."""
        try:
            stream = self._client.chat(
                model=model,
                messages=messages,
                options=options,
                stream=True,
            )
            for chunk in stream:
                content = chunk["message"]["content"]
                if content:
                    yield content
        except Exception as e:
            logger.error("LLM streaming error: %s", e)
            raise
