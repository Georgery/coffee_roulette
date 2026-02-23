# Coffee Roulette

A static website built with Flutter and Dart, hosted on GitHub Pages.

**Live site:** https://georgery.github.io/coffee_roulette/

## Project Structure

- `lib/` — Dart/Flutter source code
- `web/` — Web-specific assets and index.html template
- `docs/` — Built website (served by GitHub Pages)

## Development

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)

### Build and deploy

The website is built directly into the `docs/` folder, which GitHub Pages serves.

```bash
flutter build web --base-href "/coffee_roulette/" --output docs
```

**Why `--base-href`?**  
GitHub Pages serves this site at `https://georgery.github.io/coffee_roulette/` (not at the root). The `--base-href` flag ensures all asset paths are relative to `/coffee_roulette/`.

**Why `--output docs`?**  
GitHub Pages can only serve from the root or `/docs` folder. This flag builds directly to `docs/`, avoiding a manual copy step.
