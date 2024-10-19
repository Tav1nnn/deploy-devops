#!/bin/bash

# Variáveis
FLASK_APP_PID=$(ps aux | grep '[f]lask' | awk '{print $2}')

# Matar a aplicação Flask se estiver rodando
if [ -n "$FLASK_APP_PID" ]; then
    echo "Matando a aplicação Flask com PID $FLASK_APP_PID"
    kill -9 $FLASK_APP_PID
else
    echo "Nenhuma aplicação Flask em execução."
fi

# Fazer o git pull para obter as últimas mudanças
echo "Fazendo git pull"
git pull

# Rodar a aplicação Flask novamente (ajuste conforme necessário)
echo "Iniciando a aplicação Flask"
nohup flask run --host=0.0.0.0 --port=5000 &

# Fim do script
echo "Deploy finalizado!"
