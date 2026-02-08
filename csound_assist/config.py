"""
Configuration management for csound-assist.

Precedence: CLI flags > env vars > ./csound_assist_config.yaml > ~/.config/csound-assist/config.yaml > defaults
"""

import os
from dataclasses import dataclass, field
from pathlib import Path

import yaml


@dataclass
class OllamaConfig:
    base_url: str = "http://d01.consul:3000"
    model: str = "qwen3-coder"
    temperature: float = 0.7
    top_p: float = 0.8
    max_tokens: int = 4096
    num_ctx: int = 32768
    timeout: int = 120


@dataclass
class EmbeddingConfig:
    model: str = "nomic-embed-text"
    chunk_size: int = 1000
    chunk_overlap: int = 200


@dataclass
class RagConfig:
    max_context_tokens: int = 3000
    min_similarity: float = 0.5
    num_results: int = 5
    semantic_weight: float = 0.5
    bm25_weight: float = 0.5


@dataclass
class PathsConfig:
    corpus_dir: str = "./corpus"
    examples_dir: str = "./csound_score_examples"
    training_dir: str = "./csound_corpus"
    db_path: str = "./.cache/csound_assist_db"
    cache_dir: str = "./.cache/csound_assist_cache"
    bm25_cache: str = "./.cache/bm25_index.pkl"


@dataclass
class OutputConfig:
    stream: bool = True
    syntax_highlight: bool = True
    show_sources: bool = True
    verbose: bool = False


@dataclass
class CacheConfig:
    enabled: bool = True
    ttl_hours: int = 24
    max_size_mb: int = 100


@dataclass
class AppConfig:
    ollama: OllamaConfig = field(default_factory=OllamaConfig)
    embedding: EmbeddingConfig = field(default_factory=EmbeddingConfig)
    rag: RagConfig = field(default_factory=RagConfig)
    paths: PathsConfig = field(default_factory=PathsConfig)
    output: OutputConfig = field(default_factory=OutputConfig)
    cache: CacheConfig = field(default_factory=CacheConfig)


def _merge_dict_into_dataclass(dc, d: dict):
    """Merge a dictionary into a dataclass, updating only known fields."""
    for key, value in d.items():
        if hasattr(dc, key):
            setattr(dc, key, value)


def load_config(config_path: Path | None = None) -> AppConfig:
    """
    Load configuration with precedence handling.

    Checks (in order):
    1. Explicit config_path argument
    2. CSOUND_ASSIST_CONFIG env var
    3. ./csound_assist_config.yaml (project root)
    4. ~/.config/csound-assist/config.yaml (user config)
    5. Defaults
    """
    config = AppConfig()

    # Find config file
    paths_to_check = []
    if config_path:
        paths_to_check.append(config_path)

    env_path = os.environ.get("CSOUND_ASSIST_CONFIG")
    if env_path:
        paths_to_check.append(Path(env_path))

    paths_to_check.extend([
        Path("csound_assist_config.yaml"),
        Path.home() / ".config" / "csound-assist" / "config.yaml",
    ])

    for path in paths_to_check:
        if path.exists():
            try:
                with open(path) as f:
                    data = yaml.safe_load(f) or {}
                _apply_yaml_config(config, data)
                break
            except Exception:
                continue

    # Apply environment variable overrides
    _apply_env_overrides(config)

    return config


def _apply_yaml_config(config: AppConfig, data: dict):
    """Apply YAML config data to the config object."""
    if "ollama" in data:
        _merge_dict_into_dataclass(config.ollama, data["ollama"])
    if "embedding" in data:
        _merge_dict_into_dataclass(config.embedding, data["embedding"])
    if "rag" in data:
        _merge_dict_into_dataclass(config.rag, data["rag"])
    if "paths" in data:
        _merge_dict_into_dataclass(config.paths, data["paths"])
    if "output" in data:
        _merge_dict_into_dataclass(config.output, data["output"])
    if "cache" in data:
        _merge_dict_into_dataclass(config.cache, data["cache"])


def _apply_env_overrides(config: AppConfig):
    """Apply environment variable overrides."""
    env_map = {
        "CSOUND_ASSIST_OLLAMA_URL": ("ollama", "base_url"),
        "CSOUND_ASSIST_MODEL": ("ollama", "model"),
        "CSOUND_ASSIST_EMBEDDING_MODEL": ("embedding", "model"),
        "CSOUND_ASSIST_DB_PATH": ("paths", "db_path"),
    }

    for env_var, (section, key) in env_map.items():
        value = os.environ.get(env_var)
        if value is not None:
            sub_config = getattr(config, section)
            if hasattr(sub_config, key):
                setattr(sub_config, key, value)
