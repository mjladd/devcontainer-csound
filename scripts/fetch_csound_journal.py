#!/usr/bin/env python3
"""
Download Csound Journal articles for corpus integration.

This script scrapes articles from csoundjournal.com and converts them
to a corpus-friendly format.

Note: Be respectful of the server - this script includes delays between requests.
"""

import os
import re
import json
import time
import urllib.request
import urllib.error
from pathlib import Path
from datetime import datetime
from html.parser import HTMLParser
from typing import Optional
import ssl

# Configuration
BASE_URL = "https://csoundjournal.com"
INDEX_URL = f"{BASE_URL}/articleIndex.html"
DELAY_BETWEEN_REQUESTS = 1.0  # seconds


class HTMLToMarkdown(HTMLParser):
    """Simple HTML to Markdown converter."""

    def __init__(self):
        super().__init__()
        self.markdown = []
        self.current_tag = None
        self.in_pre = False
        self.in_code = False
        self.list_depth = 0
        self.href = None

    def handle_starttag(self, tag, attrs):
        self.current_tag = tag
        attrs_dict = dict(attrs)

        if tag == "pre":
            self.in_pre = True
            self.markdown.append("\n```csound\n")
        elif tag == "code" and not self.in_pre:
            self.in_code = True
            self.markdown.append("`")
        elif tag in ["h1", "h2", "h3", "h4"]:
            level = int(tag[1])
            self.markdown.append("\n" + "#" * level + " ")
        elif tag == "p":
            self.markdown.append("\n\n")
        elif tag == "br":
            self.markdown.append("\n")
        elif tag == "a":
            self.href = attrs_dict.get("href", "")
            self.markdown.append("[")
        elif tag == "strong" or tag == "b":
            self.markdown.append("**")
        elif tag == "em" or tag == "i":
            self.markdown.append("*")
        elif tag == "ul" or tag == "ol":
            self.list_depth += 1
        elif tag == "li":
            self.markdown.append("\n" + "  " * (self.list_depth - 1) + "- ")
        elif tag == "img":
            alt = attrs_dict.get("alt", "image")
            src = attrs_dict.get("src", "")
            self.markdown.append(f"![{alt}]({src})")

    def handle_endtag(self, tag):
        if tag == "pre":
            self.in_pre = False
            self.markdown.append("\n```\n")
        elif tag == "code" and not self.in_pre:
            self.in_code = False
            self.markdown.append("`")
        elif tag in ["h1", "h2", "h3", "h4"]:
            self.markdown.append("\n")
        elif tag == "a":
            if self.href:
                # Make relative URLs absolute
                if self.href.startswith("/"):
                    self.href = BASE_URL + self.href
                elif not self.href.startswith("http"):
                    self.href = BASE_URL + "/" + self.href
                self.markdown.append(f"]({self.href})")
            else:
                self.markdown.append("]")
            self.href = None
        elif tag == "strong" or tag == "b":
            self.markdown.append("**")
        elif tag == "em" or tag == "i":
            self.markdown.append("*")
        elif tag == "ul" or tag == "ol":
            self.list_depth = max(0, self.list_depth - 1)

    def handle_data(self, data):
        if self.in_pre:
            self.markdown.append(data)
        else:
            # Clean up whitespace
            text = re.sub(r'\s+', ' ', data)
            self.markdown.append(text)

    def get_markdown(self) -> str:
        result = "".join(self.markdown)
        # Clean up excessive newlines
        result = re.sub(r'\n{3,}', '\n\n', result)
        return result.strip()


def fetch_url(url: str) -> Optional[str]:
    """Fetch URL content with error handling."""
    try:
        # Create SSL context that doesn't verify (some older sites have cert issues)
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE

        req = urllib.request.Request(
            url,
            headers={"User-Agent": "CsoundCorpusBot/1.0 (Educational/Research)"}
        )
        with urllib.request.urlopen(req, timeout=30, context=ctx) as response:
            return response.read().decode("utf-8", errors="replace")
    except urllib.error.URLError as e:
        print(f"    Error fetching {url}: {e}")
        return None
    except Exception as e:
        print(f"    Error: {e}")
        return None


def parse_article_index(html: str) -> list[dict]:
    """Parse the article index page to extract article links."""
    articles = []

    # Find all article links - pattern: <a href="issueXX/article.html">Title</a>
    pattern = r'<a\s+href="(issue\d+/[^"]+\.html)"[^>]*>([^<]+)</a>'
    matches = re.findall(pattern, html, re.IGNORECASE)

    for href, title in matches:
        # Extract issue number
        issue_match = re.search(r'issue(\d+)', href)
        issue_num = issue_match.group(1) if issue_match else "unknown"

        articles.append({
            "url": f"{BASE_URL}/{href}",
            "title": title.strip(),
            "issue": issue_num,
            "filename": href.split("/")[-1].replace(".html", ""),
        })

    return articles


def html_to_markdown(html: str) -> str:
    """Convert HTML content to Markdown."""
    # Extract main content (try common patterns)
    content = html

    # Try to extract just the article body
    body_patterns = [
        r'<div[^>]*class="[^"]*content[^"]*"[^>]*>(.*?)</div>',
        r'<article[^>]*>(.*?)</article>',
        r'<div[^>]*id="[^"]*main[^"]*"[^>]*>(.*?)</div>',
        r'<body[^>]*>(.*?)</body>',
    ]

    for pattern in body_patterns:
        match = re.search(pattern, html, re.DOTALL | re.IGNORECASE)
        if match:
            content = match.group(1)
            break

    # Convert to markdown
    parser = HTMLToMarkdown()
    parser.feed(content)
    return parser.get_markdown()


def extract_article_metadata(html: str, article_info: dict) -> dict:
    """Extract metadata from article HTML."""
    metadata = {
        "title": article_info["title"],
        "issue": article_info["issue"],
        "url": article_info["url"],
        "author": "",
        "abstract": "",
    }

    # Try to extract author
    author_patterns = [
        r'<meta\s+name="author"\s+content="([^"]+)"',
        r'by\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)',
        r'Author:\s*([^<\n]+)',
    ]
    for pattern in author_patterns:
        match = re.search(pattern, html, re.IGNORECASE)
        if match:
            metadata["author"] = match.group(1).strip()
            break

    # Try to extract abstract/description
    desc_patterns = [
        r'<meta\s+name="description"\s+content="([^"]+)"',
        r'<p[^>]*class="[^"]*abstract[^"]*"[^>]*>([^<]+)</p>',
    ]
    for pattern in desc_patterns:
        match = re.search(pattern, html, re.IGNORECASE)
        if match:
            metadata["abstract"] = match.group(1).strip()[:300]
            break

    return metadata


def process_article(article_info: dict, output_dir: Path) -> Optional[dict]:
    """Download and process a single article."""
    html = fetch_url(article_info["url"])
    if not html:
        return None

    metadata = extract_article_metadata(html, article_info)
    content = html_to_markdown(html)

    # Skip if content is too short (probably an error page)
    if len(content) < 500:
        print(f"    Skipping {article_info['filename']} (content too short)")
        return None

    # Create output file
    issue_dir = output_dir / f"issue{metadata['issue']}"
    issue_dir.mkdir(parents=True, exist_ok=True)

    md_content = f"""---
source: Csound Journal
issue: {metadata['issue']}
title: "{metadata['title']}"
author: "{metadata['author']}"
url: {metadata['url']}
---

# {metadata['title']}

**Author:** {metadata['author'] if metadata['author'] else 'Unknown'}
**Issue:** {metadata['issue']}
**Source:** [Csound Journal]({metadata['url']})

---

{content}
"""

    output_path = issue_dir / f"{article_info['filename']}.md"
    output_path.write_text(md_content, encoding="utf-8")

    return metadata


def create_index(output_dir: Path, articles: list[dict]) -> None:
    """Create index file."""
    # Group by issue
    by_issue = {}
    for article in articles:
        issue = article.get("issue", "unknown")
        if issue not in by_issue:
            by_issue[issue] = []
        by_issue[issue].append(article)

    index_content = f"""# Csound Journal - Corpus Index

**Source:** {BASE_URL}
**Downloaded:** {datetime.now().strftime("%Y-%m-%d")}
**Total Articles:** {len(articles)}
**Issues:** {len(by_issue)}

## About

The Csound Journal is an e-journal of articles about Csound, edited by
Iain McCurdy and James Hearon. Articles cover synthesis techniques,
signal processing, programming tutorials, and more.

## Articles by Issue

"""
    for issue_num in sorted(by_issue.keys(), key=lambda x: int(x) if x.isdigit() else 0, reverse=True):
        issue_articles = by_issue[issue_num]
        index_content += f"\n### Issue {issue_num} ({len(issue_articles)} articles)\n\n"
        for article in sorted(issue_articles, key=lambda x: x["title"]):
            author = f" - {article['author']}" if article.get("author") else ""
            index_content += f"- [{article['title']}](issue{issue_num}/{article.get('filename', 'unknown')}.md){author}\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")
    (output_dir / "index.json").write_text(json.dumps(articles, indent=2), encoding="utf-8")


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "csound_journal"

    print("=== Csound Journal Downloader ===")
    print(f"Output directory: {output_dir}")
    print(f"Note: Adding {DELAY_BETWEEN_REQUESTS}s delay between requests")
    print()

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Fetch article index
    print("Fetching article index...")
    index_html = fetch_url(INDEX_URL)
    if not index_html:
        print("Failed to fetch article index!")
        return 1

    articles = parse_article_index(index_html)
    print(f"Found {len(articles)} articles")

    if not articles:
        print("No articles found in index!")
        return 1

    # Process articles
    processed = []
    for i, article in enumerate(articles):
        print(f"[{i+1}/{len(articles)}] {article['title'][:50]}...")

        result = process_article(article, output_dir)
        if result:
            processed.append(result)

        # Be nice to the server
        if i < len(articles) - 1:
            time.sleep(DELAY_BETWEEN_REQUESTS)

    # Create index
    print("\nCreating index...")
    create_index(output_dir, processed)

    print()
    print("=== Complete ===")
    print(f"Successfully processed: {len(processed)}/{len(articles)} articles")
    print(f"Output directory: {output_dir}")

    return 0


if __name__ == "__main__":
    exit(main())
