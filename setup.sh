PROJECT_NAME="datalake"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Configurações do Git
GIT_USER="alexand7e"
GIT_EMAIL="alexandrepitstop@gmail.com"
GITHUB_REPO_URL="git@github.com:alexand7e/datalake.git"

# Inicializa Git se não existir
if [ ! -d .git ]; then
    echo "📦 Inicializando repositório Git..."
    git init
    git config user.name "$GIT_USER"
    git config user.email "$GIT_EMAIL"
else
    echo "✔️ Repositório Git já inicializado."
fi

# Adiciona o remote se não existir
if ! git remote | grep -q origin; then
    echo "🔗 Adicionando remote origin: $GITHUB_REPO_URL"
    git remote add origin "$GITHUB_REPO_URL"
else
    echo "🔁 Remote origin já configurado."
fi

# Commit inicial (se ainda não houver commits)
if [ -z "$(git log --oneline)" ]; then
    echo "📥 Adicionando arquivos e realizando commit inicial..."
    git add .
    git commit -m "Projeto Superset com Redis, Traefik e configuração via superset_config.py"
else
    echo "📌 Commit já existente. Pulando commit inicial."
fi

# Define a branch principal como main
git branch -M main

# Push para o repositório remoto
echo "🚀 Enviando para o repositório remoto..."
git push -u origin main

echo ""
echo "✅ Projeto sincronizado com sucesso!"
echo ""
