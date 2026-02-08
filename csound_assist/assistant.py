"""
Main RAG+LLM pipeline for the Csound assistant.

Combines retrieval, prompt construction, and LLM generation
for each task type (generate, explain, complete, debug).
"""

import logging
from pathlib import Path
from typing import Generator

from csound_assist.config import AppConfig, load_config
from csound_assist.indexer import CsoundIndexer
from csound_assist.llm_client import LLMClient
from csound_assist.prompts import (
    COMPLETION_TEMPLATE,
    DEBUG_TEMPLATE,
    DETAIL_LEVELS,
    EXPLANATION_TEMPLATE,
    GENERATION_TEMPLATE,
    SYSTEM_PROMPT,
    get_technique_hint,
)
from csound_assist.validator import extract_csd_from_response, validate_csd_text

logger = logging.getLogger(__name__)


class CsoundAssistant:
    """
    RAG-based Csound programming assistant.

    Orchestrates retrieval from the indexed corpus and LLM generation
    for code generation, explanation, completion, and debugging tasks.
    """

    def __init__(self, config: AppConfig | None = None):
        self.config = config or load_config()

        self.indexer = CsoundIndexer(
            db_path=Path(self.config.paths.db_path),
            embedding_model=self.config.embedding.model,
            ollama_url=self.config.ollama.base_url,
        )

        self.llm = LLMClient(self.config.ollama)

    def _get_context(self, query: str, max_tokens: int | None = None) -> str:
        """Retrieve relevant context from the corpus."""
        max_tokens = max_tokens or self.config.rag.max_context_tokens
        try:
            return self.indexer.get_relevant_context(
                query,
                max_tokens=max_tokens,
                n_results=self.config.rag.num_results,
            )
        except Exception as e:
            logger.warning("Context retrieval failed: %s", e)
            return ""

    def _chat(
        self,
        user_prompt: str,
        system_prompt: str = SYSTEM_PROMPT,
        stream: bool = False,
        model: str | None = None,
    ) -> str | Generator[str, None, None]:
        """Send a chat request to the LLM."""
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ]
        return self.llm.generate(messages, model=model, stream=stream)

    def generate(
        self,
        description: str,
        technique: str | None = None,
        stream: bool = False,
        model: str | None = None,
        use_rag: bool = True,
    ) -> str | Generator[str, None, None]:
        """
        Generate a CSD file from a description.

        Args:
            description: What to generate
            technique: Optional synthesis technique hint
            stream: Stream the response
            model: Override model
            use_rag: Whether to use RAG context

        Returns:
            Generated CSD code (or stream generator)
        """
        context = self._get_context(description) if use_rag else ""
        technique_hint = get_technique_hint(technique)

        prompt = GENERATION_TEMPLATE.format(
            context=context or "[No relevant context found]",
            description=description,
            technique_hint=technique_hint,
        )

        return self._chat(prompt, stream=stream, model=model)

    def explain(
        self,
        code: str,
        detail: str = "normal",
        stream: bool = False,
        model: str | None = None,
        use_rag: bool = True,
    ) -> str | Generator[str, None, None]:
        """
        Explain Csound code.

        Args:
            code: Csound code to explain
            detail: Detail level (brief, normal, deep)
            stream: Stream the response
            model: Override model
            use_rag: Whether to use RAG context
        """
        # Build a query from the code for context retrieval
        from csound_assist.opcode_data import detect_opcodes, infer_techniques
        opcodes = detect_opcodes(code)
        techniques = infer_techniques(opcodes)
        query = f"Csound code using {', '.join(opcodes[:5])} for {', '.join(techniques[:3])}"

        context = self._get_context(query) if use_rag else ""
        detail_instruction = DETAIL_LEVELS.get(detail, "")

        prompt = EXPLANATION_TEMPLATE.format(
            context=context or "[No relevant context found]",
            code=code,
            detail_instruction=detail_instruction,
        )

        return self._chat(prompt, stream=stream, model=model)

    def complete(
        self,
        code_before: str,
        code_after: str = "",
        stream: bool = False,
        model: str | None = None,
        use_rag: bool = True,
    ) -> str | Generator[str, None, None]:
        """
        Complete partial Csound code.

        Args:
            code_before: Code before the cursor
            code_after: Code after the cursor (if any)
            stream: Stream the response
            model: Override model
            use_rag: Whether to use RAG context
        """
        context = self._get_context(code_before[-500:]) if use_rag else ""
        after_hint = ""
        if code_after:
            after_hint = f"Code after the cursor:\n```csound\n{code_after}\n```"

        prompt = COMPLETION_TEMPLATE.format(
            context=context or "[No relevant context found]",
            code_before=code_before,
            after_hint=after_hint,
        )

        return self._chat(prompt, stream=stream, model=model)

    def debug(
        self,
        code: str,
        error_message: str = "",
        stream: bool = False,
        model: str | None = None,
        use_rag: bool = True,
    ) -> str | Generator[str, None, None]:
        """
        Debug Csound code with optional error context.

        Args:
            code: Csound code to debug
            error_message: Csound error output
            stream: Stream the response
            model: Override model
            use_rag: Whether to use RAG context
        """
        query = f"debug Csound error: {error_message}" if error_message else code[:500]
        context = self._get_context(query) if use_rag else ""

        error_info = ""
        if error_message:
            error_info = f"Csound error output:\n```\n{error_message}\n```"
        else:
            error_info = "No specific error message provided. Analyze the code for common issues."

        prompt = DEBUG_TEMPLATE.format(
            context=context or "[No relevant context found]",
            code=code,
            error_info=error_info,
        )

        return self._chat(prompt, stream=stream, model=model)

    def search(
        self,
        query: str,
        n_results: int = 5,
    ) -> list[dict]:
        """Search the corpus without LLM generation."""
        return self.indexer.search(query, n_results=n_results)

    def get_stats(self) -> dict:
        """Get index statistics."""
        return self.indexer.get_stats()

    def validate_response(self, response: str) -> tuple[bool, str] | None:
        """
        Try to validate any CSD code found in a response.

        Returns (is_valid, message) or None if no CSD found.
        """
        csd = extract_csd_from_response(response)
        if csd is None:
            return None
        return validate_csd_text(csd)
