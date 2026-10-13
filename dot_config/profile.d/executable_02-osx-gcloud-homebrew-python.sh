# Use the version-agnostic python@3 symlink so this doesn't break when
# Homebrew bumps the default python minor version (e.g. 3.13 -> 3.14).
# Note: Homebrew dropped the old `opt/python3` alias link; `opt/python@3` remains.
export CLOUDSDK_PYTHON="$(brew --prefix)/opt/python@3/libexec/bin/python"
