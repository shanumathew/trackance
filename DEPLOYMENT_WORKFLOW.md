# GitHub + Netlify Deployment Workflow for Flutter Web Apps

A complete, reusable setup for deploying Flutter web applications to Netlify with GitHub integration.

## 📋 Quick Start for New Projects

```bash
# 1. Create project
flutter create my_app
cd my_app

# 2. Copy templates
cp /path/to/trackance/.github/workflows/verify-build.yml .github/workflows/
cp /path/to/trackance/netlify.toml .

# 3. Setup Git & GitHub
git init && git add . && git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/my_app.git
git push -u origin master

# 4. Build & commit web files
flutter build web --release
git add build/web
git commit -m "Add pre-built web files"
git push

# 5. Connect Netlify
# → Go to https://app.netlify.com
# → "Add new site" → Select your GitHub repo
# → Done! It auto-deploys on every push
```

## 📁 Files in This Project

| File | Purpose |
|------|---------|
| `.github/workflows/verify-build.yml` | GitHub Actions workflow for build verification |
| `netlify.toml` | Netlify deployment configuration |
| `.gitignore` | Git ignore rules (includes `build/web`) |
| `DEPLOYMENT_GUIDE.md` | Complete deployment walkthrough |
| `SETUP_CHECKLIST.md` | Step-by-step new project checklist |
| `TEMPLATES_netlify.toml` | Reusable Netlify config template |
| `TEMPLATES_verify-build.yml` | Reusable GitHub Actions template |

## 🚀 How It Works

```
┌─────────────────┐
│   You push      │
│   git push      │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  GitHub Actions runs workflow   │
│  • flutter pub get              │
│  • build_runner                 │
│  • flutter build web            │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Netlify pulls from GitHub      │
│  • Finds build/web folder       │
│  • Deploys static files         │
│  • Your app goes live!          │
└────────┬────────────────────────┘
         │
         ▼
    🌍 Live on the web!
    https://your-app.netlify.app
```

## 📖 Documentation

### For New Projects
Start here: **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)**
- 7-step checklist to get a new project live
- Copy-paste commands included
- Troubleshooting section

### For Deep Dive
Full guide: **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)**
- Complete workflow explanation
- Two deployment options (committed files vs auto-build)
- Maintenance and troubleshooting
- Best practices and do's/don'ts

### For Templates
Reusable files:
- **`TEMPLATES_verify-build.yml`** → Copy to `.github/workflows/verify-build.yml`
- **`TEMPLATES_netlify.toml`** → Copy to `netlify.toml`

## ⚙️ Key Components

### 1. GitHub Actions Workflow

**Location:** `.github/workflows/verify-build.yml`

What it does:
- Runs on every push
- Installs Flutter
- Gets dependencies
- Generates code (build_runner)
- Builds Flutter web app
- Reports success/failure

```yaml
# Verify build works before pushing to Netlify
name: Verify Flutter Web Build
on: [push, pull_request]
```

### 2. Netlify Configuration

**Location:** `netlify.toml`

What it does:
- Sets publish directory to `build/web`
- Configures SPA routing (all URLs → index.html)
- Sets cache headers (static files cached forever)
- Adds security headers
- Redirects old URLs if needed

```toml
[build]
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### 3. Git Configuration

**Location:** `.gitignore`

Modified to **keep** `build/web` for deployment:

```gitignore
/build/*
!/build/web
```

This way:
- ✅ Pre-built files are in git
- ✅ Netlify deploys faster
- ✅ No build failures
- ❌ Repo is larger (~5-50 MB for `build/web`)

## 🔄 Daily Workflow

After this setup, your daily workflow is simple:

```bash
# 1. Make code changes
# 2. Build locally
flutter build web --release

# 3. Commit and push
git add .
git commit -m "Feature: Add login screen"
git push origin master

# 4. Check deployment (optional)
# → Netlify dashboard shows "Deploy in progress"
# → After 30 seconds, your app is live!
```

## 🛠️ Customization

### Change Flutter Version

Update in three places:

1. **Local:** 
   ```bash
   flutter upgrade  # Updates to latest
   ```

2. **GitHub Actions** (`.github/workflows/verify-build.yml`):
   ```yaml
   flutter-version: '3.40.0'  # Change this
   ```

3. **Commit and push** to trigger new builds

### Change Build Command

Edit `.github/workflows/verify-build.yml`:

```yaml
- name: Build Flutter Web
  run: flutter build web --release --web-renderer=html  # Add flags here
```

### Add Custom Domain

In Netlify dashboard:
1. Click your site → Settings → Domain management
2. Add custom domain
3. Update DNS records (Netlify shows instructions)

## 📊 Monitoring & Troubleshooting

### Check GitHub Actions Build

1. Go to your repo → **Actions** tab
2. See all past builds
3. Click a build to see detailed logs
4. Look for errors in each step

### Check Netlify Deploy

1. Go to https://app.netlify.com
2. Click your site
3. Click **Deploys** tab
4. See deploy history and status

### Common Issues

| Problem | Solution |
|---------|----------|
| Netlify shows old code | Hard refresh: `Ctrl+Shift+Delete` or clear cache |
| Build fails | Check GitHub Actions logs |
| Large repo | Use GitHub Actions auto-build (Option B in guide) |
| Slow Netlify deploy | Make sure `build/web` is committed and up-to-date |

## 📚 Additional Resources

- **Flutter Web Docs:** https://flutter.dev/multi-platform/web
- **GitHub Actions:** https://docs.github.com/en/actions
- **Netlify Docs:** https://docs.netlify.com/
- **Netlify CLI:** https://docs.netlify.com/cli/get-started/

## 🎯 What You Get

✅ **Automated builds** - GitHub Actions verifies every push works  
✅ **Instant deploys** - Netlify serves from `build/web`  
✅ **Zero downtime** - New code replaces old code instantly  
✅ **Caching** - Static assets cached forever  
✅ **Security headers** - HTTPS + security best practices  
✅ **SPA routing** - All URLs work with client-side routing  

## 📝 Next Steps

1. **For existing projects:** Copy `netlify.toml` and `.github/workflows/verify-build.yml`
2. **For new projects:** Follow `SETUP_CHECKLIST.md`
3. **For deep understanding:** Read `DEPLOYMENT_GUIDE.md`
4. **For troubleshooting:** Check section above or Netlify/GitHub docs

## 💡 Tips

- Always build locally before pushing: `flutter build web --release`
- Commit `pubspec.lock` to ensure reproducible builds
- Use meaningful commit messages
- Check GitHub Actions after each push
- Monitor Netlify deploys in early stages

---

**Questions?** See `DEPLOYMENT_GUIDE.md` for comprehensive answers or check official docs linked above.

**Ready to deploy?** Start with `SETUP_CHECKLIST.md` for your next project! 🚀
