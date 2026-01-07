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
    "--db-path",
    type=click.Path(path_type=Path),
    default=DEFAULT_DB_PATH,
    help="Path to ChromaDB database",
)
@click.pass_context
def cli(ctx, corpus_dir, db_path):
    """Csound RAG Assistant - Ask questions about Csound programming."""
    ctx.ensure_object(dict)
    ctx.obj["corpus_dir"] = corpus_dir
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
@click.pass_context
def index(ctx, reset):
    """Build or rebuild the corpus index."""
    from .indexer import CsoundIndexer

    corpus_dir = ctx.obj["corpus_dir"]
    db_path = ctx.obj["db_path"]

    if not corpus_dir.exists():
        console.print(f"[red]Corpus directory not found: {corpus_dir}[/red]")
        sys.exit(1)

    console.print(f"[bold]Indexing corpus from {corpus_dir}[/bold]")
    console.print(f"Database path: {db_path}\n")

    indexer = CsoundIndexer(db_path)
    stats = indexer.index_corpus(corpus_dir, reset=reset)

    console.print("\n[bold green]Indexing complete![/bold green]")
    console.print(f"  Documents: {stats['documents']}")
    console.print(f"  Chunks: {stats['chunks']}")
    console.print(f"  Sources: {', '.join(stats['sources'])}")


@cli.command()
@click.pass_context
def status(ctx):
    """Show index status and statistics."""
    from .indexer import CsoundIndexer

    db_path = ctx.obj["db_path"]
    corpus_dir = ctx.obj["corpus_dir"]

    console.print("[bold]Csound RAG Assistant Status[/bold]\n")

    # Corpus info
    console.print(f"Corpus directory: {corpus_dir}")
    if corpus_dir.exists():
        corpus_dirs = [d.name for d in corpus_dir.iterdir() if d.is_dir()]
        console.print(f"  Sources: {', '.join(sorted(corpus_dirs)[:5])}...")
    else:
        console.print("  [red]Not found[/red]")

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


def main():
    """Entry point for CLI."""
    cli()


if __name__ == "__main__":
    main()
