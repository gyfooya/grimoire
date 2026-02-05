# GiXploration
# Gyfooya January 2026

# How to find github email in repository

# Inside a repository
```
git log --all --format="%ae" | sort | uniq
git grep -i "@"
cat .git/config
cat .mailmap 2>/dev/null
git log --reverse
```
