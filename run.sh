#!/bin/bash
# Wrapper que ejecuta scripts desde infra/ cuando se llama desde la raíz
cd "$(dirname "$0")" || exit 1
exec ./infra/run.sh "$@"
