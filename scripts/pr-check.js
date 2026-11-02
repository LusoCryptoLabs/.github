// Checks a pull request's title and, for people outside the account, its description.
// Reads the event GitHub gives the job; makes no API call and needs no token.
const fs = require('fs')

const pr = JSON.parse(fs.readFileSync(process.env.GITHUB_EVENT_PATH, 'utf8')).pull_request

// Bots (Dependabot) write their own titles and descriptions; a maintainer reviews those.
if (pr.user && pr.user.type === 'Bot') {
  console.log('ok: opened by a bot')
  process.exit(0)
}

const errors = []

const title = pr.title.trim()
const types = ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'perf', 'build', 'ci', 'chore', 'revert']
const m = title.match(/^([a-z]+)(\([A-Za-z0-9._/-]+\))?!?: \S/)
if (!m || !types.includes(m[1]))
  errors.push(
    `The title should read "type(scope): what it does", for example "fix(core): avoid caching cells without data". ` +
      `Types: ${types.join(', ')}. The scope is optional.`,
  )
if (title.length > 72) errors.push(`The title is ${title.length} characters; keep it to 72.`)

const inside = ['OWNER', 'MEMBER', 'COLLABORATOR'].includes(pr.author_association)
if (!inside) {
  const body = (pr.body || '').replace(/<!--[\s\S]*?-->/g, '').replace(/\r\n/g, '\n')
  // The text under a "## name" heading, up to the next "## " heading or the end.
  const section = (name) => {
    const lines = body.split('\n')
    const start = lines.findIndex((l) => l.trim().toLowerCase() === `## ${name}`.toLowerCase())
    if (start < 0) return ''
    const rest = lines.slice(start + 1)
    const end = rest.findIndex((l) => l.startsWith('## '))
    return (end < 0 ? rest : rest.slice(0, end)).join('\n').trim()
  }
  if (!section('What changes')) errors.push('Say what changes, under "## What changes".')
  if (!section('How it was checked')) errors.push('Say how you checked it, under "## How it was checked".')
  if (m && m[1] === 'feat' && !/#\d+|\/issues\/\d+/.test(body))
    errors.push('A new feature needs an issue first, so it can be discussed before the work: link it, for example "Fixes #12".')
}

if (errors.length) {
  for (const e of errors) console.log(`::error::${e}`)
  process.exit(1)
}
console.log('ok')
