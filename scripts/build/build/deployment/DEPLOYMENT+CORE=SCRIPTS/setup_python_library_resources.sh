#!/bin/bash
# scripts/setup_python_library_resources.sh
# Setup script to download/clone popular Python libraries/tools for LI-FI project reference.
# HARDWARE_VERIFY: Run on Linux/macOS (Raspberry Pi compatible). Requires git, pip, and optionally conda.
#
# Usage:
#   bash scripts/setup_python_library_resources.sh

set -e

WORKSPACE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LIBRARY_DIR="$WORKSPACE_DIR/Python-Library"
mkdir -p "$LIBRARY_DIR"

# List of (name, install_type, source) tuples
LIBRARIES=(
  "arrow pip arrow"
  "astropy pip astropy"
  "autopep8 pip autopep8"
  "beautifulsoup4 pip beautifulsoup4"
  "biopython pip biopython"
  "bokeh pip bokeh"
  "colorama pip colorama"
  "conda manual https://docs.conda.io/en/latest/miniconda.html"
  "cubes git https://github.com/DataBrewery/cubes.git"
  "dask pip dask"
  "deap pip deap"
  "delorean pip delorean"
  "django pip django"
  "dmelt git https://github.com/DMelt/dmelt.git"
  "fire pip fire"
  "flashtext git https://github.com/vi3k6i5/flashtext.git"
  "flask pip flask"
  "gensim pip gensim"
  "graph-tool manual https://git.skewed.de/count0/graph-tool"
  "jupyter pip jupyter"
  "lightgbm pip lightgbm"
  "luminoth git https://github.com/tryolabs/luminoth.git"
  "mahotas pip mahotas"
  "matplotlib pip matplotlib"
  "mlpy git https://github.com/mlpy/mlpy.git"
  "networkx pip networkx"
  "nilearn pip nilearn"
  "nltk pip nltk"
  "numpy pip numpy"
  "opencv-python pip opencv-python"
  "pandas pip pandas"
  "pillow pip pillow"
  "pip pip pip"
  "pipenv pip pipenv"
  "plotly pip plotly"
  "poetry pip poetry"
  "pybrain git https://github.com/pybrain/pybrain.git"
  "pygame pip pygame"
  "pyglet pip pyglet"
  "pynlpl git https://github.com/proycon/pynlpl.git"
  "pyspark pip pyspark"
  "python-weka-wrapper pip python-weka-wrapper3"
  "pytorch pip torch"
  "qutip pip qutip"
  "requests pip requests"
  "sagemath manual https://www.sagemath.org/download.html"
  "scientificpython git https://github.com/scipy/scientificpython.git"
  "scikit-image pip scikit-image"
  "scikit-learn pip scikit-learn"
  "scipy pip scipy"
  "scoop pip scoop"
  "scrapy pip scrapy"
  "selenium pip selenium"
  "spacy pip spacy"
  "spark-mllib pip pyspark"
  "sqlalchemy pip sqlalchemy"
  "statsmodels pip statsmodels"
  "sunpy pip sunpy"
  "sympy pip sympy"
  "tensorflow pip tensorflow"
  "textblob pip textblob"
  "theano pip theano"
  "tomopy pip tomopy"
  "veusz pip veusz"
  "vocabulary git https://github.com/aparrish/vocabulary.git"
  "wxpython pip wxpython"
  "xgboost pip xgboost"
)

# Function to clone a git repo
clone_git() {
  local url="$1"
  local name="$2"
  local dest="$LIBRARY_DIR/$name"
  if [ ! -d "$dest" ]; then
    echo "[INFO] Cloning $name from $url ..."
    git clone --depth 1 "$url" "$dest"
  else
    echo "[INFO] $name already cloned."
  fi
}

# Function to pip install into a venv
pip_install() {
  local pkg="$1"
  source "$LIBRARY_DIR/venv/bin/activate"
  if ! pip show "$pkg" &>/dev/null; then
    echo "[INFO] Installing $pkg via pip ..."
    pip install "$pkg"
  else
    echo "[INFO] $pkg already installed in venv."
  fi
  deactivate
}

# Create a venv for pip installs
if [ ! -d "$LIBRARY_DIR/venv" ]; then
  python3 -m venv "$LIBRARY_DIR/venv"
fi

# Main install loop
for entry in "${LIBRARIES[@]}"; do
  set -- $entry
  name="$1"; type="$2"; src="$3"
  case "$type" in
    git)
      clone_git "$src" "$name"
      ;;
    pip)
      pip_install "$src"
      ;;
    manual)
      echo "[MANUAL] $name: Please install manually or follow: $src"
      ;;
    *)
      echo "[WARN] Unknown install type for $name"
      ;;
  esac
  echo "---"
done

echo "[INFO] All requested libraries/tools are now available in $LIBRARY_DIR."
echo "[REMINDER] Some tools (Conda, SageMath, graph-tool) require manual install. See above."
