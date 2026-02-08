"""
Analytics and event logging for the Csound assistant.

Logs events to a JSONL file for tracking usage patterns,
retrieval quality, and popular techniques/opcodes.
"""

import json
import logging
import time
from collections import Counter
from pathlib import Path

logger = logging.getLogger(__name__)

DEFAULT_ANALYTICS_PATH = Path.home() / ".csound-assist" / "analytics.jsonl"


class Analytics:
    """
    JSONL-based event logger and analytics aggregator.

    Events are appended to a single JSONL file for simplicity.
    """

    def __init__(self, path: Path = DEFAULT_ANALYTICS_PATH):
        self.path = path
        self.path.parent.mkdir(parents=True, exist_ok=True)

    def log_event(
        self,
        command: str,
        query: str = "",
        techniques: list[str] | None = None,
        opcodes: list[str] | None = None,
        retrieval_scores: list[float] | None = None,
        response_time: float = 0,
        model: str = "",
        token_count: int = 0,
        validation_result: bool | None = None,
    ):
        """Log a single event."""
        event = {
            "timestamp": time.time(),
            "command": command,
            "query": query[:200],
            "techniques": techniques or [],
            "opcodes": opcodes or [],
            "retrieval_scores": retrieval_scores or [],
            "response_time": round(response_time, 2),
            "model": model,
            "token_count": token_count,
        }
        if validation_result is not None:
            event["validation_result"] = validation_result

        try:
            with open(self.path, "a", encoding="utf-8") as f:
                f.write(json.dumps(event) + "\n")
        except Exception as e:
            logger.warning("Analytics write error: %s", e)

    def get_events(self, limit: int = 0) -> list[dict]:
        """Read events from the log file."""
        if not self.path.exists():
            return []

        events = []
        try:
            with open(self.path, encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line:
                        events.append(json.loads(line))
        except Exception as e:
            logger.warning("Analytics read error: %s", e)

        if limit > 0:
            events = events[-limit:]
        return events

    def get_summary(self) -> dict:
        """Aggregate analytics into a summary."""
        events = self.get_events()
        if not events:
            return {
                "total_events": 0,
                "message": "No analytics data yet.",
            }

        command_counts = Counter(e.get("command", "") for e in events)
        all_techniques = Counter()
        all_opcodes = Counter()
        response_times = []
        validation_results = {"pass": 0, "fail": 0}

        for e in events:
            for t in e.get("techniques", []):
                all_techniques[t] += 1
            for o in e.get("opcodes", []):
                all_opcodes[o] += 1
            rt = e.get("response_time", 0)
            if rt > 0:
                response_times.append(rt)
            vr = e.get("validation_result")
            if vr is True:
                validation_results["pass"] += 1
            elif vr is False:
                validation_results["fail"] += 1

        avg_response_time = (
            round(sum(response_times) / len(response_times), 2)
            if response_times else 0
        )

        return {
            "total_events": len(events),
            "commands": dict(command_counts.most_common(10)),
            "top_techniques": dict(all_techniques.most_common(10)),
            "top_opcodes": dict(all_opcodes.most_common(10)),
            "avg_response_time": avg_response_time,
            "validation": validation_results,
        }
