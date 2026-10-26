# onboard-student

A Claude Code skill for setting up a research project repo and onboarding
a student onto it: GitHub access, Google Cloud roles, Claude Code, cloud
credentials, API keys in Secret Manager, the welcome email, and the first
week's plan.

It is written for a PI who runs student projects through Claude Code on
the web, with one GitHub repo and one Google Cloud project per project, and
credentials managed by
[cloud-bootstrap](https://github.com/ipeirotis/cloud-bootstrap). The
student works as the project's manager through Claude Code rather than as
its programmer.

## What it contains

| File | Purpose |
|---|---|
| `SKILL.md` | Checklist A (new project) and checklist B (new student). Each step says whether the PI, Claude, or the student does it. |
| `references/welcome-email.md` | The welcome email, with placeholders. |
| `references/record-template.md` | The onboarding record the host repo keeps in `docs/team.md`. |
| `install.sh` | Installs or updates the skill in a host repo. |

## Install in a project

From the host repo's root, with this repo cloned next to it:

```bash
bash ../onboard-student/install.sh
git add .claude/skills/onboard-student && git commit -m "Add the onboard-student skill"
```

Or clone it first (needs read access to this repo):

```bash
git clone -q --depth 1 https://github.com/ipeirotis/onboard-student.git /tmp/onboard-student
bash /tmp/onboard-student/install.sh
```

In a Claude Code session, asking "install the onboard-student skill" is
enough: Claude clones this repo and runs `install.sh`. Pin a version with
`ONBOARD_STUDENT_REF=v1.0.0`.

The skill is vendored into `.claude/skills/onboard-student/`, so the host
repo works without access to this one. Re-run the installer to update.

## Use

Ask Claude in the host repo, for example:

- "Onboard <name> onto this project."
- "Draft the welcome email for <name>."
- "Set up a new project the way we set up bigquery-nl2sql-study."

The skill keeps the per-person record in the host repo (`docs/team.md`),
never in this repo, so nothing about a specific student lives here.

## What Claude cannot do from a session

- Create GitHub repositories or invite collaborators: the PI does these.
- Grant a person IAM roles without the PI's explicit approval: the
  session's safety check may refuse, and the skill then hands the PI the
  commands.
- Anything that needs a Google Cloud permission the project's service
  account lacks: that takes a short-lived token from the PI.

## Changes

See [CHANGELOG.md](CHANGELOG.md). Version in [VERSION](VERSION).
