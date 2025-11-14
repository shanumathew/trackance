# Deploy to Netlify - Complete Guide

## 🚀 Deployment Flow

```
1. Push code to GitHub
      ↓
2. GitHub Actions workflow triggers
      ↓
3. Flutter web build runs on GitHub
      ↓
4. Built files uploaded to Netlify
      ↓
5. Live at your-site.netlify.app
```

## 📋 Prerequisites

1. **GitHub Account** - Your code repo
2. **Netlify Account** - Free tier at https://netlify.com
3. **Already done**:
   - GitHub Actions workflow (`.github/workflows/deploy.yml`)
   - Netlify config (`netlify.toml`)

## 🔧 Setup Steps (5 minutes)

### Step 1: Connect Netlify to GitHub

1. Go to https://netlify.com
2. Sign up with GitHub
3. Click **"Add new site"** → **"Import an existing project"**
4. Select your GitHub repo `trackance`
5. Netlify auto-detects settings from `netlify.toml`
6. Click **"Deploy site"**

### Step 2: Get Netlify Credentials

1. Go to **Site settings** → **Build & deploy** → **Environment**
2. Look for **Site ID** (copy it)
3. Go to **User settings** → **Applications** → **Personal access tokens**
4. Create new token named `GitHub Deploy`
5. Copy the token (save securely)

### Step 3: Add GitHub Secrets

1. Go to your GitHub repo
2. Settings → Secrets and variables → **Actions**
3. Click **"New repository secret"**

Add these 2 secrets:

**Secret 1:**
- Name: `NETLIFY_SITE_ID`
- Value: (paste Site ID from Step 2)

**Secret 2:**
- Name: `NETLIFY_AUTH_TOKEN`
- Value: (paste personal token from Step 2)

### Step 4: Push Code to Trigger Deploy

```bash
git add .
git commit -m "Add Netlify deployment"
git push origin master
```

Watch the deploy:
1. Go to GitHub repo → **Actions** tab
2. See the workflow running
3. After ~3-4 minutes, check Netlify site for live URL

## ✅ Verify It Works

Your site should now be live at:
- `https://your-site.netlify.app`
- Or custom domain if configured

### Check Build Logs

**On GitHub:**
- Repo → Actions → Latest workflow
- Click workflow → Build & Deploy job
- See all steps executed

**On Netlify:**
- Site overview → Deploys tab
- Click latest deploy
- See "Build log" with all details

## 🔄 How It Works (After Setup)

Every time you push to master:

1. **GitHub Actions** builds the Flutter web app
2. Compiles to `build/web/` directory
3. Uploads to Netlify via CLI
4. Netlify serves the static files
5. Available at your URL instantly

## 📱 Testing on Live URL

1. Open your Netlify URL
2. Test all features:
   - Dashboard loads
   - View transactions
   - Add new payment (test mode)
   - Select category
   - Save & refresh page
3. Check network tab (should see no errors)

## 🚨 Troubleshooting

### Build Fails - Check GitHub Actions Log

**Issue**: "Command not found: flutter"
- **Solution**: This shouldn't happen - we're using the Flutter action
- **Fix**: Delete workflow and recreate from template

**Issue**: "Razorpay not working on web"
- **Solution**: This is expected in test mode on web
- **Fix**: Use the "QR" or "Cash" payment methods for testing

**Issue**: "Assets not loading"
- **Solution**: Flutter web assets path issue
- **Fix**: Rebuild locally first: `flutter build web --release`

**Issue**: "Deployment stuck in progress"
- **Solution**: Netlify still building
- **Fix**: Wait 10 minutes, then manually trigger redeploy

### Netlify Deploy Fails

Check these:

1. **Site ID correct?**
   - Netlify Site settings → General → Site ID

2. **Token valid?**
   - Go to Netlify → User settings → Applications
   - Recreate new token if unsure

3. **build/web folder exists?**
   - GitHub Actions should create it
   - Check "Build & Deploy" step in Actions log

4. **Secrets added correctly?**
   - Repo → Settings → Secrets → Verify both secrets exist
   - No extra spaces or quotes

## 📊 Environment Variables (If Needed)

If you need env variables in the Flutter app, add to GitHub Actions:

File: `.github/workflows/deploy.yml`

```yaml
- name: Build Flutter Web
  run: flutter build web --release
  env:
    RAZORPAY_KEY: ${{ secrets.RAZORPAY_KEY }}
```

Then access in Dart:
```dart
const String razo payKey = String.fromEnvironment('RAZORPAY_KEY');
```

## 🔐 Security Notes

- Never commit secrets (API keys) to GitHub
- Always use GitHub Secrets
- Netlify tokens are sensitive - regenerate if leaked
- Personal token can access all your Netlify sites

## 📈 Analytics & Monitoring

### Netlify Dashboard

- Go to Netlify site dashboard
- See:
  - Deploys history
  - Build times
  - Bandwidth usage
  - Analytics (if enabled)

### GitHub Actions

- Repo → Actions → workflow
- See:
  - Build duration
  - Which jobs passed/failed
  - Commit that triggered it

## 🎨 Custom Domain (Optional)

1. Go to Netlify site → **Domain settings**
2. Click **"Add custom domain"**
3. Add your domain (e.g., `trackance.yourdomain.com`)
4. Follow DNS setup instructions
5. Wait 24-48 hours for propagation

## 🔄 Redeploying Manually

If GitHub Actions fails or you want to redeploy:

**Option 1: Push to GitHub**
```bash
git commit --allow-empty -m "Trigger redeploy"
git push origin master
```

**Option 2: Netlify Dashboard**
1. Go to Deploys tab
2. Click latest deploy
3. Click "Trigger deploy" → "Deploy site"

**Option 3: Netlify CLI**
```bash
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=build/web
```

## 📝 Monitoring Deployments

Create a `.github/workflows/deploy-status.yml` to notify on deploy:

```yaml
name: Deploy Status
on:
  deployment_status:
jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify on success
        if: github.event.deployment_status.state == 'success'
        run: echo "✅ Deployed successfully!"
```

## ✨ What's Automatic Now

✅ Build triggers on push to master
✅ Flutter web app compiled
✅ Code generation runs (build_runner)
✅ Files uploaded to Netlify
✅ Live instantly
✅ Old deploys archived

## 🎯 Next Steps

1. Make a small change to verify:
   ```bash
   echo "# Deployed!" >> README.md
   git add README.md
   git commit -m "Test deploy"
   git push origin master
   ```

2. Watch the action run in GitHub Actions tab

3. Check your Netlify URL in 3-4 minutes

4. Share the live URL! 🎉

---

**Your app is now live on the internet!**

Every time you push to `master` branch:
- Automatic build ✓
- Automatic deploy ✓
- Zero manual steps ✓
