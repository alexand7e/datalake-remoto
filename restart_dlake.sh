#!/usr/bin/env bash
# restart_dlake.sh  ─  derruba e recria todo o Data Lake local
set -euo pipefail

# Caminho dos YAMLs
COMPOSE_DIR="./docker"
COMPOSE_FILES="-f ${COMPOSE_DIR}/compose.storage.yml \
               -f ${COMPOSE_DIR}/compose.metastore.yml \
               -f ${COMPOSE_DIR}/compose.compute.yml \
               -f ${COMPOSE_DIR}/compose.superset.yml \
	       -f ./docker/infra/compose.traefik.yml "

# 1) Cria rede dlake-net se ainda não existir
if ! docker network inspect dlake-net &>/dev/null; then
  echo "🛠️  Criando rede externa dlake-net..."
  docker network create dlake-net
fi

# 2) Derruba tudo
echo "⬇️  Derrubando containers…"
docker compose ${COMPOSE_FILES} down --remove-orphans

# 3) Sobe novamente (detached)
echo "⬆️  Subindo containers…"
docker compose ${COMPOSE_FILES} up -d --pull=always

echo "✅  Data Lake reiniciado com sucesso!"

