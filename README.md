# Martin Kaehrle

Personal research website, published with GitHub Pages.

The site is static and dependency-free.

## Local preview

```sh
python3 -m http.server 8000
```

Then open <http://localhost:8000>. Use another port if 8000 is already occupied.

## Checks

Verify internal links and referenced assets before publishing:

```sh
./scripts/check-links.sh
```

Update the dataset restriction count, provider count, and snapshot date:

```sh
./scripts/update-dataset-status.sh RESTRICTIONS PROVIDERS YYYY-MM-DD
```
