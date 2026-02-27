# Initial Concept

The goal is to extract a Vim-only configuration dotfiles repository to be used publicly on servers where only Vim is needed, without AI features or authentication information.

Source References:
`/home/fkn93/dotfiles/zettelkasten/dagnetz/2026/02/27/vimだけのためのdotfilesを構築してpublic公開したい.md`

## 必要なもの
- AI機能や認証が不要な全vimplugin
- シェルによる自動インストール(vimの動作だけでいい /home/fkn93/dotfiles/shellscripts/init_mac.sh を削る形で)

## 不要なもの
- vimに関連のないもの
- 認証情報など

---

# Product Guide

## Vision
To provide a lightweight, secure, and purely Vim-focused dotfiles configuration repository designed for deployment on remote servers. It strips away all unnecessary overhead, specifically AI features and sensitive authentication credentials, ensuring a fast and clean Vim environment anywhere.

## Target Audience
- Developers and system administrators who frequently work on remote Linux/Unix servers.
- Users who want their familiar Vim environment without the bloat of non-essential plugins or the security risk of deploying private keys/tokens.

## Key Features
- **Pure Vim Environment**: Contains only plugins that enhance core text editing and navigation.
- **Secure by Default**: Strictly excludes any authentication keys, tokens, or AI-integration plugins (like Copilot, etc.).
- **Automated Setup**: Includes a streamlined, shell-based installation script optimized solely for Vim setup (derived from `init_mac.sh`).
- **Lightweight Footprint**: Removes all non-Vim dotfiles to minimize deployment time and disk usage.

## Use Cases
- SSHing into a remote server and quickly spinning up a fully-configured Vim editor.
- Sharing a baseline Vim configuration publicly as an open-source template without leaking personal dotfiles.