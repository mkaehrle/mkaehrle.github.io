#!/bin/sh
set -eu

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 RESTRICTIONS PROVIDERS [YYYY-MM-DD]" >&2
  exit 2
fi

restrictions=$1
providers=$2
updated=${3:-$(date +%Y-%m-%d)}

case "$restrictions:$providers" in
  *[!0-9:]*|:*|*:) echo "Restriction and provider counts must be non-negative integers." >&2; exit 2 ;;
esac

case "$updated" in
  ????-??-??) ;;
  *) echo "Date must use YYYY-MM-DD." >&2; exit 2 ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
status_file="$script_dir/../assets/dataset-status.json"
display=$(awk -v n="$restrictions" 'BEGIN { s=n ""; out=""; while (length(s)>3) { out="," substr(s,length(s)-2) out; s=substr(s,1,length(s)-3) } print s out }')
short=$(awk -v n="$restrictions" 'BEGIN { if (n >= 1000000) printf "%.1fM+", n/1000000; else if (n >= 1000) printf "%dk+", int(n/1000); else printf "%d", n }')
month=$(date -j -f %Y-%m-%d "$updated" "+%B %Y")
end_year=${updated%%-*}

tmp_file="$status_file.tmp"
{
  printf '{\n'
  printf '  "status": "Work in progress",\n'
  printf '  "restrictions": %s,\n' "$restrictions"
  printf '  "restrictions_display": "%s+",\n' "$display"
  printf '  "restrictions_short": "%s",\n' "$short"
  printf '  "providers": %s,\n' "$providers"
  printf '  "date_span": "2007–%s",\n' "$end_year"
  printf '  "updated": "%s",\n' "$updated"
  printf '  "updated_display": "%s"\n' "$month"
  printf '}\n'
} > "$tmp_file"
mv "$tmp_file" "$status_file"

echo "Updated $status_file"
