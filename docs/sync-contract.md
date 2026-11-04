# Sync contract

## Auth
- `POST /api/register` `{name,email,password,device_name?}` → `{user,token}`
- `POST /api/login` `{email,password,device_name?}` → `{user,token}`
- `POST /api/logout` Bearer
- `GET /api/me` Bearer

## Unified sync (preferred)
`POST /api/sync`

```json
{
  "device_id": "uuid-or-string",
  "since": "2026-11-04T12:00:00.000Z",
  "mutations": [
    {
      "entity": "products",
      "id": "uuid",
      "op": "create",
      "client_updated_at": "2026-11-04T12:00:00.000Z",
      "payload": { "name": "Leche", "base_price": 1.5, "unit_id": "uuid", "category_id": "uuid" }
    }
  ]
}
```

Response: `{ server_time, applied, rejected, changes, since }`

Ops: `create` | `update` | `upsert` | `delete`  
(`create`/`update`/`upsert` → server upsert; `delete` → soft delete)

Entities: `categories`, `units`, `products`, `shopping_lists`, `list_items`, `purchase_histories`, `purchase_history_items`.

### Payload fields by entity

| entity | payload keys |
|--------|----------------|
| categories | name, icon, color |
| units | name, abbreviation |
| products | name, description, category_id, unit_id, base_price, image_path, image_pending |
| shopping_lists | name, status, notes, store_location |
| list_items | shopping_list_id, product_id, unit_id, unit_abbr, name, qty_planned, qty_bought, unit_price, status |
| purchase_histories | shopping_list_id, store_location, purchased_at, total |
| purchase_history_items | purchase_history_id, product_id, name, unit_abbr, quantity, unit_price, line_total |

LWW: compare `client_updated_at`. Newer wins. Older → `rejected` with `lww_keep_server`.

Delete of unknown id creates a tombstone row (soft-deleted) with placeholder required FKs.

## Split endpoints (compat)
- `POST /api/sync/push` — mutations only
- `GET /api/sync/pull?since=ISO8601` — `{server_time, changes}`  
  - `server_time` captured **before** entity queries  
  - Filter: `updated_at >= since` (inclusive)  
  - Includes soft-deleted rows

## Images
`POST /api/uploads/product-image` multipart: `product_id`, `image`, `client_updated_at`.

## Client rules
1. Mutate SQLite only → enqueue `sync_queue`.
2. Online: `POST /api/sync` then pending images.
3. Never cache API JSON in HTTP cache layers.
4. On user switch/logout: wipe local DB.

See [sync-engine.md](sync-engine.md) for architecture + table schemas.
