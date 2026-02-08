"""
Rich output formatting for the Csound assistant.

Provides Csound syntax highlighting, streaming display,
panel/table formatting, and source citations.
"""

import sys

from rich.console import Console
from rich.live import Live
from rich.markdown import Markdown
from rich.panel import Panel
from rich.syntax import Syntax
from rich.table import Table
from rich.text import Text

console = Console()
error_console = Console(stderr=True)


def print_error(message: str):
    """Print an error message to stderr."""
    error_console.print(f"[bold red]Error:[/bold red] {message}")


def print_warning(message: str):
    """Print a warning message to stderr."""
    error_console.print(f"[bold yellow]Warning:[/bold yellow] {message}")


def print_success(message: str):
    """Print a success message."""
    console.print(f"[bold green]{message}[/bold green]")


def print_csound_code(code: str, title: str = ""):
    """Print Csound code with syntax highlighting."""
    # Pygments supports CsoundOrchestra and CsoundScore lexers
    # For mixed CSD files, use the orchestra lexer as it handles most content
    syntax = Syntax(
        code,
        "csound",
        theme="monokai",
        line_numbers=True,
        word_wrap=True,
    )
    if title:
        console.print(Panel(syntax, title=title, border_style="blue"))
    else:
        console.print(syntax)


def print_markdown(text: str):
    """Print markdown-formatted text."""
    md = Markdown(text)
    console.print(md)


def print_response(text: str, show_sources: bool = True):
    """
    Print an LLM response with proper formatting.

    Detects code blocks and renders them with syntax highlighting.
    """
    # Simple approach: render as markdown which handles code blocks
    print_markdown(text)


def stream_response(token_generator, show_sources: bool = True) -> str:
    """
    Stream LLM response tokens with live display.

    Returns the complete response text.
    """
    full_response = ""
    with Live(Text(""), console=console, refresh_per_second=10) as live:
        for token in token_generator:
            full_response += token
            # Update display with accumulated text
            live.update(Markdown(full_response))
    return full_response


def print_search_results(results: list[dict]):
    """Print search results in a formatted table."""
    if not results:
        console.print("[dim]No results found.[/dim]")
        return

    for i, result in enumerate(results, 1):
        source = result.get("metadata", {}).get("source", "unknown")
        section = result.get("metadata", {}).get("section", "")
        rrf_score = result.get("rrf_score")
        distance = result.get("distance")

        # Header line
        score_str = ""
        if rrf_score is not None:
            score_str = f" (RRF: {rrf_score:.4f})"
        elif distance is not None:
            score_str = f" (distance: {distance:.4f})"

        console.print(f"\n[bold cyan][{i}][/bold cyan]{score_str}")
        console.print(f"  [dim]Source: {source}[/dim]")
        if section:
            console.print(f"  [dim]Section: {section}[/dim]")

        # Content preview
        content = result.get("content", "")
        if len(content) > 500:
            content = content[:500] + "..."
        console.print(Panel(content, border_style="dim"))


def print_stats(stats: dict):
    """Print index statistics as a formatted table."""
    table = Table(title="Index Statistics", show_header=True, header_style="bold cyan")
    table.add_column("Property", style="bold")
    table.add_column("Value")

    for key, value in stats.items():
        if isinstance(value, bool):
            value_str = "[green]Yes[/green]" if value else "[red]No[/red]"
        elif isinstance(value, list):
            value_str = ", ".join(str(v) for v in value) if value else "[dim]none[/dim]"
        else:
            value_str = str(value)
        table.add_row(key, value_str)

    console.print(table)


def print_indexing_progress(phase: str, current: int, total: int):
    """Print indexing progress."""
    if total > 0:
        pct = (current / total) * 100
        console.print(
            f"\r  [{phase}] {current}/{total} ({pct:.0f}%)",
            end="",
        )
        if current == total:
            console.print()  # newline at end


def print_validation_result(valid: bool, output: str, filepath: str = ""):
    """Print CSD validation result."""
    if valid:
        label = filepath or "CSD"
        print_success(f"{label}: syntax OK")
    else:
        print_error(f"Validation failed:")
        console.print(output)


def is_pipe_input() -> bool:
    """Check if stdin has piped input."""
    return not sys.stdin.isatty()


def read_stdin() -> str:
    """Read all input from stdin."""
    return sys.stdin.read()
