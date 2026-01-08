from __future__ import annotations

import os

from dotenv import load_dotenv
from mcp.server.fastmcp import Context, FastMCP
from mcp.server.streamable_http import StreamableHTTPServerTransport

_original_validate_accept_header = StreamableHTTPServerTransport._validate_accept_header


async def _allow_missing_accept(self, request, scope, send) -> bool:
    # ToolboxClient does not send Accept during MCP initialization.
    accept_header = request.headers.get("accept", "").strip()
    if not accept_header or accept_header == "*/*":
        return True
    return await _original_validate_accept_header(self, request, scope, send)


StreamableHTTPServerTransport._validate_accept_header = _allow_missing_accept

load_dotenv()
ADMIN_TOKEN = os.getenv("ADMIN_TOKEN", "admin-token")

mcp = FastMCP(
    "Restaurant Demo Server",
    stateless_http=True,
    host="127.0.0.1",
    port=5000,
    streamable_http_path="/mcp/",
    json_response=True,
)

# Static demo data for the MCP tools.
MENU_EUR = {
    "margherita": 8.5,
    "salami": 9.5,
    "funghi": 9.0,
    "prosciutto": 10.5,
    "veggie": 9.5,
}

OPENING_HOURS = {
    "mon": "11:00-22:00",
    "tue": "11:00-22:00",
    "wed": "11:00-22:00",
    "thu": "11:00-22:00",
    "fri": "11:00-23:00",
    "sat": "12:00-23:00",
    "sun": "12:00-21:00",
}

RESTAURANT_INFO = {
    "name": "Pizzeria Demo",
    "address": "Example Street 1, 12345 City",
    "phone": "+49 30 1234567",
    "website": "https://example.com",
}

COMPANY_ACCOUNT_BALANCE_EUR = 20000

DAY_ALIASES = {
    "mo": "mon",
    "mon": "mon",
    "monday": "mon",
    "di": "tue",
    "tue": "tue",
    "tuesday": "tue",
    "mi": "wed",
    "wed": "wed",
    "wednesday": "wed",
    "do": "thu",
    "thu": "thu",
    "thursday": "thu",
    "fr": "fri",
    "fri": "fri",
    "friday": "fri",
    "sa": "sat",
    "sat": "sat",
    "saturday": "sat",
    "so": "sun",
    "sun": "sun",
    "sunday": "sun",
}


def _normalize_day(day: str) -> str:
    key = day.strip().lower()
    return DAY_ALIASES.get(key, key)


def _get_bearer_token(ctx: Context) -> str | None:
    request = ctx.request_context.request
    if request is None:
        return None
    auth_header = request.headers.get("authorization", "")
    if not auth_header:
        return None
    prefix = "bearer "
    if not auth_header.lower().startswith(prefix):
        return None
    return auth_header[len(prefix) :].strip()


def _is_admin(ctx: Context) -> bool:
    token = _get_bearer_token(ctx)
    return token == ADMIN_TOKEN


@mcp.tool(description="List all pizza prices in EUR.")
def list_pizza_prices() -> dict:
    return {"prices_eur": MENU_EUR}


@mcp.tool(description="Get the price in EUR for a given pizza name.")
def get_pizza_price(pizza: str) -> dict:
    if not pizza:
        return {"error": "missing_pizza", "available_pizzas": sorted(MENU_EUR)}
    key = pizza.strip().lower()
    price = MENU_EUR.get(key)
    if price is None:
        return {"error": "pizza_not_found", "available_pizzas": sorted(MENU_EUR)}
    return {"pizza": key, "price_eur": price}


@mcp.tool(description="Get opening hours. Pass a day like 'mon' or 'monday'.")
def get_opening_hours(day: str = "all") -> dict:
    if day.strip().lower() in {"all", "week", "weekly"}:
        return {"hours": OPENING_HOURS}
    day_key = _normalize_day(day)
    hours = OPENING_HOURS.get(day_key)
    if hours is None:
        return {"error": "unknown_day", "available_days": sorted(OPENING_HOURS)}
    return {"day": day_key, "hours": hours}


@mcp.tool(description="Get basic restaurant info (name, address, phone, website).")
def get_restaurant_info() -> dict:
    return RESTAURANT_INFO


@mcp.tool(description="Admin-only: get the company account balance in EUR.")
def get_company_account_balance(ctx: Context) -> dict:
    if not _is_admin(ctx):
        return {"error": "unauthorized", "message": "admin token required"}
    return {"account": "company", "balance_eur": COMPANY_ACCOUNT_BALANCE_EUR}


if __name__ == "__main__":
    mcp.run(transport="streamable-http")
