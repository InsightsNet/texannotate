DIR="data/texstudio/"
if [ -d "$DIR" ]; then
  echo "Updating ${DIR}..."
  cd "$DIR"
else
  echo "Creating ${DIR}..."
  mkdir "$DIR"
  cd "$DIR"
  git init
  git remote add origin https://github.com/texstudio-org/texstudio.git
  git config core.sparsecheckout true
  echo "completion/*" >> .git/info/sparse-checkout
fi
git pull --depth=1 origin master