# AGENTS.md

This repo holds one Claude Code skill, onboard-student. The repo root is
the skill directory: `SKILL.md` and `references/` are what host repos
vendor into `.claude/skills/onboard-student/` through `install.sh`.
`CLAUDE.md` only imports this file.

## Rules

- **Nothing about a specific person or project lives here.** Names,
  emails, usernames and records belong in the host repo's `docs/team.md`.
  Examples use placeholders.
- **Version every change.** Bump `VERSION` and `metadata.version` in
  `SKILL.md` together (semantic versioning), and add a `CHANGELOG.md`
  entry. Tag releases `vX.Y.Z`.
- **Learn from real runs.** When onboarding in a host repo turns up a step
  that was missing, wrong or blocked, fix the checklist here and release a
  new version; then re-run `install.sh` in the host repos.
- **Keep `install.sh` safe.** It must stage first and replace the
  installed copy only when the whole skill arrived; every `rm -rf` target
  is a literal path or `${VAR:?}`.
- **Write plainly.** Short sentences, one step per line, and say who does
  each step (PI, Claude or student). No em-dashes.
