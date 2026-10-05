# Nested repo containing its own git folder is not refered properly by Git

ls -a {repo_name} | grep .git
git ls-files -s {repo_name}

# If you see a .git entry and the second command shows mode 160000, that's the cause.
# To fix, if you want the files tracked in the parent repo:

# 1. Remove the gitlink from the index (keeps files on disk)
git rm --cached {repo-name}

# 2. Delete the nested repo's metadata
rm -rf {repo-name}/.git

# 3. Re-add as normal files
git add {repo-name}
git commit -m "Add {repo-name} as regular files"
git push

#Deleting the nested .git also discards that folder's own history and remote link. If you want to keep it, back it up first or use a proper submodule instead:
git submodule add <repo-url> course-secure-rest-api-oauth2-code


#To avoid this next time you clone something into the folder, you can check first with:
find . -name ".git" -not -path "./.git/*"
