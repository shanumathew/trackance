# Deployment Guide: GitHub + Netlify for Flutter Web Apps

This guide explains how to set up automated deployment for Flutter web apps using GitHub and Netlify.

## Overview

The workflow works like this:
1. You push code to GitHub
2. GitHub Actions builds your Flutter web app
3. Built files (`build/web`) are committed to GitHub
4. Netlify pulls from GitHub and serves static files
5. Your app is live!

---

## Part 1: Initial Setup (One-time)

### Step 1: Create GitHub Repository

```bash
# Initialize local repo
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub and push
git remote add origin https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
git branch -M master
git push -u origin master
```

### Step 2: Create Netlify Site from GitHub

1. Go to https://app.netlify.com
2. Click **"Add new site"** → **"Import an existing project"**
3. Select **GitHub** as provider
4. Authorize GitHub access
5. Select your repository
6. **Build settings:**
   - Build command: Leave blank (we'll commit pre-built files)
   - Publish directory: `build/web`
7. Click **"Deploy site"**
8. Note your Netlify URL (e.g., `https://trackance.netlify.app`)

### Step 3: Set Up GitHub Secrets (Optional)

For pushing build artifacts back to GitHub (advanced), add:
- Go to GitHub repo → Settings → Secrets and variables → Actions
- Add secrets if needed for CI/CD automation

---

## Part 2: File Setup

### File 1: `.github/workflows/verify-build.yml`

Create this file to verify builds:

```yaml
name: Verify Flutter Web Build

on:
  push:
    branches: [master, main, develop]
  pull_request:
    branches: [master, main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.1'
          channel: 'stable'

      - name: Get dependencies
        run: flutter pub get

      - name: Run code generation
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build Flutter Web
        run: flutter build web --release --no-tree-shake-icons

      - name: ✅ Build successful
        run: echo "Flutter web build completed successfully!"
```

**Key points:**
- Update Flutter version if needed (match your `pubspec.yaml` SDK constraint)
- `--delete-conflicting-outputs` prevents build_runner conflicts
- `--no-tree-shake-icons` keeps all icons available

### File 2: `netlify.toml`

Configuration for Netlify deployment:

```toml
[build]
  command = "echo 'Static files only - pre-built Flutter web app'"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "SAMEORIGIN"
    X-Content-Type-Options = "nosniff"
    X-XSS-Protection = "1; mode=block"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"

[[headers]]
  for = "/index.html"
  [headers.values]
    Cache-Control = "no-cache, no-store, must-revalidate"

[[headers]]
  for = "/assets/**"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/**/*.{js,css}"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

**What it does:**
- Skips Netlify's build (uses pre-built files)
- Routes all URLs to `index.html` (for single-page app routing)
- Sets cache headers (SPA files never change, assets cached forever)
- Sets security headers

### File 3: `.gitignore` (Modified)

**For projects that commit `build/web`:**

```gitignore
# Standard Flutter ignores
.dart_tool/
.flutter-plugins-dependencies
.pub-cache/
.pub/

# Keep build/web but ignore other build artifacts
/build/*
!/build/web

# Other ignores
*.iml
.idea/
.vscode/
.DS_Store
/coverage/
```

**For projects that DON'T commit `build/web`:**

Keep the default `.gitignore` that ignores `/build/` entirely. Instead, use GitHub Actions to build and Netlify to pull from `main` branch after build.

---

## Part 3: Deployment Workflow (Your Daily Flow)

### Option A: Commit Pre-built Files (Recommended for Web)

**Workflow:**
```bash
# 1. Make code changes
# 2. Build locally
flutter build web --release

# 3. Commit everything
git add .
git commit -m "Update feature XYZ"
git push origin master

# 4. Netlify automatically deploys from build/web
```

**Pros:**
- ✅ Fast Netlify deploys (already built)
- ✅ No secrets needed
- ✅ No CI/CD failures to debug

**Cons:**
- ⚠️ Larger git history
- ⚠️ Must remember to build before push

---

### Option B: Auto-build on GitHub Actions (Advanced)

**Workflow:**
```bash
# 1. Make code changes
# 2. Just push (no local build needed)
git add .
git commit -m "Update feature XYZ"
git push origin master

# 3. GitHub Actions automatically:
#    - Builds Flutter web
#    - Commits build/ to GitHub
#    - Netlify pulls and deploys
```

For this, use enhanced workflow and scripts (see `Option B: Advanced Setup` section).

---

## Part 4: Maintenance

### Update Flutter Version

When updating Flutter, update everywhere:

1. **Local machine:**
   ```bash
   flutter upgrade
   ```

2. **GitHub Actions** (`.github/workflows/verify-build.yml`):
   ```yaml
   flutter-version: '3.40.0'  # Update this
   ```

3. **Commit and push:**
   ```bash
   git add .
   git commit -m "Update Flutter to 3.40.0"
   git push origin master
   ```

### Force Rebuild on Netlify

If Netlify cache is stale:
1. Go to Netlify dashboard
2. Click **"Deploys"**
3. Click **"Clear cache and redeploy"**

### Monitor Builds

**GitHub Actions:**
- Go to your repo → **Actions** tab
- See all build history and logs

**Netlify:**
- Go to https://app.netlify.com
- Click your site → **Deploys**
- See all deployment history

---

## Part 5: Troubleshooting

### Problem: "build/web not found" on Netlify

**Solution:** You need to either:
1. Build and commit `build/web` locally, OR
2. Set up GitHub Actions to auto-build

### Problem: Old code is still live

**Solution:**
1. Make sure you pushed to `master` branch
2. Check Netlify **Deploys** tab to see when it deployed
3. Hard refresh browser: `Ctrl+Shift+Delete` (or clear cache)
4. If stuck, use Netlify's "Clear cache and redeploy"

### Problem: GitHub Actions build fails

**Solutions:**
1. Check the error logs in **Actions** tab
2. Common issues:
   - Flutter version mismatch → Update in workflow
   - Missing dependencies → Run `flutter pub get` locally first
   - build_runner conflicts → Add `--delete-conflicting-outputs`

### Problem: Large file size after first push

**Why:** `build/web` contains compiled code + assets (5-50 MB typically)

**Solutions:**
1. Use `.gitignore` to exclude and auto-build instead (Option B)
2. Use GitHub LFS for large files (advanced)
3. Accept the larger repo (usually fine)

---

## Part 6: Best Practices

### Do's ✅

- ✅ Commit `pubspec.lock` (ensures reproducible builds)
- ✅ Commit `.github/workflows/` (CI/CD should be in source)
- ✅ Commit `netlify.toml` (deployment config is code)
- ✅ Use consistent Flutter version everywhere
- ✅ Test locally before pushing: `flutter build web --release`

### Don'ts ❌

- ❌ Don't commit `.dart_tool/` directory
- ❌ Don't hardcode secrets in code (use GitHub Secrets)
- ❌ Don't forget to push after building locally
- ❌ Don't delete `build/web` before committing (if using Option A)

---

## Part 7: For New Projects

Use this checklist for new Flutter web projects:

```
☐ Create new Flutter project: flutter create my_app
☐ Create GitHub repo and push initial code
☐ Copy .github/workflows/verify-build.yml
☐ Copy netlify.toml (update build directory if needed)
☐ Update .gitignore (if committing build/web)
☐ Build locally: flutter build web --release
☐ Commit and push: git add . && git commit -m "Initial build"
☐ Create Netlify site and connect GitHub repo
☐ Verify deployment: Check Netlify dashboard
☐ Test live URL: Should see your app running
```

---

## Appendix: Quick Reference

### Common Commands

```bash
# Local setup
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release

# Git workflow
git add .
git commit -m "Your message"
git push origin master

# Check status
git status
git log --oneline -5
```

### Files Checklist

| File | Purpose | Commit to Git? |
|------|---------|---|
| `.github/workflows/verify-build.yml` | CI/CD verification | ✅ Yes |
| `netlify.toml` | Netlify deployment config | ✅ Yes |
| `.gitignore` | What to exclude | ✅ Yes |
| `build/web/` | Pre-built web app | ✅ Yes (Option A) or ❌ No (Option B) |
| `.dart_tool/` | Build cache | ❌ No |
| `.pub-cache/` | Package cache | ❌ No |

---

## Support & Resources

- **Flutter Web Docs:** https://flutter.dev/multi-platform/web
- **GitHub Actions Docs:** https://docs.github.com/en/actions
- **Netlify Docs:** https://docs.netlify.com/
- **Netlify Deploy Info:** https://docs.netlify.com/site-deploys/overview/

