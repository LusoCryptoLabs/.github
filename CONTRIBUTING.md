# Contributing

Thanks for taking the time. This page covers every LusoCryptoLabs repository. A repository's
own CONTRIBUTING.md adds to it.

## Issues

- Bugs, feature requests and questions each have a form. Fill in the required fields: a report
  we can reproduce is the one that gets fixed first.
- Search open and closed issues before opening one.
- A security problem never goes in an issue. See [SECURITY.md](SECURITY.md).

## Pull requests

- Small fixes (a typo, the docs, an obvious bug): open the pull request directly.
- Anything bigger, and every new feature: open an issue first, so we agree on the approach
  before you spend time on it. Link it from the pull request, for example `Fixes #12`.
- One change per pull request. Keep unrelated formatting out.
- Title: `type(scope): short imperative`, lowercase, at most 72 characters. Types: `feat`,
  `fix`, `docs`, `style`, `refactor`, `test`, `perf`, `build`, `ci`, `chore`, `revert`. The
  scope is optional. For example `fix(core): avoid caching cells without data`, `ci: cache pnpm
  store`.
- Description: fill in the template, "What changes", "Why" and "How it was checked".
- CI must pass. The CI of a first contribution runs once a maintainer approves it.
- We squash on merge, so the pull request title becomes the commit subject.

## The check on each pull request

Every pull request runs `pr / title and description`. It checks the title, and for
contributors from outside it also checks that the description says what changes and how it was
checked, and that a new feature links its issue. Its log says what to fix. Edit the title or
the description and it runs again.

## License

By contributing, you agree that your contribution is licensed under the repository's license.

## Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
