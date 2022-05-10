#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -e -u -x
curr_branch=`git branch --show-current`
git fetch

# Making a git tag for Go modules
last_tag_revision=$(git rev-list --tags --max-count=1)
tag=$(git describe --tags "$last_tag_revision")
next_tag=$tag

if [[ "$tag" =~ v([0-9]+).([0-9]+).([0-9]+)$ ]] || [[ "$tag" =~ ([0-9]+).([0-9]+).([0-9]+)$ ]]
then
  major=${BASH_REMATCH[1]}
  minor=${BASH_REMATCH[2]}
  patch=${BASH_REMATCH[3]}
  next_patch=$((patch + 1))
  next_tag="$major.$minor.$next_patch"
fi

echo "Last tag: $tag, new tag: $next_tag"
new_tag="`date +%Y-%m-%d`-$next_tag-`git branch --show-current`"
new_tag=$next_tag
echo "new_tag: $next_tag"

FILES=($DIR/frontend-apps)
for f in "${FILES[@]}"
do
  echo "updating $f file"
  sed -i.bak "s/^version: .*/version: ${new_tag}/" $f
  git add $f
  rm ${f}.bak
done
git commit -m "updated tag to $next_tag"
git push origin $curr_branch

git tag "$next_tag"
git push origin "$next_tag"