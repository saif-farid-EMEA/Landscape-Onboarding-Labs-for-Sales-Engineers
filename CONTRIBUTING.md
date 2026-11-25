# Contributing

These labs only stay useful if they match the current product. If you spot a renamed button, a changed menu, a broken command or an inaccurate claim, please fix it.

## Ground rules

1. **The official Landscape documentation is the source of truth.** If you change a technical claim, cite the doc section it comes from in your PR description: <https://canonical-landscape-documentation.readthedocs-hosted.com/en/latest/>
2. **Web portal first.** If something can be done in the web portal, show it there. Use the terminal only when there's no UI equivalent (e.g. installing the server or registering a client).
3. **No magic.** Every command needs a *"What this does:"* line written for someone who has never used Linux. Never add a script that silently does several things. If a script is unavoidable, keep it short, comment every line and put it in `scripts/landscape/`.
4. **Sales relevance.** Each lab keeps its *Why this matters on a call* section, a *Say it on the call* talk track and *Read more* pointers. If a topic matters less for sales, keep it short and link to the docs.
5. **Accuracy over hype.** Buzzwords are welcome (Sovereign AI, Zero Trust, supply-chain security…) when they're *true* of Landscape. Never claim a feature, certification or integration that the official docs don't support. When unsure, write "check with the product team".
6. **Editions matter.** If a feature is self-hosted only or needs a minimum version, say so.
7. **Objectives first.** Every lab opens with a *Learning objectives* table. Each objective starts with an observable verb (explain, configure, demonstrate…), names the course outcome it supports (PO1–PO7, see the README), and says how it's checked: a ✅ checkpoint, an exercise, or a *Check yourself* question tagged with the objective ID. Don't add content that serves no objective, and don't add an objective that nothing checks. Update [`reference/learning-objectives.md`](reference/learning-objectives.md) in the same PR.

## Lab template

```markdown
# Lab NN: Title

**Time:** … · **Prerequisite:** …

## 🎓 Learning objectives
| ID | Objective | Supports | Checked by |
|---|---|---|---|
| LNN-1 | **Verb** … | PO4 | Checkpoint, Part A · Check yourself Q1 |

## 🎯 Why this matters on a call
## Part A: …   (steps with 🖱️ / ⌨️, "What this does:", ✅ Checkpoint)
## 🎤 Say it on the call
## ❓ Check yourself   (answers in <details>, each question tagged with its objective ID)
## 📚 Read more
```
