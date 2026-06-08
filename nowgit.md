# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | RepTap |
| **Git URL** | git@github.com:asunnyboy861/RepTap.git |
| **Repo URL** | https://github.com/asunnyboy861/RepTap |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/RepTap/ | ✅ Active |
| Support | https://asunnyboy861.github.io/RepTap/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/RepTap/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/RepTap/terms.html | ✅ Active |

## Repository Structure

```
RepTap/
├── RepTap/                        # iOS App Source Code
│   ├── RepTap.xcodeproj/          # Xcode Project
│   ├── RepTap/                    # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Home/
│   │   │   ├── Workout/
│   │   │   ├── History/
│   │   │   ├── Progress/
│   │   │   ├── Routines/
│   │   │   ├── Settings/
│   │   │   └── Onboarding/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   ├── Services/
│   │   ├── Extensions/
│   │   └── Resources/
│   └── ...
├── docs/                          # Policy Pages (GitHub Pages source)
│   ├── index.html
│   ├── support.html
│   ├── privacy.html
│   └── terms.html
├── .github/workflows/
│   └── deploy.yml
├── us.md
├── keytext.md
├── capabilities.md
├── icon.md
├── price.md
└── nowgit.md
```
