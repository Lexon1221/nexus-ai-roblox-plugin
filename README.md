# Nexus AI Roblox Studio Plugin

Connect Roblox Studio directly to the Nexus AI Platform for AI-powered development.

## Features

- ⚡ **Send-to-Studio** — Generate code on the web, receive it instantly in Studio
- ✦ **AI Refactoring** — Select any script, get AI-powered improvement suggestions (accept/reject each)
- 🔄 **Live Polling** — Plugin polls every 2 seconds for new code from the web app
- 📦 **Auto-Insert** — Scripts are placed directly in ServerScriptService and selected
- 🔐 **API Key Auth** — Secure connection with your personal `nxs_studio_` key

## Installation

1. Download `NexusAI.lua` from [Releases](https://github.com/Lexon1221/nexus-ai-roblox-plugin/blob/main/NexusAI.lua) or the direct link below
2. Open **Roblox Studio**
3. Go to **Plugins → Manage Plugins → Install from File**
4. Select the downloaded `NexusAI.lua` file
5. Click the **Nexus AI** button in the toolbar
6. Enter your API Key → Save → click **Start Listening**

## Get Your API Key

Go to **Nexus AI Platform → Roblox AI → Studio Plugin** tab and generate your key.

## How Send-to-Studio Works

1. Generate code in the Nexus AI web app (Roblox AI chat)
2. Click the **"Send to Studio"** button on any AI response with code
3. The code appears in your Studio as a Script within 2 seconds

## How AI Refactoring Works

1. Switch to the **AI Refactor** tab in the plugin panel
2. Select any Script / LocalScript / ModuleScript in Explorer
3. Click **Analyze** — the AI reviews for performance, security, modern Luau, readability
4. Accept or reject each suggestion individually — changes apply instantly to your source

## Direct Download

[Download NexusAI.lua](https://raw.githubusercontent.com/Lexon1221/nexus-ai-roblox-plugin/main/NexusAI.lua)

## Version

**v3.0** — Send-to-Studio + AI Code Refactoring
