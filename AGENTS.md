# AGENTS.md

## Project Overview

A Docker-based LAMP stack for running **old** PHP sites locally. It exists so that a backup of an
ancient site (e.g. an old Joomla or WordPress install) can be restored and run against period-accurate
Apache, PHP and MySQL/MariaDB versions instead of failing against a modern host's toolchain. The stack
is configurable from as old as Apache 2.0 / PHP 5.6 / MySQL 5.5 up to the latest versions, so a site can
be restored on an old stack and then walked forward through PHP/database upgrades until it matches a
modern live host, at which point it can be backed up again (e.g. with Akeeba Backup) and deployed live.

Services are defined in `docker-compose.yml`: `apache/`, `php/`, `mysql/` and `ftp/` each hold the
Dockerfile/config for that service; `public_html/` is the webroot; `build/` holds build-time assets.
Configuration is via a `.env` file copied from `env.sample`.

## Commands

- `./up` — bring the stack up (see `env.sample`/`.env` for configuration).
- `./down` — bring the stack down; **destroys the containers** (data volumes survive).
- `docker compose stop` / `docker compose start` — stop/start without destroying containers.

The `up`/`down` scripts are not expected to work under WSL/WSL2 due to filesystem permission handling
between Windows, the Hyper-V VM and the containers; use Docker/PowerShell directly there instead.

## Git: commit and tag outside the sandbox

Commits and tags are always signed, with a key held in 1Password. The 1Password signing agent is reached
over a local socket that agent sandboxes do not expose, so a sandboxed `git commit` or `git tag` **always**
fails (e.g. `error: 1Password: Could not connect to socket. Is the agent running?`).

Run every `git commit` and `git tag` **outside the sandbox from the first attempt** — in Claude Code with
`dangerouslyDisableSandbox: true`, in other harnesses with their equivalent unsandboxed / escalated
execution. Do not try the sandboxed form first, do not diagnose the failure, and never work around it
with `--no-gpg-sign`, `-c commit.gpgsign=false` or unsigned tags.

## Project memory

Project memory lives in `.claude/memory/`, committed with the code, so that it is shared across machines
and across agentic harnesses (Claude Code, Codex, Qwen Code, Kimi Code, Junie, …).

There are no memory files yet. When there is something worth remembering, create `.claude/memory/`,
the topic file, and a table here mapping each file to a concrete trigger ("Before you… | Read").

### Recording new memories

This is the **default and only** place for project memory. Do not write memories for this project to a
harness's private memory store (such as Claude Code's auto-memory under `~/.claude/projects/`); write
them here instead:

- Add to the existing topic file when one fits; otherwise create a new kebab-case `.md` file named after
  the topic, and add a row for it to the table above with a concrete trigger.
- Plain Markdown, no frontmatter. State the rule, then **Why:** (the reason or incident behind it) and
  **How to apply:**. Link related files with relative Markdown links.
- Don't record what the code, Git history or an existing `AGENTS.md` already says — update that
  `AGENTS.md` instead when the rule belongs there. Remove or correct entries that turn out wrong.
- These files are committed: no secrets, credentials, customer data or personal details.
