# .github

Default community files for LusoCryptoLabs repositories: the issue forms, the pull request
template, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY and SUPPORT. GitHub shows each one in any
repository that has no file of its own of that kind.

It also holds `pr-check`, a reusable workflow that checks a pull request's title, and from
outside contributors its description. A repository calls it from `.github/workflows/pr.yml`:

```yaml
name: pr

on:
  pull_request:
    types: [opened, edited, synchronize, reopened, ready_for_review]

permissions:
  contents: read

jobs:
  pr:
    uses: LusoCryptoLabs/.github/.github/workflows/pr-check.yml@main
```

The job reports as `pr / title and description`, the name each repository's ruleset requires on its default branch.

The check is `scripts/pr-check.js`. It reads only the event GitHub gives the job, with no token
and no API call. `sh test/run.sh` runs it against the cases in that file.
