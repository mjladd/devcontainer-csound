"""
Typer CLI for csound-assist.

Provides 11 commands: generate, explain, complete, debug, chat,
search, index, stats, config, validate, mcp.
"""

import sys
from pathlib import Path
from typing import Optional

import typer
from rich.console import Console

app = typer.Typer(
    name="csound-assist",
    help="AI-powered Csound programming assistant with RAG",
    add_completion=False,
    no_args_is_help=True,
)
console = Console()


def _load_assistant():
    """Lazy-load the assistant to avoid slow imports on --help."""
    from csound_assist.assistant import CsoundAssistant
    from csound_assist.config import load_config
    config = load_config()
    return CsoundAssistant(config), config


def _read_file_or_stdin(file: Optional[Path]) -> str:
    """Read content from a file argument or stdin pipe."""
    from csound_assist.display import is_pipe_input, read_stdin
    if file:
        return file.read_text(encoding="utf-8", errors="replace")
    if is_pipe_input():
        return read_stdin()
    return ""


@app.command()
def generate(
    description: str = typer.Argument(..., help="Description of what to generate"),
    output: Optional[Path] = typer.Option(None, "-o", "--output", help="Save output to file"),
    technique: Optional[str] = typer.Option(None, "-t", "--technique", help="Synthesis technique hint"),
    stream: bool = typer.Option(True, "--stream/--no-stream", help="Stream the response"),
    model: Optional[str] = typer.Option(None, "--model", help="Override LLM model"),
    no_rag: bool = typer.Option(False, "--no-rag", help="Disable RAG context"),
):
    """Generate a complete CSD file from a description."""
    from csound_assist.display import print_error, print_response, print_success, stream_response
    from csound_assist.validator import extract_csd_from_response, validate_csd_text

    assistant, config = _load_assistant()

    if stream:
        generator = assistant.generate(
            description, technique=technique, stream=True, model=model, use_rag=not no_rag,
        )
        response = stream_response(generator)
    else:
        console.print("[dim]Generating...[/dim]")
        response = assistant.generate(
            description, technique=technique, stream=False, model=model, use_rag=not no_rag,
        )
        print_response(response)

    # Save to file if requested
    if output and response:
        csd = extract_csd_from_response(response)
        if csd:
            output.write_text(csd, encoding="utf-8")
            print_success(f"Saved to {output}")
            # Auto-validate
            valid, msg = validate_csd_text(csd)
            if valid:
                print_success("Syntax check: passed")
            else:
                print_error(f"Syntax check failed:\n{msg}")
        else:
            output.write_text(response, encoding="utf-8")
            print_success(f"Saved raw response to {output}")


@app.command()
def explain(
    file: Optional[Path] = typer.Argument(None, help="CSD file to explain (or pipe via stdin)"),
    detail: str = typer.Option("normal", "--detail", help="Detail level: brief, normal, deep"),
    stream: bool = typer.Option(True, "--stream/--no-stream", help="Stream the response"),
    model: Optional[str] = typer.Option(None, "--model", help="Override LLM model"),
    no_rag: bool = typer.Option(False, "--no-rag", help="Disable RAG context"),
):
    """Explain a CSD file or piped Csound code."""
    from csound_assist.display import print_error, print_response, stream_response

    code = _read_file_or_stdin(file)
    if not code:
        print_error("No input provided. Pass a file argument or pipe content via stdin.")
        raise typer.Exit(1)

    assistant, config = _load_assistant()

    if stream:
        generator = assistant.explain(
            code, detail=detail, stream=True, model=model, use_rag=not no_rag,
        )
        stream_response(generator)
    else:
        console.print("[dim]Analyzing...[/dim]")
        response = assistant.explain(
            code, detail=detail, stream=False, model=model, use_rag=not no_rag,
        )
        print_response(response)


@app.command()
def complete(
    file: Optional[Path] = typer.Argument(None, help="Partial CSD file to complete"),
    line: Optional[int] = typer.Option(None, "-l", "--line", help="Split at this line number"),
    column: Optional[int] = typer.Option(None, "-c", "--column", help="Split at this column"),
    stream: bool = typer.Option(True, "--stream/--no-stream", help="Stream the response"),
    model: Optional[str] = typer.Option(None, "--model", help="Override LLM model"),
    no_rag: bool = typer.Option(False, "--no-rag", help="Disable RAG context"),
):
    """Complete partial Csound code."""
    from csound_assist.display import print_error, print_response, stream_response

    code = _read_file_or_stdin(file)
    if not code:
        print_error("No input provided. Pass a file argument or pipe content via stdin.")
        raise typer.Exit(1)

    # Split code at line/column if specified
    code_before = code
    code_after = ""
    if line is not None:
        lines = code.split("\n")
        split_line = min(line - 1, len(lines))
        code_before = "\n".join(lines[:split_line])
        code_after = "\n".join(lines[split_line:])

    assistant, config = _load_assistant()

    if stream:
        generator = assistant.complete(
            code_before, code_after, stream=True, model=model, use_rag=not no_rag,
        )
        stream_response(generator)
    else:
        console.print("[dim]Completing...[/dim]")
        response = assistant.complete(
            code_before, code_after, stream=False, model=model, use_rag=not no_rag,
        )
        print_response(response)


@app.command()
def debug(
    file: Optional[Path] = typer.Argument(None, help="CSD file to debug (or pipe via stdin)"),
    error: Optional[str] = typer.Option(None, "-e", "--error", help="Csound error message"),
    stream: bool = typer.Option(True, "--stream/--no-stream", help="Stream the response"),
    model: Optional[str] = typer.Option(None, "--model", help="Override LLM model"),
    no_rag: bool = typer.Option(False, "--no-rag", help="Disable RAG context"),
):
    """Debug a CSD file with optional error context."""
    from csound_assist.display import print_error, print_response, stream_response

    code = _read_file_or_stdin(file)
    if not code:
        print_error("No input provided. Pass a file argument or pipe content via stdin.")
        raise typer.Exit(1)

    assistant, config = _load_assistant()

    if stream:
        generator = assistant.debug(
            code, error_message=error or "", stream=True, model=model, use_rag=not no_rag,
        )
        stream_response(generator)
    else:
        console.print("[dim]Debugging...[/dim]")
        response = assistant.debug(
            code, error_message=error or "", stream=False, model=model, use_rag=not no_rag,
        )
        print_response(response)


@app.command()
def chat(
    model: Optional[str] = typer.Option(None, "--model", help="Override LLM model"),
    no_rag: bool = typer.Option(False, "--no-rag", help="Disable RAG context"),
):
    """Start an interactive chat session."""
    from csound_assist.chat import run_chat

    assistant, config = _load_assistant()
    run_chat(assistant, config, model=model, no_rag=no_rag)


@app.command()
def search(
    query: str = typer.Argument(..., help="Search query"),
    limit: int = typer.Option(5, "-n", "--limit", help="Number of results"),
    opcodes: bool = typer.Option(False, "--opcodes", help="Search for opcode names"),
    technique: Optional[str] = typer.Option(None, "-t", "--technique", help="Filter by technique"),
):
    """Search the corpus without LLM generation."""
    from csound_assist.display import print_error, print_search_results

    assistant, config = _load_assistant()

    stats = assistant.get_stats()
    if not stats["indexed"]:
        print_error("Index is empty. Run 'csound-assist index' first.")
        raise typer.Exit(1)

    results = assistant.search(query, n_results=limit)
    console.print(f"[dim]Search: {query} ({len(results)} results)[/dim]")
    print_search_results(results)


@app.command()
def index(
    reset: bool = typer.Option(False, "--reset", help="Delete and rebuild entire index"),
    corpus_dir: Optional[Path] = typer.Option(None, "--corpus-dir", help="Corpus directory"),
    skip_csd: bool = typer.Option(False, "--skip-csd", help="Skip CSD file indexing"),
):
    """Index the corpus for RAG retrieval."""
    from csound_assist.display import print_error, print_indexing_progress, print_stats, print_success

    assistant, config = _load_assistant()

    console.print("[bold]Csound Corpus Indexer[/bold]")

    stats = assistant.get_stats()
    if stats["indexed"]:
        console.print(f"[dim]Current index: {stats['chunks']} chunks[/dim]")
        if reset:
            console.print("[yellow]Resetting index...[/yellow]")
    else:
        console.print("[dim]No existing index. Building new...[/dim]")

    result = assistant.indexer.index_all(
        corpus_dir=corpus_dir or Path(config.paths.corpus_dir),
        examples_dir=Path(config.paths.examples_dir),
        training_dir=Path(config.paths.training_dir),
        reset=reset,
        skip_csd=skip_csd,
        progress_callback=print_indexing_progress,
    )

    console.print()
    console.print("[bold]Indexing Complete[/bold]")
    print_stats(result)
    print_success("Index ready. Run 'csound-assist search' to test retrieval.")


@app.command()
def stats(
    cache: bool = typer.Option(False, "--cache", help="Show cache statistics"),
    analytics: bool = typer.Option(False, "--analytics", help="Show analytics summary"),
):
    """Show index and system statistics."""
    from csound_assist.display import print_stats as display_stats

    assistant, config = _load_assistant()
    index_stats = assistant.get_stats()

    console.print("[bold]Csound Assistant Statistics[/bold]")
    display_stats(index_stats)

    if cache:
        from csound_assist.cache import ResponseCache
        rc = ResponseCache(Path(config.paths.cache_dir))
        cache_stats = rc.get_stats()
        console.print("\n[bold]Cache Statistics[/bold]")
        display_stats(cache_stats)

    if analytics:
        from csound_assist.analytics import Analytics
        a = Analytics()
        summary = a.get_summary()
        console.print("\n[bold]Analytics Summary[/bold]")
        display_stats(summary)


@app.command("config")
def config_cmd(
    show: bool = typer.Option(False, "--show", help="Show current configuration"),
    set_value: Optional[str] = typer.Option(None, "--set", help="Set KEY=VALUE"),
    clear_cache: bool = typer.Option(False, "--clear-cache", help="Clear response cache"),
):
    """Show or modify configuration."""
    from csound_assist.config import load_config
    from csound_assist.display import print_success

    config = load_config()

    if show or (not set_value and not clear_cache):
        import dataclasses
        for section_name in ("ollama", "embedding", "rag", "paths", "output", "cache"):
            section = getattr(config, section_name)
            console.print(f"\n[bold cyan]{section_name}:[/bold cyan]")
            for f in dataclasses.fields(section):
                value = getattr(section, f.name)
                console.print(f"  {f.name}: {value}")

    if clear_cache:
        import shutil
        cache_dir = Path(config.paths.cache_dir)
        if cache_dir.exists():
            shutil.rmtree(cache_dir)
            print_success("Cache cleared.")
        else:
            console.print("[dim]No cache to clear.[/dim]")


@app.command()
def validate(
    file: Path = typer.Argument(..., help="CSD file to validate"),
):
    """Validate CSD syntax using Csound."""
    from csound_assist.display import print_validation_result
    from csound_assist.validator import validate_csd

    valid, output = validate_csd(file)
    print_validation_result(valid, output, str(file))
    if not valid:
        raise typer.Exit(1)


@app.command()
def mcp(
    transport: str = typer.Option("stdio", "--transport", help="Transport: stdio or sse"),
):
    """Start the MCP server for editor integration."""
    from csound_assist.mcp_server import run_mcp_server

    run_mcp_server(transport=transport)


if __name__ == "__main__":
    app()
