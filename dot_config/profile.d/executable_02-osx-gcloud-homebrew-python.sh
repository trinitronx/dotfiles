# Use the version-agnostic python3 symlink so this doesn't break when
# Homebrew bumps the default python minor version (e.g. 3.13 -> 3.14).
export CLOUDSDK_PYTHON="$(brew --prefix)/opt/python3/libexec/bin/python"
