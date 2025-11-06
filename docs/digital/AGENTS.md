# Repository Guidelines

## Project Structure & Module Organization
- `docs/` is the source of truth; contribute topic chapters in subfolders like `digital/`, `analog/`, `verification/`, and keep shared introductions in `contents/`.
- Reuse assets from `_static/` for logos and figures, and stage new media there so Sphinx copies them into the build.
- Helper utilities live in `scripts/`; update or extend `scripts/count_min_drc_rules.py` when introducing new rule tables so the automated counts stay accurate.
- Build artifacts land in `_build/`; delete it before committing to avoid bloating diffs.

## Build, Test, and Development Commands
- `python3 -m venv docs_env && source docs_env/bin/activate` creates an isolated environment aligned with ReadTheDocs.
- `pip install -r docs/requirements.txt` pulls the exact Sphinx extensions used in CI and locally.
- `make docs` (run from `docs/`) cleans `_build/`, installs deps, runs preprocessing scripts, and renders HTML to `_build/html`.
- `make latexpdf` produces PDF output; use it when verifying pagination-sensitive updates.

## Coding Style & Naming Conventions
- Author content in reStructuredText (`.rst`) with 3-space indentation for nested lists and directives, mirroring the existing chapters.
- Prefer sentence-case section headings and keep line widths near 100 characters to match current files.
- Use Sphinx roles like ``:ref:`` and ``:doc:`` for cross-links, and wrap commands in ``.. code-block:: bash`` for syntax highlighting.
- Python helpers in `scripts/` follow snake_case names and should include brief module-level docstrings explaining their role in the flow.

## Testing Guidelines
- Run `make docs` before every push; it invokes `scripts/count_min_drc_rules.py` and fails fast on broken references or syntax errors.
- Execute `sphinx-build -b linkcheck docs docs/_build/linkcheck` when editing hyperlinks to catch stale URLs.
- For rule tables or generated data, rerun the relevant script (e.g., `python3 docs/scripts/count_min_drc_rules.py`) and commit refreshed outputs.
- Capture warnings emitted during local builds; resolve or explicitly justify them in the merge request description.

## Commit & Pull Request Guidelines
- Follow conventional commit prefixes (`docs:`, `fix:`, `chore:`) with optional scopes (`docs(digital): ...`) as seen in recent history.
- Keep commits focused on a single topic and include summary bullet points in the message body for substantial changes.
- Reference GitHub issues with `Fixes #NN` when applicable and attach rendered screenshots if visuals change.
- PRs should state the verification commands run, flag any outstanding warnings, and request domain reviewers for affected sections.
