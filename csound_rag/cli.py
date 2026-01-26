"""
CLI for Csound RAG Assistant.

Usage:
    csound-rag query "how do I create an oscillator?"
    csound-rag index
    csound-rag status
"""

import sys
from pathlib import Path

import click
from rich.console import Console
from rich.markdown import Markdown
from rich.panel import Panel
from rich.progress import Progress

# Default paths
DEFAULT_CORPUS_DIR = Path(__file__).parent.parent / "corpus"
DEFAULT_EXAMPLES_DIR = Path(__file__).parent.parent / "csound_examples"
DEFAULT_DB_PATH = Path(__file__).parent.parent / ".cache" / "csound_rag_db"


console = Console()


@click.group()
@click.option(
    "--corpus-dir",
    type=click.Path(exists=True, path_type=Path),
    default=DEFAULT_CORPUS_DIR,
    help="Path to corpus directory",
)
@click.option(
    "--examples-dir",
    type=click.Path(path_type=Path),
    default=DEFAULT_EXAMPLES_DIR,
    help="Path to .csd examples directory",
)
@click.option(
    "--db-path",
    type=click.Path(path_type=Path),
    default=DEFAULT_DB_PATH,
    help="Path to ChromaDB database",
)
@click.pass_context
def cli(ctx, corpus_dir, examples_dir, db_path):
    """Csound RAG Assistant - Ask questions about Csound programming."""
    ctx.ensure_object(dict)
    ctx.obj["corpus_dir"] = corpus_dir
    ctx.obj["examples_dir"] = examples_dir
    ctx.obj["db_path"] = db_path


@cli.command()
@click.argument("question")
@click.option(
    "--sources",
    "-s",
    multiple=True,
    help="Filter to specific sources (e.g., -s opcode_reference -s floss_manual)",
)
@click.option(
    "--code-only",
    is_flag=True,
    help="Only search chunks containing code",
)
@click.option(
    "--n-results",
    "-n",
    default=5,
    help="Number of context chunks to retrieve",
)
@click.option(
    "--model",
    "-m",
    default="codellama",
    help="Ollama model to use",
)
@click.option(
    "--show-sources",
    is_flag=True,
    help="Show source citations after response",
)
@click.pass_context
def query(ctx, question, sources, code_only, n_results, model, show_sources):
    """Ask a question about Csound programming."""
    from .retriever import CsoundRetriever
    from .generator import CsoundGenerator

    db_path = ctx.obj["db_path"]

    # Check if index exists
    if not db_path.exists():
        console.print(
            "[red]Index not found. Run 'csound-rag index' first.[/red]"
        )
        sys.exit(1)

    try:
        retriever = CsoundRetriever(db_path)
    except (FileNotFoundError, ValueError) as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)

    # Search for relevant context
    console.print("[dim]Searching corpus...[/dim]")
    results = retriever.search(
        query=question,
        n_results=n_results,
        sources=list(sources) if sources else None,
        code_only=code_only,
    )

    if not results:
        console.print("[yellow]No relevant context found in corpus.[/yellow]")
        context = "No relevant reference material found."
    else:
        context = retriever.format_context(results)

    # Initialize generator
    try:
        generator = CsoundGenerator(model=model)
    except ConnectionError as e:
        console.print(f"[red]Error: {e}[/red]")
        console.print("[dim]Make sure Ollama is running: ollama serve[/dim]")
        sys.exit(1)

    # Check if model is available
    if not generator.check_model():
        console.print(f"[yellow]Model '{model}' not found. Pulling...[/yellow]")
        try:
            generator.pull_model()
        except Exception as e:
            console.print(f"[red]Failed to pull model: {e}[/red]")
            sys.exit(1)

    # Generate response
    console.print("[dim]Generating response...[/dim]\n")

    response_text = ""
    for chunk in generator.generate(question, context, stream=True):
        console.print(chunk, end="")
        response_text += chunk

    console.print("\n")

    # Show sources if requested
    if show_sources and results:
        console.print("\n[dim]Sources:[/dim]")
        for i, result in enumerate(results, 1):
            source_info = f"  {i}. [{result.source}] {result.title}"
            if result.section and result.section != result.title:
                source_info += f" - {result.section}"
            console.print(f"[dim]{source_info}[/dim]")


@cli.command()
@click.option(
    "--reset",
    is_flag=True,
    help="Delete existing index and rebuild from scratch",
)
@click.option(
    "--skip-examples",
    is_flag=True,
    help="Skip indexing .csd example files",
)
@click.pass_context
def index(ctx, reset, skip_examples):
    """Build or rebuild the corpus index."""
    from .indexer import CsoundIndexer

    corpus_dir = ctx.obj["corpus_dir"]
    examples_dir = ctx.obj["examples_dir"]
    db_path = ctx.obj["db_path"]

    if not corpus_dir.exists():
        console.print(f"[red]Corpus directory not found: {corpus_dir}[/red]")
        sys.exit(1)

    console.print(f"[bold]Indexing corpus from {corpus_dir}[/bold]")
    if not skip_examples and examples_dir.exists():
        console.print(f"[bold]Including .csd examples from {examples_dir}[/bold]")
    console.print(f"Database path: {db_path}\n")

    indexer = CsoundIndexer(db_path)

    # Pass examples_dir only if not skipped and exists
    ex_dir = None if skip_examples or not examples_dir.exists() else examples_dir
    stats = indexer.index_corpus(corpus_dir, reset=reset, examples_dir=ex_dir)

    console.print("\n[bold green]Indexing complete![/bold green]")
    console.print(f"  Documents: {stats['documents']}")
    if stats.get('csd_files', 0) > 0:
        console.print(f"  CSD Examples: {stats['csd_files']}")
    console.print(f"  Total Chunks: {stats['chunks']}")
    console.print(f"  Sources: {', '.join(stats['sources'])}")


@cli.command()
@click.pass_context
def status(ctx):
    """Show index status and statistics."""
    from .indexer import CsoundIndexer

    db_path = ctx.obj["db_path"]
    corpus_dir = ctx.obj["corpus_dir"]
    examples_dir = ctx.obj["examples_dir"]

    console.print("[bold]Csound RAG Assistant Status[/bold]\n")

    # Corpus info
    console.print(f"Corpus directory: {corpus_dir}")
    if corpus_dir.exists():
        corpus_dirs = [d.name for d in corpus_dir.iterdir() if d.is_dir()]
        console.print(f"  Sources: {', '.join(sorted(corpus_dirs)[:5])}...")
        md_count = len(list(corpus_dir.rglob("*.md")))
        console.print(f"  Markdown files: {md_count}")
    else:
        console.print("  [red]Not found[/red]")

    # Examples info
    console.print(f"\nExamples directory: {examples_dir}")
    if examples_dir.exists():
        csd_count = len(list(examples_dir.rglob("*.csd")))
        console.print(f"  CSD files: {csd_count}")
    else:
        console.print("  [yellow]Not found[/yellow]")

    # Index info
    console.print(f"\nDatabase path: {db_path}")
    if db_path.exists():
        indexer = CsoundIndexer(db_path)
        stats = indexer.get_stats()
        if stats["indexed"]:
            console.print(f"  Indexed chunks: {stats['chunks']}")
        else:
            console.print("  [yellow]Not indexed[/yellow]")
    else:
        console.print("  [yellow]Not created[/yellow]")

    # Ollama info
    console.print("\nOllama:")
    try:
        import ollama
        models = ollama.list()
        model_names = [m["name"] for m in models.get("models", [])]
        if model_names:
            console.print(f"  Available models: {', '.join(model_names[:5])}")
        else:
            console.print("  [yellow]No models installed[/yellow]")
    except Exception as e:
        console.print(f"  [red]Not available: {e}[/red]")


@cli.command()
@click.pass_context
def sources(ctx):
    """List available corpus sources."""
    from .retriever import CsoundRetriever

    db_path = ctx.obj["db_path"]

    if not db_path.exists():
        console.print("[red]Index not found. Run 'csound-rag index' first.[/red]")
        sys.exit(1)

    try:
        retriever = CsoundRetriever(db_path)
        source_list = retriever.get_sources()

        console.print("[bold]Available corpus sources:[/bold]\n")
        for source in source_list:
            console.print(f"  - {source}")

        console.print(f"\nUse --sources/-s to filter queries to specific sources.")

    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)


@cli.command()
@click.argument("search_term")
@click.option(
    "--opcode",
    "-o",
    is_flag=True,
    help="Search for examples using specific opcode",
)
@click.option(
    "--category",
    "-c",
    type=click.Choice([
        "oscillators", "filters", "envelopes", "effects", "granular",
        "physical_models", "fm_synthesis", "sample_playback", "analysis",
        "midi", "noise", "math"
    ]),
    help="Filter by synthesis category",
)
@click.option(
    "--n-results",
    "-n",
    default=10,
    help="Number of results to show",
)
@click.pass_context
def examples(ctx, search_term, opcode, category, n_results):
    """Search for .csd example files by opcode or technique."""
    from .retriever import CsoundRetriever

    db_path = ctx.obj["db_path"]

    if not db_path.exists():
        console.print("[red]Index not found. Run 'csound-rag index' first.[/red]")
        sys.exit(1)

    try:
        retriever = CsoundRetriever(db_path)

        # Build query based on options
        if opcode:
            query = f"csound example using {search_term} opcode"
        else:
            query = f"csound {search_term}"

        # Search only in csd_examples source
        results = retriever.search(
            query=query,
            n_results=n_results,
            sources=["csd_examples"],
            code_only=True,
        )

        if not results:
            console.print(f"[yellow]No examples found for '{search_term}'[/yellow]")
            return

        console.print(f"[bold]Found {len(results)} examples for '{search_term}':[/bold]\n")

        seen_files = set()
        for result in results:
            # Skip if we've already shown this file
            if result.path in seen_files:
                continue
            seen_files.add(result.path)

            console.print(f"[bold cyan]{result.title}[/bold cyan]")
            console.print(f"  Path: {result.path}")
            if result.section != "Summary":
                console.print(f"  Section: {result.section}")
            console.print()

    except Exception as e:
        console.print(f"[red]Error: {e}[/red]")
        sys.exit(1)


def main():
    """Entry point for CLI."""
    cli()


if __name__ == "__main__":
    main()
