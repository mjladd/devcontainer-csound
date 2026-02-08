"""
MCP server for the Csound assistant.

Exposes the assistant as an MCP server for editor integration
(Claude Desktop, VS Code Continue, Cursor, etc.) using stdio transport.
"""

import logging

logger = logging.getLogger(__name__)


def run_mcp_server(transport: str = "stdio"):
    """
    Start the MCP server.

    Args:
        transport: Transport type ('stdio' or 'sse')
    """
    try:
        from mcp.server import Server
        from mcp.server.stdio import stdio_server
        from mcp.types import Tool, TextContent, Resource
    except ImportError:
        logger.error(
            "MCP SDK not installed. Install with: pip install 'csound-assist[mcp]'"
        )
        raise SystemExit(1)

    from csound_assist.assistant import CsoundAssistant
    from csound_assist.config import load_config
    from csound_assist.opcode_data import OPCODE_DESCRIPTIONS, get_opcode_category
    from csound_assist.validator import validate_csd_text

    config = load_config()
    assistant = CsoundAssistant(config)

    server = Server("csound-assist")

    @server.list_tools()
    async def list_tools():
        return [
            Tool(
                name="generate",
                description="Generate a complete Csound CSD file from a description",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "description": {
                            "type": "string",
                            "description": "Description of what to generate",
                        },
                        "technique": {
                            "type": "string",
                            "description": "Optional synthesis technique (fm, subtractive, granular, etc.)",
                        },
                    },
                    "required": ["description"],
                },
            ),
            Tool(
                name="explain",
                description="Explain Csound code",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "code": {
                            "type": "string",
                            "description": "Csound code to explain",
                        },
                        "detail": {
                            "type": "string",
                            "enum": ["brief", "normal", "deep"],
                            "description": "Detail level",
                        },
                    },
                    "required": ["code"],
                },
            ),
            Tool(
                name="debug",
                description="Debug Csound code with optional error context",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "code": {
                            "type": "string",
                            "description": "Csound code to debug",
                        },
                        "error_message": {
                            "type": "string",
                            "description": "Csound error output",
                        },
                    },
                    "required": ["code"],
                },
            ),
            Tool(
                name="complete",
                description="Complete partial Csound code",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "code_before": {
                            "type": "string",
                            "description": "Code before the cursor",
                        },
                        "code_after": {
                            "type": "string",
                            "description": "Code after the cursor",
                        },
                    },
                    "required": ["code_before"],
                },
            ),
            Tool(
                name="search",
                description="Search the Csound corpus for relevant examples and documentation",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "query": {
                            "type": "string",
                            "description": "Search query",
                        },
                        "limit": {
                            "type": "integer",
                            "description": "Max results (default 5)",
                        },
                    },
                    "required": ["query"],
                },
            ),
            Tool(
                name="validate",
                description="Validate Csound CSD code syntax",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "code": {
                            "type": "string",
                            "description": "CSD code to validate",
                        },
                    },
                    "required": ["code"],
                },
            ),
            Tool(
                name="opcode_info",
                description="Get information about a Csound opcode",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "opcode_name": {
                            "type": "string",
                            "description": "Name of the opcode",
                        },
                    },
                    "required": ["opcode_name"],
                },
            ),
        ]

    @server.call_tool()
    async def call_tool(name: str, arguments: dict):
        if name == "generate":
            response = assistant.generate(
                arguments["description"],
                technique=arguments.get("technique"),
                stream=False,
            )
            return [TextContent(type="text", text=response)]

        elif name == "explain":
            response = assistant.explain(
                arguments["code"],
                detail=arguments.get("detail", "normal"),
                stream=False,
            )
            return [TextContent(type="text", text=response)]

        elif name == "debug":
            response = assistant.debug(
                arguments["code"],
                error_message=arguments.get("error_message", ""),
                stream=False,
            )
            return [TextContent(type="text", text=response)]

        elif name == "complete":
            response = assistant.complete(
                arguments["code_before"],
                code_after=arguments.get("code_after", ""),
                stream=False,
            )
            return [TextContent(type="text", text=response)]

        elif name == "search":
            results = assistant.search(
                arguments["query"],
                n_results=arguments.get("limit", 5),
            )
            formatted = []
            for i, r in enumerate(results, 1):
                source = r.get("metadata", {}).get("source", "unknown")
                content = r.get("content", "")[:500]
                formatted.append(f"[{i}] {source}\n{content}\n")
            return [TextContent(type="text", text="\n".join(formatted))]

        elif name == "validate":
            valid, output = validate_csd_text(arguments["code"])
            status = "VALID" if valid else "INVALID"
            return [TextContent(type="text", text=f"{status}\n{output}")]

        elif name == "opcode_info":
            opcode = arguments["opcode_name"].lower()
            desc = OPCODE_DESCRIPTIONS.get(opcode)
            if desc:
                category = get_opcode_category(opcode) or "unknown"
                # Search corpus for more info
                results = assistant.search(f"{opcode} opcode", n_results=3)
                extra = ""
                for r in results:
                    extra += f"\n---\n{r.get('content', '')[:300]}"
                text = f"**{opcode}**: {desc}\nCategory: {category}{extra}"
            else:
                text = f"Unknown opcode: {opcode}"
            return [TextContent(type="text", text=text)]

        return [TextContent(type="text", text=f"Unknown tool: {name}")]

    @server.list_resources()
    async def list_resources():
        return [
            Resource(
                uri="csound://stats",
                name="Corpus Statistics",
                description="Index and system statistics",
                mimeType="application/json",
            ),
        ]

    @server.read_resource()
    async def read_resource(uri: str):
        if uri == "csound://stats":
            import json
            stats = assistant.get_stats()
            return json.dumps(stats, indent=2)

        if uri.startswith("csound://opcodes/"):
            opcode = uri.split("/")[-1].lower()
            desc = OPCODE_DESCRIPTIONS.get(opcode, "Unknown opcode")
            category = get_opcode_category(opcode) or "unknown"
            return f"{opcode}: {desc} (category: {category})"

        return f"Unknown resource: {uri}"

    import asyncio

    async def main():
        async with stdio_server() as (read_stream, write_stream):
            await server.run(read_stream, write_stream, server.create_initialization_options())

    asyncio.run(main())
