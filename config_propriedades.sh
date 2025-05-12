#!/usr/bin/env bash
# ================================================================
# init_trino_conf.sh –  recria arquivos .properties do Trino
# ================================================================
set -euo pipefail

# ─── 1. Carrega variáveis do .env (se existir) ───────────────────
ENV_FILE="./.env"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

# Permite sobrescrever via argumentos (exemplo: ./script AWS_KEY=foo)
for ARG in "$@"; do
  export "${ARG?}"                  # transforma KEY=value em env
done

# ─── 2. Define variáveis internas (fallbacks) ────────────────────
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-minioadmin}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-minioadmin}"
export HIVE_METASTORE_HOST="${HIVE_METASTORE_HOST:-hive-metastore}"
export HIVE_METASTORE_PORT="${HIVE_METASTORE_PORT:-9083}"
export MINIO_ENDPOINT="${MINIO_ENDPOINT:-http://minio:9000}"

TRINO_DIR="trino/etc"
CATALOG_DIR="$TRINO_DIR/catalog"
mkdir -p "$CATALOG_DIR"

# ─── 3. Arquivo delta.properties ─────────────────────────────────
cat > "$CATALOG_DIR/delta.properties" <<EOF
connector.name=delta-lake
hive.metastore.uri=thrift://${HIVE_METASTORE_HOST}:${HIVE_METASTORE_PORT}
hive.s3.aws-access-key=${AWS_ACCESS_KEY_ID}
hive.s3.aws-secret-key=${AWS_SECRET_ACCESS_KEY}
hive.s3.endpoint=${MINIO_ENDPOINT}
hive.s3.path-style-access=true
hive.s3.ssl.enabled=false
EOF

# ─── 4. Arquivo hive.properties ──────────────────────────────────
cat > "$CATALOG_DIR/hive.properties" <<EOF
connector.name=hive
hive.metastore.uri=thrift://${HIVE_METASTORE_HOST}:${HIVE_METASTORE_PORT}
hive.s3.aws-access-key=${AWS_ACCESS_KEY_ID}
hive.s3.aws-secret-key=${AWS_SECRET_ACCESS_KEY}
hive.s3.endpoint=${MINIO_ENDPOINT}
hive.s3.path-style-access=true
hive.s3.ssl.enabled=false
EOF

# ─── 5. Arquivo jvm.config ───────────────────────────────────────
cat > "$TRINO_DIR/jvm.config" <<'EOF'
-server
-Xmx1G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:+UseGCOverheadLimit
-XX:+ExitOnOutOfMemoryError
-XX:ReservedCodeCacheSize=256M
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
EOF

# ─── 6. Arquivo node.properties ──────────────────────────────────
cat > "$TRINO_DIR/node.properties" <<'EOF'
node.environment=docker
node.data-dir=/data/trino
plugin.dir=/usr/lib/trino/plugin
EOF

# ─── 7. Arquivo config.properties ────────────────────────────────
cat > "$TRINO_DIR/config.properties" <<'EOF'
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
discovery-server.enabled=true
discovery.uri=http://localhost:8080
EOF

# ─── 8. Ajusta permissões ────────────────────────────────────────
chmod 640 "$TRINO_DIR"/*.config "$CATALOG_DIR"/*.properties

echo -e "\n✅  Configurações recriadas em $TRINO_DIR"
