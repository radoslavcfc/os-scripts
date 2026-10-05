# Nested repo containing its own git folder is not refered properly by Git

ls -a {repo_name} | grep .git
git ls-files -s {repo_name}

# If you see a .git entry and the second command shows mode 160000, that's the cause.
# To fix, if you want the files tracked in the parent repo:
