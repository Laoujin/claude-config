---
name: new-presentation
description: Use when starting a new Slidev talk/presentation with the itenium theme — scaffolds a new talk repo with the theme as a git submodule. Triggers — "new presentation", "new talk", "new slide deck", "start a slidev deck".
---

# New Presentation (itenium Slidev)

Scaffold a fresh talk. Each talk lives in **its own repo** with the itenium theme
(`itenium-be/Presentations`) as a git submodule under `presentation/theme`. The
`scaffold.ts` script in the theme does all the wiring.

## Scaffold

```bash
mkdir my-talk && cd my-talk
git init
git submodule add https://github.com/itenium-be/Presentations.git presentation/theme
bun run presentation/theme/scripts/scaffold.ts
```

The script creates `presentation/{slides.md,images/,package.json}`, plus
`ElevatorPitch.md`, `LICENSE`, `README.md`, `.gitignore`, and runs `bun install`.
It derives the talk title/slug from the git remote (falls back to the dir name),
so set the `origin` remote first if the dir name isn't the repo name.

## Run it

```bash
cd presentation
bun run dev      # dev server → http://localhost:3030  (presenter: /presenter)
bun run build    # build for GitHub Pages
bun run export   # export to .pptx
```

## After scaffolding

- Fill in `slides.md` frontmatter: `title`, `subTitle`, `track` (lowercase),
  `type`, `first` (YYYY-MM-DD), `aspectRatio` (always set — the starter emits
  `16/10`; use `16/9` for projectors, restart dev server, not hot-reloaded).
  Optional: `lastUpdate`.
- Write `ElevatorPitch.md` (abstract / audience / takeaways) — shown on the site.
- To publish on the index site, add to the theme repo's `talks.yaml`:
  `- repo: itenium-be/my-talk` / `  published: true`.

## Reference

- Layouts & features: `presentation/theme/LAYOUTS.md`.
- Adding slide images: the theme's `adding-slide-image` skill.
- Update the theme later: `cd presentation/theme && git pull`.

## Common Mistakes

- **Not a git repo / no submodule.** `scaffold.ts` expects to run from a repo with
  `presentation/theme` present. `git init` and add the submodule first.
- **Wrong title/slug.** Derived from the git remote — set `origin` before scaffolding
  if the dir name differs from the intended repo name.
- **bun, not npm.** Theme and talks use bun/bunx throughout.
