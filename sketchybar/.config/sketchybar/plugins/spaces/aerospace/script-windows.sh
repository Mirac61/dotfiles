#!/bin/bash
export RELPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
"$RELPATH/plugins/spaces/aerospace/script-space.sh" "$1"
