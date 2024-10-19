#!/bin/bash

# Configurações iniciais
REPO_URL="URL_DO_REPOSITORIO_GIT"
APP_DIR="/caminho/para/o/diretorio_da_aplicacao"
VENV_DIR="$APP_DIR/devops"
APP_NAME="main.py"
FLASK_PORT=5000

echo "Iniciando processo de deploy..."

# Verifica se o diretório da aplicação já existe
if [ -d "$APP_DIR" ]; then
  echo "Diretório da aplicação existe. Atualizando arquivos..."
  cd $APP_DIR
  # Para o processo existente da aplicação Flask (caso esteja rodando)
  PID=$(lsof -ti:$FLASK_PORT)
  if [ -n "$PID" ]; then
    echo "Matando processo existente na porta $FLASK_PORT..."
    kill -9 $PID
  fi
  
  # Atualizar o repositório
  git pull origin main
else
  echo "Diretório da aplicação não encontrado. Clonando repositório..."
  git clone $REPO_URL $APP_DIR
  cd $APP_DIR
fi

# Remover arquivos antigos e clonar novos
echo "Removendo arquivos antigos..."
rm -rf $APP_DIR/*
echo "Baixando novos arquivos do repositório..."
git clone $REPO_URL $APP_DIR

# Criar ou acessar o ambiente virtual
if [ ! -d "$VENV_DIR" ]; then
  echo "Criando ambiente virtual..."
  python3 -m venv $VENV_DIR
fi

echo "Ativando ambiente virtual..."
source $VENV_DIR/bin/activate

# Instalar dependências
echo "Instalando dependências..."
pip install -r requirements.txt

# Iniciar a aplicação Flask
echo "Iniciando aplicação Flask..."
nohup python3 $APP_DIR/$APP_NAME --host=0.0.0.0 --port=$FLASK_PORT > flask.log 2>&1 &

echo "Deploy concluído com sucesso!"

