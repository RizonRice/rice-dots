#!/usr/bin/env bash

if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi

dirs=(
  '/bin'
  '/sbin'
  '/usr/bin'
  '/usr/sbin'
  '/usr/local/bin'
  '/usr/local/sbin'
  '/usr/games'
  '/usr/local/games'
  "$HOME/.local/bin"
)

for d in "${dirs[@]}"; do
  if [[ -d "$d" ]]; then
    PATH="$d:$PATH"
  fi
done

export PATH
