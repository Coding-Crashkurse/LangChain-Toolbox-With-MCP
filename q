warning: in the working copy of 'server.py', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'toolbox.ipynb', LF will be replaced by CRLF the next time Git touches it
[1mdiff --git a/server.py b/server.py[m
[1mindex 6f22b43..51eee65 100644[m
[1m--- a/server.py[m
[1m+++ b/server.py[m
[36m@@ -1,12 +1,27 @@[m
 from __future__ import annotations[m
 [m
 from mcp.server.fastmcp import FastMCP[m
[32m+[m[32mfrom mcp.server.streamable_http import StreamableHTTPServerTransport[m
[32m+[m
[32m+[m[32m_original_validate_accept_header = StreamableHTTPServerTransport._validate_accept_header[m
[32m+[m
[32m+[m
[32m+[m[32masync def _allow_missing_accept(self, request, scope, send) -> bool:[m
[32m+[m[32m    # ToolboxClient does not send Accept during MCP initialization.[m
[32m+[m[32m    accept_header = request.headers.get("accept", "").strip()[m
[32m+[m[32m    if not accept_header or accept_header == "*/*":[m
[32m+[m[32m        return True[m
[32m+[m[32m    return await _original_validate_accept_header(self, request, scope, send)[m
[32m+[m
[32m+[m
[32m+[m[32mStreamableHTTPServerTransport._validate_accept_header = _allow_missing_accept[m
 [m
 mcp = FastMCP([m
     "Restaurant Demo Server",[m
     stateless_http=True,[m
     host="127.0.0.1",[m
     port=5000,[m
[32m+[m[32m    streamable_http_path="/mcp/",[m
     json_response=True,[m
 )[m
 [m
[1mdiff --git a/toolbox.ipynb b/toolbox.ipynb[m
[1mindex d616f21..99b4201 100644[m
[1m--- a/toolbox.ipynb[m
[1m+++ b/toolbox.ipynb[m
[36m@@ -50,17 +50,14 @@[m
   },[m
   {[m
    "cell_type": "code",[m
[31m-   "execution_count": 7,[m
[32m+[m[32m   "execution_count": null,[m
    "id": "ab381a46",[m
    "metadata": {},[m
    "outputs": [],[m
    "source": [[m
[31m-    "import os\n",[m
     "from dotenv import load_dotenv\n",[m
     "\n",[m
[31m-    "load_dotenv()\n",[m
[31m-    "TOOLBOX_URL = os.getenv(\"TOOLBOX_URL\", \"http://127.0.0.1:5000\")\n",[m
[31m-    "CLIENT_HEADERS = {\"Accept\": \"application/json\"}\n"[m
[32m+[m[32m    "load_dotenv()\n"[m
    ][m
   },[m
   {[m
[36m@@ -73,51 +70,32 @@[m
   },[m
   {[m
    "cell_type": "code",[m
[31m-   "execution_count": 6,[m
[32m+[m[32m   "execution_count": null,[m
    "id": "4b07bdcf",[m
    "metadata": {},[m
[31m-   "outputs": [[m
[31m-    {[m
[31m-     "ename": "RuntimeError",[m
[31m-     "evalue": "API request failed with status 406 (Not Acceptable). Server response: {\"jsonrpc\":\"2.0\",\"id\":\"server-error\",\"error\":{\"code\":-32600,\"message\":\"Not Acceptable: Client must accept application/json\"}}",[m
[31m-     "output_type": "error",[m
[31m-     "traceback": [[m
[31m-      "\u001b[31m---------------------------------------------------------------------------\u001b[39m",[m
[31m-      "\u001b[31mRuntimeError\u001b[39m                              Traceback (most recent call last)",[m
[31m-      "\u001b[36mFile \u001b[39m\u001b[32mc:\\Users\\User\\Desktop\\LangChainToolbox\\.venv\\Lib\\site-packages\\toolbox_core\\mcp_transport\\transport_base.py:117\u001b[39m, in \u001b[36m_McpHttpTransportBase.close\u001b[39m\u001b[34m(self)\u001b[39m\n\u001b[32m    115\u001b[39m \u001b[38;5;28;01mif\u001b[39;00m \u001b[38;5;28mself\u001b[39m._init_task:\n\u001b[32m    116\u001b[39m     \u001b[38;5;28;01mtry\u001b[39;00m:\n\u001b[32m--> \u001b[39m\u001b[32m117\u001b[39m         \u001b[38;5;28;01mawait\u001b[39;00m \u001b[38;5;28mself\u001b[39m._init_task\n\u001b[32m    118\u001b[39m     \u001b[38;5;28;01mexcept\u001b[39;00m \u001b[38;5;167;01mException\u001b[39;00m:\n\u001b[32m    119\u001b[39m         \u001b[38;5;66;03m# If initialization failed, we can still try to close.\u001b[39;00m\n\u001b[32m    120\u001b[39m         \u001b[38;5;28;01mpass\u001b[39;00m\n",[m
[31m-      "\u001b[31mRuntimeError\u001b[39m: API request failed with status 406 (Not Acceptable). Server response: {\"jsonrpc\":\"2.0\",\"id\":\"server-error\",\"error\":{\"code\":-32600,\"message\":\"Not Acceptable: Client must accept application/json\"}}"[m
[31m-     ][m
[31m-    }[m
[31m-   ],[m
[32m+[m[32m   "outputs": [],[m
    "source": [[m
     "from toolbox_langchain import ToolboxClient\n",[m
     "\n",[m
[31m-    "with ToolboxClient(TOOLBOX_URL, client_headers=CLIENT_HEADERS) as toolbox:\n",[m
[31m-    "    tools = toolbox.load_toolset()\n",[m
[32m+[m[32m    "TOOLBOX_URL = \"http://127.0.0.1:5000\"\n",[m
     "\n",[m
[31m-    "[tool.name for tool in tools]\n"[m
[32m+[m[32m    "headers = {\n",[m
[32m+[m[32m    "    \"Accept\": \"application/json, text/event-stream\",\n",[m
[32m+[m[32m    "}\n",[m
[32m+[m[32m    "\n",[m
[32m+[m[32m    "with ToolboxClient(TOOLBOX_URL, client_headers=headers) as toolbox:\n",[m
[32m+[m[32m    "    tools = toolbox.load_toolset()\n",[m
[32m+[m[32m    "    print([t.name for t in tools])\n"[m
    ][m
   },[m
   {[m
    "cell_type": "code",[m
[31m-   "execution_count": 4,[m
[32m+[m[32m   "execution_count": null,[m
    "id": "c74c124c",[m
    "metadata": {},[m
[31m-   "outputs": [[m
[31m-    {[m
[31m-     "ename": "RuntimeError",[m
[31m-     "evalue": "API request failed with status 406 (Not Acceptable). Server response: {\"jsonrpc\":\"2.0\",\"id\":\"server-error\",\"error\":{\"code\":-32600,\"message\":\"Not Acceptable: Client must accept application/json\"}}",[m
[31m-     "output_type": "error",[m
[31m-     "traceback": [[m
[31m-      "\u001b[31m---------------------------------------------------------------------------\u001b[39m",[m
[31m-      "\u001b[31mRuntimeError\u001b[39m                              Traceback (most recent call last)",[m
[31m-      "\u001b[36mFile \u001b[39m\u001b[32mc:\\Users\\User\\Desktop\\LangChainToolbox\\.venv\\Lib\\site-packages\\toolbox_core\\mcp_transport\\transport_base.py:117\u001b[39m, in \u001b[36m_McpHttpTransportBase.close\u001b[39m\u001b[34m(self)\u001b[39m\n\u001b[32m    115\u001b[39m \u001b[38;5;28;01mif\u001b[39;00m \u001b[38;5;28mself\u001b[39m._init_task:\n\u001b[32m    116\u001b[39m     \u001b[38;5;28;01mtry\u001b[39;00m:\n\u001b[32m--> \u001b[39m\u001b[32m117\u001b[39m         \u001b[38;5;28;01mawait\u001b[39;00m \u001b[38;5;28mself\u001b[39m._init_task\n\u001b[32m    118\u001b[39m     \u001b[38;5;28;01mexcept\u001b[39;00m \u001b[38;5;167;01mException\u001b[39;00m:\n\u001b[32m    119\u001b[39m         \u001b[38;5;66;03m# If initialization failed, we can still try to close.\u001b[39;00m\n\u001b[32m    120\u001b[39m         \u001b[38;5;28;01mpass\u001b[39;00m\n",[m
[31m-      "\u001b[31mRuntimeError\u001b[39m: API request failed with status 406 (Not Acceptable). Server response: {\"jsonrpc\":\"2.0\",\"id\":\"server-error\",\"error\":{\"code\":-32600,\"message\":\"Not Acceptable: Client must accept application/json\"}}"[m
[31m-     ][m
[31m-    }[m
[31m-   ],[m
[32m+[m[32m   "outputs": [],[m
    "source": [[m
[31m-    "async with ToolboxClient(TOOLBOX_URL, client_headers=CLIENT_HEADERS) as toolbox:\n",[m
[32m+[m[32m    "async with ToolboxClient(TOOLBOX_URL) as toolbox:\n",[m
     "    tools = await toolbox.aload_toolset()\n",[m
     "\n",[m
     "[tool.name for tool in tools]\n"[m
[36m@@ -138,7 +116,7 @@[m
    "metadata": {},[m
    "outputs": [],[m
    "source": [[m
[31m-    "async with ToolboxClient(TOOLBOX_URL, client_headers=CLIENT_HEADERS) as toolbox:\n",[m
[32m+[m[32m    "async with ToolboxClient(TOOLBOX_URL) as toolbox:\n",[m
     "    list_prices = toolbox.load_tool(\"list_pizza_prices\")\n",[m
     "    get_price = toolbox.load_tool(\"get_pizza_price\")\n",[m
     "    get_hours = toolbox.load_tool(\"get_opening_hours\")\n",[m
[36m@@ -172,7 +150,7 @@[m
     "\n",[m
     "model = ChatOpenAI(model=\"gpt-4o-mini\", temperature=0)\n",[m
     "\n",[m
[31m-    "async with ToolboxClient(TOOLBOX_URL, client_headers=CLIENT_HEADERS) as toolbox:\n",[m
[32m+[m[32m    "async with ToolboxClient(TOOLBOX_URL) as toolbox:\n",[m
     "    tools = toolbox.load_toolset()\n",[m
     "    agent = create_agent(model, tools)\n",[m
     "\n",[m
[36m@@ -202,7 +180,7 @@[m
    "source": [[m
     "from langchain_core.messages import ToolMessage\n",[m
     "\n",[m
[31m-    "async with ToolboxClient(TOOLBOX_URL, client_headers=CLIENT_HEADERS) as toolbox:\n",[m
[32m+[m[32m    "async with ToolboxClient(TOOLBOX_URL) as toolbox:\n",[m
     "    tools = toolbox.load_toolset()\n",[m
     "    tool_map = {tool.name: tool for tool in tools}\n",[m
     "    model_with_tools = model.bind_tools(tools)\n",[m
