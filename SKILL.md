---
name: onboard-student
metadata:
  version: "1.0.0"
description: >-
  Checklists for setting up a new research project repo and for onboarding a
  student onto it (GitHub access, Google Cloud roles, Claude Code, cloud
  credentials, API keys, the welcome email, the first week's tasks).
  TRIGGER when the PI asks to onboard, add or set up a student or new team
  member, to draft their welcome or getting-started email, or to set up a
  new project the same way. DO NOT TRIGGER for the student's own credential
  join (that is the cloud-bootstrap skill's Add Team Member flow) or for
  routine project work.
---

# Onboard a student

Two checklists: **A** sets up a new project (once per project), **B** adds
a student (once per person). Each step names who does it. Steps marked
**PI** are ones Claude cannot do from a session: the GitHub integration
cannot create repositories or invite collaborators, and granting a person
IAM roles may be refused by the session's safety check. For those, give the
PI the exact commands or the settings link instead of trying a workaround.

The student works through Claude Code as the project's manager, not its
programmer. Instructions to them say what to ask Claude and what to check,
not what code to write.

## Where things live in the host repo

- `docs/team.md`: the onboarding record, one row per person (format in
  `references/record-template.md`). Create it on first use. Update it at
  every step of checklist B.
- `AGENTS.md`, Cloud section: the service account, its roles, the secrets,
  the buckets, and each person's roles. Keep it in step with what was
  granted.
- `.cloud-config.json`: kept by cloud-bootstrap. Record bucket-level and
  secret-level grants under `bucket_roles` and `secret_roles`.

## A. New project (once)

1. **PI:** create the GitHub repo and the GCP project, both with the same
   name (project IDs are global, 6 to 30 characters, lowercase letters,
   digits, hyphens). Link billing.
2. **Claude:** attach the repo to the session (`add_repo` with push access)
   and write the starting files: a brief (`docs/handover.md`) when the work
   comes from another repo; `AGENTS.md`; `CLAUDE.md` containing only
   `@AGENTS.md`; a README; a `.gitignore` that already lists
   `/credentials.json`, `/credentials_clean.json` and
   `/.cloud-setup-pending.json`.
3. **Claude:** install the skills the project needs into `.claude/skills/`:
   cloud-bootstrap always; for a project that writes a paper, blue-pencil,
   citation-needed and facts-and-figures, with blue-pencil's
   `.claude/commands/paper/` and `.claude/agents/paper-reviser.md`, and a
   `<paper_context>` block in `AGENTS.md`. This skill too.
4. **Claude, with a PI token:** run cloud-bootstrap's first-time setup. The
   PI runs `gcloud config set project <id>` and
   `gcloud auth print-access-token` in Cloud Shell and pastes the token.
   Propose the service account's roles and wait for the PI's approval. The
   token lasts about an hour, and gcloud hands out the same cached token
   until it expires, so do every token task (steps 4 and 5) in one sitting.
5. **Claude, same token:**
   - Enable the APIs the project needs (Service Usage `batchEnable`).
   - Store each pasted API key in Secret Manager as `<PROVIDER>_API_KEY`,
     with `roles/secretmanager.secretAccessor` for the service account on
     that secret, not on the project. Read each one back as the service
     account to check it.
   - Create private buckets (uniform bucket-level access, public access
     prevention enforced), with the service account's role on the bucket,
     not on the project. Check with a test write and delete.
   - Keep the token and pasted keys in a private scratch file outside the
     repo, never in a commit, and delete it when done. Tell the PI the keys
     now sit in the chat transcript and are worth rotating later.
6. **Claude:** for a paper, a `paper/` skeleton (acmart `manuscript` until
   a venue is chosen) and a SessionStart hook that installs LaTeX.
7. **Claude:** `TASKS.md`, a short week-by-week plan revised every week.

## B. Add a student (per person)

1. **Claude:** find in the PI's mail the student's GitHub username and the
   Google account to use for Cloud access. If one is missing, ask the PI. A
   university address that runs on Google Workspace works as a Google
   account. Add the student's row to `docs/team.md`.
2. **PI:** invite the GitHub username with Write access at
   `https://github.com/<owner>/<repo>/settings/access`.
3. **PI**, with the commands Claude prepares: grant the student's Google
   account the project roles the work needs, and key admin on the service
   account only, so the student can create their own key. Example for a
   BigQuery project:
   ```bash
   P=<project-id>; U=user:<student-google-email>
   for R in roles/bigquery.user roles/bigquery.dataEditor; do
     gcloud projects add-iam-policy-binding $P --member=$U --role=$R
   done
   gcloud iam service-accounts add-iam-policy-binding \
     claude-agent@$P.iam.gserviceaccount.com --member=$U \
     --role=roles/iam.serviceAccountKeyAdmin --project=$P
   ```
   Check role names before proposing them (`gcloud iam roles describe`).
   Claude may make the grants itself with a PI token when the PI explicitly
   asks; if the safety check refuses, fall back to the commands. Then read
   the project policy back, and record the roles in `AGENTS.md` and
   `docs/team.md`.
4. **Claude:** draft the welcome email from `references/welcome-email.md`
   as a Gmail draft, replying in the student's thread. Tell the PI to check
   the From address and the reimbursement line, and to send it only after
   steps 2 and 3, since the email says access is ready.
5. **Student**, following the email: accept the invitation; sign up for
   Claude Pro; start a Claude Code session on the repo and approve the
   GitHub authentication and the Claude app install; set their own
   passphrase as `CLOUD_CREDENTIALS_KEY` in their Claude Code environment
   settings and in a password manager; ask Claude to set up their Google
   Cloud access (cloud-bootstrap's Add Team Member flow, with a token they
   make in Cloud Shell signed in as their own Google account).
6. **Claude, in the student's session:** check that their credential file
   is merged and that a query runs as the service account. Point them to
   the brief and week 1 of `TASKS.md`. Mark the row in `docs/team.md`.
7. **PI:** settle any reimbursement the email promised and note it in
   `docs/team.md`.
