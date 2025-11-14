# Flutter Web Deployment Setup Checklist

## For New Flutter Web Projects

Complete this checklist to set up automated deployment for any new Flutter web project.

### Step 1: Initial Project Setup

- [ ] Create new Flutter project:
  ```bash
  flutter create my_project
  cd my_project
  ```

- [ ] Install dependencies:
  ```bash
  flutter pub get
  ```

- [ ] Verify local build works:
  ```bash
  flutter build web --release
  ```

### Step 2: GitHub Setup

- [ ] Create GitHub repository:
  ```bash
  git init
  git add .
  git commit -m "Initial commit"
  git remote add origin https://github.com/USERNAME/my_project.git
  git branch -M master
  git push -u origin master
  ```

- [ ] Copy GitHub Actions workflow:
  ```bash
  mkdir -p .github/workflows
  cp TEMPLATES_verify-build.yml .github/workflows/verify-build.yml
  ```

- [ ] Update Flutter version in workflow if needed:
  - Open `.github/workflows/verify-build.yml`
  - Change `flutter-version: '3.38.1'` to your version

- [ ] Copy Netlify configuration:
  ```bash
  cp TEMPLATES_netlify.toml netlify.toml
  ```

- [ ] Commit workflow and config:
  ```bash
  git add .github/ netlify.toml
  git commit -m "Add GitHub Actions workflow and Netlify config"
  git push origin master
  ```

### Step 3: Netlify Setup

- [ ] Go to https://app.netlify.com

- [ ] Click **"Add new site"** → **"Import an existing project"**

- [ ] Select **GitHub** and authorize

- [ ] Choose your repository

- [ ] Configure build settings:
  - **Build command:** (leave empty - we're using pre-built files)
  - **Publish directory:** `build/web`
  - Click **"Deploy site"**

- [ ] Wait for first deploy to complete

- [ ] Verify deployment:
  - Go to Netlify dashboard
  - Check **Deploys** tab
  - Click the URL to visit your live app

### Step 4: First Deployment

- [ ] Build Flutter web app locally:
  ```bash
  flutter build web --release
  ```

- [ ] Commit and push:
  ```bash
  git add build/web
  git commit -m "Add pre-built web files"
  git push origin master
  ```

- [ ] Netlify automatically deploys!
  - Check Netlify dashboard for deploy status
  - Visit your Netlify URL to verify

### Step 5: Git Configuration (Optional but Recommended)

- [ ] Update `.gitignore` to keep `build/web`:
  ```bash
  # Modify .gitignore to:
  /build/*
  !/build/web
  ```

- [ ] Commit change:
  ```bash
  git add .gitignore
  git commit -m "Update .gitignore: keep build/web for deployment"
  git push origin master
  ```

### Step 6: Daily Workflow

For each code change:

```bash
# 1. Make your code changes
# 2. Build locally
flutter build web --release

# 3. Commit and push
git add .
git commit -m "Your feature description"
git push origin master

# 4. Netlify auto-deploys!
# Check Netlify dashboard to confirm
```

### Step 7: Troubleshooting

**Build fails locally?**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release
```

**GitHub Actions shows red X?**
- Go to **Actions** tab in your repo
- Click the failed workflow
- Scroll to see the error
- Common: Flutter version mismatch → Update workflow

**Netlify shows old code?**
- Go to Netlify dashboard
- Click **Deploys**
- Click **"Clear cache and redeploy"**

**build/web folder too large?**
- Alternative: Use GitHub Actions to build (Option B in DEPLOYMENT_GUIDE.md)
- This requires additional setup but keeps repo smaller

---

## File Reference

| Source Template | Target File | Purpose |
|---|---|---|
| `TEMPLATES_verify-build.yml` | `.github/workflows/verify-build.yml` | CI/CD build verification |
| `TEMPLATES_netlify.toml` | `netlify.toml` | Netlify deployment config |

---

## Quick Commands Reference

```bash
# Build locally
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release

# Git workflow
git status
git add .
git commit -m "message"
git push origin master

# Check builds
# GitHub: Go to your repo → Actions tab
# Netlify: Go to https://app.netlify.com → Select site → Deploys tab

# Force rebuild on Netlify
# Netlify dashboard → Deploys → Clear cache and redeploy
```

---

## Support Resources

- Flutter Web: https://flutter.dev/multi-platform/web
- GitHub Actions: https://docs.github.com/en/actions
- Netlify: https://docs.netlify.com/
- Troubleshooting: See DEPLOYMENT_GUIDE.md

