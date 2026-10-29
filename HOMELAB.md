# Homelab — Deploy & Observability

My projects are self-hosted on my own homelab. When something is "deployed", it's
almost always a **Coolify** app on `apps-01`, and its logs are almost always in
**Grafana/Loki** on `obs-01`. This file is the map; the config-as-code lives in the
**Home repo** (read it for anything deeper).

Hosts are addressed by DNS name, never raw IP: `<host>.lan.sangu.be` internal,
`*.sangu.be` public.

## Home repo — source of truth

| What            | Where                                                              |
|-----------------|-------------------------------------------------------------------|
| GitHub          | [Laoujin/Home][gh]                                                 |
| Local checkout  | `/mnt/c/Users/woute/Dropbox/Personal/Programming/UnixCode/_personal/Home` |
| Infra CLAUDE.md | repo root — addressing rules, folder contract                     |
| Addressing SSOT | `docs/addressing.md` (IP/VLAN/naming — read before touching hosts)|
| Runbooks        | `docs/runbooks/` · Inventory `docs/inventory/devices.yaml`        |

[gh]: https://github.com/Laoujin/Home

## Deployment — Coolify (`apps-01`)

- Apps are defined as code in `homelab/apps-01/coolify/coolify-apps.ts` (SSOT).
  Find your project there for its domains, tiers, env, and secrets. Edit → `bun sync.ts`.
- **One Coolify app per branch**: `main` = production, `dev` = staging, PRs = previews
  (`pr-N-…`). Prod usually on the project's real domain; dev/PR on `*-<app>.sangu.be`.
- **autoDeploy is on**: a push to `main`/`dev` auto-redeploys that app via the GitHub webhook.
  **Promote to prod = merge `dev` → `main`.**
- Coolify API: `http://apps-01.lan.sangu.be:8000/api/v1` (OpenAPI + TS client in
  `homelab/apps-01/coolify/`). Use the **readonly** token for status/inspection.
- Secrets: SOPS-encrypted per app/tier in the Home repo (`<APP>__<TIER>__<KEY>`).

## Observability — `obs-01`

| Signal  | URL                                             | Notes                                        |
|---------|-------------------------------------------------|----------------------------------------------|
| Grafana | `https://grafana.lan.sangu.be`                  | Dashboards + Explore                         |
| Loki    | `https://loki.lan.sangu.be`                     | Logs. Apps push here; filter by app label.   |
| Metrics | `http://obs-01.lan.sangu.be:9090`               | Prometheus                                   |

Query Loki logs with `/loki/api/v1/query_range` (the instant `/query` returns empty
for log streams):

```sh
curl -G -sf "https://loki.lan.sangu.be/loki/api/v1/query_range" \
  --data-urlencode 'query={app="<app-label>"}' \
  --data-urlencode "start=$(date -d '1 hour ago' +%s)000000000" \
  --data-urlencode "end=$(date +%s)000000000" | jq
```

Discover labels: `curl -sf https://loki.lan.sangu.be/loki/api/v1/label/app/values | jq`.

## Access — LAN only

Everything above is `*.lan.sangu.be` — reachable only on the home LAN or the tailnet
(headscale on `docker-01`). A remote/cloud session **cannot** reach Coolify/Grafana/Loki;
say so instead of guessing.

## Readonly API tokens

For querying deploy status + logs (never commit values):

| Var                | Used for                                                     |
|--------------------|--------------------------------------------------------------|
| `COOLIFY_RO_TOKEN` | Coolify API (deploy status, app config)                      |
| `GRAFANA_RO_TOKEN` | Grafana/Loki HTTP API                                        |
| `BESZEL_RO_TOKEN`  | Beszel API (per-container CPU/memory, the one source for it) |

Values live in `~/.claude/.homelab.env` (git-ignored, `chmod 600`); `source` it before use.

## Beszel — per-container stats (`beszel.lan.sangu.be`)

PocketBase under the hood. The token is a raw JWT, passed without a `Bearer` prefix, and it
expires on the `users` collection's auth token duration — re-mint it with
`/api/collections/users/auth-with-password`.

```sh
curl -sf -H "Authorization: $BESZEL_RO_TOKEN" \
  "https://beszel.lan.sangu.be/api/collections/container_stats/records?perPage=1&sort=-created" | jq
```

Collections: `systems`, `system_stats`, `container_stats`, `containers`, `alerts`.

A record the user is not granted returns an empty `items` array, not a 403 — so
`totalItems: 0` means the account is not attached to that system, not that the data is missing.
