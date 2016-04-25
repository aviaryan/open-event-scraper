# thanks to https://gist.github.com/domenic/ec8b0fc8ab45f39403dd
#!/bin/sh
set -e

git config --global user.name "Travis CI"
git config --global user.email "noreply+travis@fossasia.org"

python scraper.py

# don't continue if no changes
if git diff-index --quiet HEAD; then
  exit 0
fi

git commit -m '[Auto] updated json files [ci skip]' out/*.json || echo "no changes"
git push "https://${GH_TOKEN}@github.com/OpenTechSummit/open-event-scraper" HEAD:master

git clone --depth=1 "https://${GH_TOKEN}@github.com/OpenTechSummit/2016.opentechsummit.net.git" ots-repo

node schedule/generator > ots-repo/programm/index.html

cd ots-repo

git commit -m '[Auto] updated schedule' programm/index.html || echo "no changes"
git push origin gh-pages

exit 0
