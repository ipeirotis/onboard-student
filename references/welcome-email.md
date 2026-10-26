# Welcome email template

Subject: `<Project>: access and getting started`. Send as a reply in the
student's thread. Based on the PI's emails to students in fall 2026.

Fill every `<...>`. Check with the PI before sending:
- the From address;
- the Claude Pro reimbursement line (keep or remove for each student);
- that the GitHub invitation and the Cloud roles are already in place.

---

Hi <first name>,

Thanks for sending your GitHub username. The setup for the <project> is in
place:

- I have sent a write-access invitation to your GitHub account,
  <github username>, for <repo name> (<repo URL>). Please accept the
  invitation: <repo URL>/invitations
- Your Google Cloud access is set up for <google email> on the
  <project id> project (https://console.cloud.google.com/home/dashboard?project=<project id>),
  including the service-account permission needed for the repository's
  Claude Code onboarding. Please use that Google account when completing
  the setup.
- Please sign up for Claude Pro (https://claude.ai/) on the $20-per-month
  plan, which includes Claude Code. I will reimburse you $80 for the
  semester, covering four months of the subscription. Please choose monthly
  billing and keep the receipts.

To get started:

- We work on the project through Claude Code, and the GitHub repo serves as
  the project's memory. You describe what you want, Claude proposes changes
  as pull requests, and we review and merge them. These two short posts
  explain the workflow and tooling:
  https://www.behind-the-enemy-lines.com/2026/03/lets-work-on-next-task-claude-code.html
  https://www.behind-the-enemy-lines.com/2026/03/how-i-stopped-being-copy-paster-for-my.html
- Once you have accepted the invitation, start a Claude Code session at
  https://claude.ai/code connected to the <repo name> repo. GitHub will ask
  you to authenticate and install Claude on the repo; approve both.
- Pick a strong passphrase of your own and add it to your Claude Code
  environment settings as CLOUD_CREDENTIALS_KEY. Save it in a password
  manager. Then ask Claude to set up your Google Cloud access for the
  project; the repository already contains the onboarding machinery for
  this. Claude will ask you for a short-lived token, which you generate in
  Cloud Shell while signed in as <google email>.
- Start by reading <brief path> in the repo. <One sentence on what it holds.>
- As a first check, ask Claude to summarize the repo and the brief, and to
  propose a concrete plan for the first steps: <first milestone>.

Best,
<PI first name>
