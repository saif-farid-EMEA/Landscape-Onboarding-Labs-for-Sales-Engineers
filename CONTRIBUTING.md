# Contributing

These labs only stay useful if they match the current product. If you spot a renamed button, a changed menu, a broken command or an inaccurate claim, please fix it.

## Ground rules

1. **The official Landscape documentation is the source of truth.** If you change a technical claim, cite the doc section it comes from in your PR description: <https://canonical-landscape-documentation.readthedocs-hosted.com/en/latest/>
2. **Web portal first.** If something can be done in the web portal, show it there. Use the terminal only when there's no UI equivalent (e.g. installing the server or registering a client).
3. **No magic.** Every command needs a *"What this does:"* line written for someone who has never used Linux. Never add a script that silently does several things. If a script is unavoidable, keep it short, comment every line and put it in `scripts/landscape/`.
4. **Sales relevance.** Each lab keeps its *Why this matters on a call* section, a *Say it on the call* talk track and *Read more* pointers. If a topic matters less for sales, keep it short and link to the docs.
5. **Accuracy over hype.** Buzzwords are welcome (Sovereign AI, Zero Trust, supply-chain security…) when they're *true* of Landscape. Never claim a feature, certification or integration that the official docs don't support. When unsure, write "check with the product team".
6. **Editions matter.** If a feature is self-hosted only or needs a minimum version, say so.

## Lab template

```markdown
# Lab NN: Title

**Time:** … · **Prerequisite:** …

## 🎯 Why this matters on a call
## Part A: …   (steps with 🖱️ / ⌨️, "What this does:", ✅ Checkpoint)
## 🎤 Say it on the call
## ❓ Check yourself   (answers in <details>)
## 📚 Read more
```
