"""
File-based response cache for the Csound assistant.

Caches LLM responses based on SHA-256 keys derived from
(query + context_hash + model). Supports TTL and LRU eviction.
"""

import hashlib
import json
import logging
import time
from pathlib import Path

logger = logging.getLogger(__name__)

DEFAULT_CACHE_DIR = Path(".cache/csound_assist_cache")
DEFAULT_TTL_HOURS = 24
DEFAULT_MAX_SIZE_MB = 100


class ResponseCache:
    """
    File-based response cache with TTL and size limits.

    Each cached response is stored as a JSON file named by its SHA-256 key.
    """

    def __init__(
        self,
        cache_dir: Path = DEFAULT_CACHE_DIR,
        ttl_hours: int = DEFAULT_TTL_HOURS,
        max_size_mb: int = DEFAULT_MAX_SIZE_MB,
        enabled: bool = True,
    ):
        self.cache_dir = cache_dir
        self.ttl_seconds = ttl_hours * 3600
        self.max_size_bytes = max_size_mb * 1024 * 1024
        self.enabled = enabled

        if enabled:
            self.cache_dir.mkdir(parents=True, exist_ok=True)

    def _make_key(self, query: str, context_hash: str = "", model: str = "") -> str:
        """Generate a cache key from query parameters."""
        raw = f"{query}|{context_hash}|{model}"
        return hashlib.sha256(raw.encode()).hexdigest()

    def _key_path(self, key: str) -> Path:
        """Get the file path for a cache key."""
        return self.cache_dir / f"{key}.json"

    def get(self, query: str, context_hash: str = "", model: str = "") -> str | None:
        """
        Look up a cached response.

        Returns the cached response string, or None if not found/expired.
        """
        if not self.enabled:
            return None

        key = self._make_key(query, context_hash, model)
        path = self._key_path(key)

        if not path.exists():
            return None

        try:
            data = json.loads(path.read_text(encoding="utf-8"))
            timestamp = data.get("timestamp", 0)

            # Check TTL
            if time.time() - timestamp > self.ttl_seconds:
                path.unlink(missing_ok=True)
                return None

            # Update access time for LRU
            data["last_access"] = time.time()
            path.write_text(json.dumps(data), encoding="utf-8")

            return data.get("response")
        except Exception as e:
            logger.warning("Cache read error: %s", e)
            return None

    def put(self, query: str, response: str, context_hash: str = "", model: str = ""):
        """Store a response in the cache."""
        if not self.enabled:
            return

        key = self._make_key(query, context_hash, model)
        path = self._key_path(key)

        data = {
            "query": query[:200],
            "model": model,
            "response": response,
            "timestamp": time.time(),
            "last_access": time.time(),
        }

        try:
            path.write_text(json.dumps(data), encoding="utf-8")
            self._evict_if_needed()
        except Exception as e:
            logger.warning("Cache write error: %s", e)

    def _evict_if_needed(self):
        """Evict oldest entries if cache exceeds max size."""
        try:
            files = list(self.cache_dir.glob("*.json"))
            total_size = sum(f.stat().st_size for f in files)

            if total_size <= self.max_size_bytes:
                return

            # Sort by last access time (oldest first)
            file_times = []
            for f in files:
                try:
                    data = json.loads(f.read_text(encoding="utf-8"))
                    file_times.append((f, data.get("last_access", 0)))
                except Exception:
                    file_times.append((f, 0))

            file_times.sort(key=lambda x: x[1])

            # Remove oldest until under limit
            for f, _ in file_times:
                if total_size <= self.max_size_bytes:
                    break
                size = f.stat().st_size
                f.unlink(missing_ok=True)
                total_size -= size
        except Exception as e:
            logger.warning("Cache eviction error: %s", e)

    def clear(self):
        """Clear all cached responses."""
        if self.cache_dir.exists():
            import shutil
            shutil.rmtree(self.cache_dir)
            self.cache_dir.mkdir(parents=True, exist_ok=True)

    def get_stats(self) -> dict:
        """Get cache statistics."""
        if not self.cache_dir.exists():
            return {"entries": 0, "size_mb": 0, "enabled": self.enabled}

        files = list(self.cache_dir.glob("*.json"))
        total_size = sum(f.stat().st_size for f in files)

        return {
            "entries": len(files),
            "size_mb": round(total_size / (1024 * 1024), 2),
            "max_size_mb": self.max_size_bytes // (1024 * 1024),
            "ttl_hours": self.ttl_seconds // 3600,
            "enabled": self.enabled,
            "cache_dir": str(self.cache_dir),
        }
