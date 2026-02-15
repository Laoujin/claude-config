# MCP Servers Reference

Already installed: context7, chrome-devtools, playwright

## To install on demand

Windows: wrap npx with `cmd /c npx` (like existing Playwright config).

| Server | Command |
|--------|---------|
| **GitHub** | `docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server` |
| **Docker** | `uvx docker-mcp` (needs `uv` installed — not currently on system) |
| **Postgres** | `npx -y @modelcontextprotocol/server-postgres "postgresql://user:pass@host:5432/db"` |
| **MongoDB** | `npx -y mongodb-mcp-server@latest` (env: `MDB_MCP_CONNECTION_STRING`) |
| **Redis** | `npx -y @modelcontextprotocol/server-redis "redis://localhost:6379"` |
| **SQL Server** | `npx -y mssql-mcp-node` (env: `MSSQL_SERVER`, `MSSQL_USER`, `MSSQL_PASSWORD`, `MSSQL_DATABASE`, `MSSQL_PORT`) |
| **MySQL** | `npx -y @benborla29/mcp-server-mysql` (env: `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASS`, `MYSQL_DB`, `MYSQL_PORT`) |
