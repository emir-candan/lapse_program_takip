# Vercel Deployment Architecture & Guide

This document explains how the **Flutter Web** deployment on **Vercel** is architected, why specific choices were made, and how to maintain it.

## 🎯 The Goal
To host a Flutter Web application (which is a Single Page Application - SPA) on Vercel without:
1.  **404 Errors** on refresh.
2.  **"Loading..." loops** due to incorrect caching or routing.
3.  **Empty deployments** caused by mismatched output directories.

## 🏗 Architecture Overview

We do NOT use Vercel's automatic GitHub integration for building. Instead, we use **GitHub Actions** as the "Build Server" and simply push the finished static files to Vercel via their Command Line Interface (CLI).

### Why this approach?
Standard Vercel deployment tries to `npm install` and build. Flutter requires a specific environment (Dart SDK, Flutter SDK). While Vercel supports custom builds, the path mapping for Flutter Web artifacts (`build/web`) often breaks or requires complex overrides.

**Our "Bulletproof" Solution:**
1.  **GitHub Actions**: Installs Flutter, builds the web app (`flutter build web --release`).
2.  **Config Injection**: Copies our custom `vercel.json` into the build output.
3.  **Direct Upload**: Uses `vercel deploy --prod` command to upload **only** the `build/web` folder. This guarantees that what you see in that folder is exactly what gets hosted.

## 🛠 Configuration Files

### 1. `vercel.json`
Located in project root, but copied to `build/web` during deployment.
It handles the **Routing Logic**.

```json
{
    "routes": [
        { "handle": "filesystem" },
        { "src": "/[^.]+", "dest": "/index.html" }
    ]
}
```

*   `"handle": "filesystem"`: Crucial! It tells Vercel: "If a file actually exists (like `logo.png` or `main.dart.js`), serve it immediately."
*   `"src": "/[^.]+"`: Regex matching any route that *doesn't* have a dot (extension). E.g., `/login`, `/dashboard`.
*   `"dest": "/index.html"`: Redirects those routes to `index.html` so Flutter can handle them internally.

### 2. `.github/workflows/flutter-web.yml`
Automates the process.

*   **Trigger**: `workflow_dispatch` (Manual button click) or `push` to main.
*   **Key Step**:
    ```yaml
    - name: Deploy to Vercel (Manual CLI)
      run: |
        npm install --global vercel
        vercel deploy --prod --token=${{ secrets.VERCEL_TOKEN }} build/web/
    ```
    This command explicitly tells Vercel: *"Ignore your settings, take this `build/web/` folder and publish it to production."*

## 🚀 How to Deploy

1.  **Commit & Push**: Ensure your changes are on GitHub (`main` branch).
2.  **Go to GitHub Actions**:
    *   Click **Actions** tab.
    *   Select **Build & Deploy**.
    *   Click **Run Workflow**.
3.  **Wait**: The pipeline usually takes 2-3 minutes.
4.  **Verify**: Visit your Vercel URL. If you see old content, try an Incognito tab (Service Workers cache heavily).

## ⚠️ Troubleshooting

*   **White Screen / Loading Loop**: Usually means `vercel.json` wasn't copied or `handle: filesystem` is missing.
*   **404 on Assets**: Check `AppAssets` paths. They must not start with `/assets/` if your simple local path is `assets/`.
*   **Deployment Failed (Auth)**: Check GitHub Secrets (`VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`).
