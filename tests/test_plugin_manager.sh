#!/bin/bash
mkdir -p mock_home

# Mock git clone
mkdir -p mock_bin
cat <<BIN > mock_bin/git
#!/bin/bash
if [[ "$*" == *"clone"* ]]; then
  echo "Mocking git clone..."
  # Create a fake target dir
  mkdir -p "${@: -1}"
  exit 0
else
  /usr/bin/git "$@"
fi
BIN
chmod +x mock_bin/git

# Run with mock home and PATH
PATH=$PWD/mock_bin:$PATH REPO_ROOT=$PWD HOME=$PWD/mock_home bash install.sh --dry-run
if [ -d "mock_home/.local/share/nvim/site/pack/lazy/start/lazy.nvim" ] || [ -f "mock_home/.vim/autoload/plug.vim" ]; then
  echo "Plugin manager correct"
  rm -rf mock_home mock_bin
  exit 0
else
  echo "Plugin manager failed"
  rm -rf mock_home mock_bin
  exit 1
fi
