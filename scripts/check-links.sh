#!/bin/bash
set -eu

site_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
status=0

while IFS= read -r page; do
  while IFS= read -r link; do
    case "$link" in
      ''|'#'*|http://*|https://*|mailto:*|tel:*|data:*|javascript:*) continue ;;
    esac

    clean=${link%%\#*}
    clean=${clean%%\?*}
    case "$clean" in
      /*) target="$site_root$clean" ;;
      *) target="$(dirname -- "$page")/$clean" ;;
    esac

    if [ ! -e "$target" ]; then
      printf 'Broken link: %s -> %s\n' "${page#"$site_root/"}" "$link" >&2
      status=1
    fi
  done < <(rg -o '(href|src)="[^"]+"' "$page" | sed -E 's/^[^=]+="([^"]+)"$/\1/')
done < <(find "$site_root" -name '*.html' -type f -print)

if [ "$status" -eq 0 ]; then
  printf 'All internal links and assets are present.\n'
fi

exit "$status"
