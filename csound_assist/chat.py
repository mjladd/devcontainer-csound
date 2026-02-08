"""
Interactive REPL chat mode with prompt_toolkit.

Provides multi-turn conversation with history, slash commands,
and optional RAG toggling.
"""

import logging
from pathlib import Path

from rich.console import Console

from csound_assist.assistant import CsoundAssistant
from csound_assist.config import AppConfig
from csound_assist.display import print_csound_code, print_error, print_markdown, stream_response
from csound_assist.prompts import SYSTEM_PROMPT

logger = logging.getLogger(__name__)
console = Console()

SLASH_COMMANDS_HELP = """
**Slash Commands:**
- `/help`         - Show this help
- `/clear`        - Clear conversation history
- `/save <file>`  - Save last response to file
- `/load <file>`  - Load and explain a CSD file
- `/model <name>` - Switch LLM model
- `/rag on|off`   - Toggle RAG context retrieval
- `/exit`         - Exit chat mode
"""


class ChatSession:
    """Interactive chat session with conversation history."""

    def __init__(self, assistant: CsoundAssistant, config: AppConfig):
        self.assistant = assistant
        self.config = config
        self.history: list[dict] = [
            {"role": "system", "content": SYSTEM_PROMPT},
        ]
        self.use_rag = True
        self.model = config.ollama.model
        self.last_response = ""

    def _add_context_to_message(self, user_input: str) -> str:
        """Add RAG context to the user message if enabled."""
        if not self.use_rag:
            return user_input

        try:
            context = self.assistant.indexer.get_relevant_context(
                user_input, max_tokens=2000, n_results=5,
            )
            if context:
                return f"Relevant context:\n{context}\n\n---\n\nUser: {user_input}"
        except Exception as e:
            logger.warning("RAG context retrieval failed: %s", e)

        return user_input

    def chat(self, user_input: str) -> str:
        """Process a chat message and return the response."""
        enriched = self._add_context_to_message(user_input)
        self.history.append({"role": "user", "content": enriched})

        # Truncate history if too long (keep system + last 20 turns)
        if len(self.history) > 42:
            self.history = [self.history[0]] + self.history[-40:]

        try:
            response = self.assistant.llm.generate(
                self.history, model=self.model, stream=False,
            )
            self.history.append({"role": "assistant", "content": response})
            self.last_response = response
            return response
        except Exception as e:
            error_msg = f"Error: {e}"
            logger.error("Chat error: %s", e)
            return error_msg

    def chat_stream(self, user_input: str):
        """Process a chat message with streaming response."""
        enriched = self._add_context_to_message(user_input)
        self.history.append({"role": "user", "content": enriched})

        if len(self.history) > 42:
            self.history = [self.history[0]] + self.history[-40:]

        try:
            generator = self.assistant.llm.generate(
                self.history, model=self.model, stream=True,
            )
            full_response = stream_response(generator)
            self.history.append({"role": "assistant", "content": full_response})
            self.last_response = full_response
        except Exception as e:
            logger.error("Chat stream error: %s", e)
            print_error(str(e))

    def handle_slash_command(self, command: str) -> bool:
        """
        Handle a slash command.

        Returns True if the command was handled, False if chat should exit.
        """
        parts = command.strip().split(maxsplit=1)
        cmd = parts[0].lower()
        arg = parts[1] if len(parts) > 1 else ""

        if cmd == "/help":
            print_markdown(SLASH_COMMANDS_HELP)
        elif cmd == "/clear":
            self.history = [self.history[0]]
            console.print("[dim]Conversation history cleared.[/dim]")
        elif cmd == "/save":
            if not arg:
                print_error("Usage: /save <filename>")
            elif self.last_response:
                Path(arg).write_text(self.last_response, encoding="utf-8")
                console.print(f"[dim]Saved to {arg}[/dim]")
            else:
                print_error("No response to save.")
        elif cmd == "/load":
            if not arg:
                print_error("Usage: /load <filename>")
            else:
                try:
                    code = Path(arg).read_text(encoding="utf-8")
                    console.print(f"[dim]Loaded {arg} ({len(code)} chars). Explaining...[/dim]")
                    self.chat_stream(f"Explain this Csound code:\n\n```csound\n{code}\n```")
                except FileNotFoundError:
                    print_error(f"File not found: {arg}")
        elif cmd == "/model":
            if not arg:
                console.print(f"[dim]Current model: {self.model}[/dim]")
            else:
                self.model = arg
                console.print(f"[dim]Switched to model: {self.model}[/dim]")
        elif cmd == "/rag":
            if arg.lower() in ("on", "true", "1"):
                self.use_rag = True
                console.print("[dim]RAG context enabled.[/dim]")
            elif arg.lower() in ("off", "false", "0"):
                self.use_rag = False
                console.print("[dim]RAG context disabled.[/dim]")
            else:
                state = "on" if self.use_rag else "off"
                console.print(f"[dim]RAG is {state}. Usage: /rag on|off[/dim]")
        elif cmd in ("/exit", "/quit", "/q"):
            return False
        else:
            print_error(f"Unknown command: {cmd}. Type /help for available commands.")

        return True


def run_chat(
    assistant: CsoundAssistant,
    config: AppConfig,
    model: str | None = None,
    no_rag: bool = False,
):
    """
    Run the interactive chat REPL.

    Uses prompt_toolkit for readline-like editing, history, and auto-suggest.
    """
    try:
        from prompt_toolkit import PromptSession
        from prompt_toolkit.auto_suggest import AutoSuggestFromHistory
        from prompt_toolkit.history import FileHistory
    except ImportError:
        print_error("prompt-toolkit is required for chat mode. Install with: pip install prompt-toolkit")
        return

    session = ChatSession(assistant, config)
    if model:
        session.model = model
    if no_rag:
        session.use_rag = False

    # Set up prompt_toolkit session
    history_path = Path.home() / ".csound-assist" / "chat_history"
    history_path.parent.mkdir(parents=True, exist_ok=True)

    prompt_session = PromptSession(
        history=FileHistory(str(history_path)),
        auto_suggest=AutoSuggestFromHistory(),
    )

    console.print("[bold cyan]Csound Assistant Chat[/bold cyan]")
    console.print("[dim]Type /help for commands, /exit to quit.[/dim]")
    rag_state = "on" if session.use_rag else "off"
    console.print(f"[dim]Model: {session.model} | RAG: {rag_state}[/dim]\n")

    while True:
        try:
            user_input = prompt_session.prompt("csound> ").strip()
        except (EOFError, KeyboardInterrupt):
            console.print("\n[dim]Goodbye![/dim]")
            break

        if not user_input:
            continue

        if user_input.startswith("/"):
            should_continue = session.handle_slash_command(user_input)
            if not should_continue:
                console.print("[dim]Goodbye![/dim]")
                break
            continue

        session.chat_stream(user_input)
        console.print()  # blank line after response
