# LangChain-Toolbox-With-MCP

Local MCP demo server (restaurant tools) plus a notebook that shows how to call the tools with Toolbox + LangChain OpenAI.

## Setup (uv init + venv)

```bash
uv init
uv venv
.\.venv\Scripts\activate
uv add mcp toolbox-langchain langchain-openai langgraph python-dotenv
```

Create a `.env` file in this folder:

```bash
OPENAI_API_KEY=...
TOOLBOX_URL=http://127.0.0.1:5000
ADMIN_TOKEN=admin-token
```

## Start the MCP server

Run this in a separate terminal:

```bash
python server.py
```

The server listens on http://127.0.0.1:5000.

## Notebook

Open `toolbox.ipynb` and run the cells to see:
- manual tool calls
- load a single tool
- LangChain agent calls via langgraph
- LangChain model calls via bind_tools (no agent)
- admin-only tool calls with dynamic headers
