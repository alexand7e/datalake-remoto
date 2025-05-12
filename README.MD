# 🏞️ Projeto DataLake Local com Trino, Hive, MinIO e Superset

Este projeto fornece uma infraestrutura local para **análise de dados moderna**, baseada em arquitetura de DataLake, usando componentes como Trino, Hive, MinIO e Superset. Ele permite simular um ambiente de produção completo para ingestão, consulta distribuída, metastore e visualização de dados.

---

## 📦 Funcionalidades Principais

- ✅ DataLake local com suporte a Bronze, Silver e Gold zones
- ✅ Armazenamento S3 compatível com MinIO
- ✅ Catálogo de metadados com Hive Metastore + PostgreSQL
- ✅ Engine distribuída de consultas com Trino
- ✅ Visualização e dashboards com Apache Superset
- ✅ Configuração modular com `docker-compose` por serviço

---

## 🧱 Arquitetura do Projeto

```

┌─────────────┐         ┌──────────────┐
│   Superset  │◄──────►│    Trino     │
└─────────────┘         └─────┬────────┘
│
┌────────▼────────┐
│     Hive        │
│   Metastore     │
└────────┬────────┘
│
┌────────▼─────────┐
│     PostgreSQL   │
└────────┬─────────┘
│
┌──────▼──────┐
│   MinIO S3  │
└─────────────┘

````

---

## 🚀 Como Utilizar

### 1. Pré-requisitos

- Docker
- Docker Compose
- Domínio público (caso opte por usar Traefik)
- `.env` configurado corretamente (veja o `.env.example`)

### 2. Configurar Variáveis de Ambiente

Copie o arquivo de exemplo:

```bash
cp .env.example .env
````

Edite com suas credenciais, domínios e senhas desejadas.

---

## 🧰 Primeira Execução

Execute o script de setup inicial:

```bash
chmod +x setup.sh
./setup.sh
```

Esse script prepara diretórios, valida variáveis e configura permissões.

---

## 🏗️ Subindo os Serviços

Você pode iniciar os serviços em blocos separados ou todos de uma vez:

### 🔹 Iniciar por blocos

```bash
docker compose -f docker/compose.storage.yml up -d         # MinIO
docker compose -f docker/compose.metastore.yml up -d       # PostgreSQL + Hive
docker compose -f docker/compose.compute.yml up -d         # Trino
docker compose -f docker/compose.superset.yml up -d        # Superset
```

### 🔹 Iniciar tudo

```bash
./restart_dlake.sh
```

---

## 🌐 Acesso com ou sem Proxy Reverso

### 🔁 Opção 1: Com Traefik + rede `traefik-net` (recomendado)

Configure o proxy reverso para usar domínios como:

* `https://minio.seudominio.com.br`
* `https://bi.seudominio.com.br`
* `https://trino.seudominio.com.br`

#### Criar rede externa Traefik:

```bash
docker network create traefik-net
```

Os `docker-compose` já estão preparados com labels e uso de `${DOMAIN_BASE}` para domínios públicos. Certifique-se de configurar corretamente no seu `.env`.

### 🖥️ Opção 2: Acesso local via `localhost`

Se não quiser usar proxy reverso, os serviços funcionam localmente:

| Serviço  | URL                                            |
| -------- | ---------------------------------------------- |
| MinIO    | [http://localhost:9001](http://localhost:9001) |
| Superset | [http://localhost:8088](http://localhost:8088) |
| Trino UI | [http://localhost:8080](http://localhost:8080) |

Basta remover ou ignorar as labels `traefik.*` dos `docker-compose` e expor as portas diretamente.

---

## 📁 Estrutura do Projeto

```
.
├── .env.example                 # Modelo de variáveis
├── config_propriedades.sh      # Script auxiliar (opcional)
├── setup.sh                    # Prepara pastas e permissões
├── restart_dlake.sh            # Sobe todos os serviços
├── docker/
│   ├── compose.compute.yml     # Trino
│   ├── compose.metastore.yml   # Postgres + Hive
│   ├── compose.storage.yml     # MinIO
│   ├── compose.superset.yml    # Superset
│   ├── init/                   # Scripts de inicialização
│   └── logs/                   # Logs persistentes
├── hive/conf/hive-site.xml     # Config do Hive
├── trino/etc/                  # Config do Trino (catalogs, jvm, node)
├── notebooks/                  # Espaço para análise exploratória
```

---

## 🧪 Testes e Consultas

* Crie tabelas Delta Lake via Trino ou Hive
* Use Superset para consultar os dados e montar dashboards
* Dados são armazenados no MinIO (`s3://bronze/...`, etc.)

---

## 📊 Roadmap Futuro

* [ ] Suporte a upload direto de arquivos no Superset
* [ ] Integração com JupyterLab local
* [ ] Templates de notebooks de exploração
* [ ] Pipeline de ingestão automática

---

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request com melhorias.

---

## 📜 Licença

Projeto livre para uso acadêmico e corporativo. Respeite as licenças das ferramentas integradas (Apache 2.0, MIT, etc.).

---

## 👨‍💻 Autor

**Alexandre Barros**
📧 [alexand7e@gmail.com](mailto:alexand7e@gmail.com)
🔗 [github.com/alexand7e](https://github.com/alexand7e)

