#!/usr/bin/env sh
# abortar no caso de erros
set -e
# build
npm run build
# navegar para a pasta com o conteúdo compilado
cd dist 

git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:lterates/is2go-Deploy.git
cd - 