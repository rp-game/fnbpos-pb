# fnbpos-pb — Protobuf contract ĐỘC LẬP cho F&B / POS

Contract giao tiếp (NATS + protobuf) cho **`fnb-service`** và **`pos-service`**, **hoàn toàn độc lập
với mantik** (`mantik_pb`/`api`) để **nhiều dự án dùng chung** (mantik, hotel, bên thứ 3).

> Thiết kế: [`../f&b.research.md`](../f&b.research.md) (§A5/A6/A7) · Task: `S-05`.

## Nguyên tắc (bất biến)
- **Độc lập:** repo/module riêng; service chỉ **consume** (`go get github.com/mana-fnb/fnbpos-pb@vX`).
  **KHÔNG** phụ thuộc `mantik_pb`; **KHÔNG** ai nhét proto này vào `mantik_pb`.
- **Domain-neutral:** chỉ **id opaque** (`tenant_id`, `outlet_id`, `warehouse_id`, `delivery_ref`).
  **CẤM** type host: `organizer_id`/`event_id`/`Item`/`room_id`.
- **Additive-only + versioned:** thêm field, không phá; tag `vX.Y.Z`.

## Layout
```
proto/common/v1/envelope.proto   # Envelope (schema_version,message_id,tenant_id,occurred_at) + Money
proto/fnb/v1/menu.proto          # fnb_pb: MenuQuery*, MenuItem, ItemAvailabilityChanged
proto/pos/v1/sale.proto          # pos_pb: SaleCommitted, SaleLine, SaleReversed
v1/{common,fnb,pos}/*.pb.go      # generated (protoc-gen-go)
```
`fnb_pb`/`pos_pb` của thiết kế = 2 import-package `.../v1/fnb` và `.../v1/pos` trong 1 contracts-module
(chung `common` envelope + event pos→fnb băng ranh giới).

## Sinh code
```bash
make gen      # protoc → v1/**/*.pb.go
make build    # go build ./...
make verify   # gen + tidy + build + diff (CI)
```
Yêu cầu: `protoc`, `protoc-gen-go@v1.36.11`.

## Consume (ở G0-*, chưa làm tại S-05)
```
// go.mod của fnb-service / pos-service
require github.com/mana-fnb/fnbpos-pb vX.Y.Z
// dev cục bộ chưa có remote: replace github.com/mana-fnb/fnbpos-pb => ../fnbpos-pb
```

## Trạng thái
**S-05 — scaffold + khoá seam contract lõi** (envelope + sale.committed/reversed + menu.query +
availability). Contract đầy đủ (mọi message A6/M*) ở G0-01/02/03.
