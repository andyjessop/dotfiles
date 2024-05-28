
git clone git@github.com:andyjessop/clerk.git ~/dev/clerk
cd ~/dev/clerk
bun install
bun compile:clerk
cp apps/clerk/dist/clerk /usr/local/bin
cd -