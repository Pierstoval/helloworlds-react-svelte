#!/usr/bin/env bash

info() {
    printf " %s" "$1"
}
ok() {
    printf " \033[32m%s\033[0m\n" "Done!"
}

info "Cleaning up..."
rm -rf \
    react/node_modules \
    react/build \
    \
    react-next/node_modules \
    react-next/.next \
    react-next/out \
    \
    svelte/node_modules \
    svelte/dist \
    \
    svelte-kit/node_modules \
    svelte-kit/.svelte-kit \
    svelte-kit/build
ok

info "Making sure processtime is installed..."
cargo install processtime >/dev/null 2>&1
ok

info "Installing node dependencies..."
    svelte_yarn=$(processtime --format=ms -- yarn --cwd=svelte 2>&1 | tail -1)
svelte_kit_yarn=$(processtime --format=ms -- yarn --cwd=svelte-kit 2>&1 | tail -1)
     react_yarn=$(processtime --format=ms -- yarn --cwd=react 2>&1 | tail -1)
react_next_yarn=$(processtime --format=ms -- yarn --cwd=react-next 2>&1 | tail -1)
ok

info "Building projects as static websites..."
svelte_build=$(processtime --format=ms -- yarn --cwd=svelte build 2>&1 | tail -1)
svelte_kit_build=$(processtime --format=ms -- yarn --cwd=svelte-kit build 2>&1 | tail -1)
react_build=$(processtime --format=ms -- yarn --cwd=react build 2>&1 | tail -1)
react_next_build=$(processtime --format=ms -- yarn --cwd=react-next build 2>&1 | tail -1)
ok

info "Gathering complete build size..."
svelte_build_size=$(du -s svelte/dist/ | awk '{print $1}')
svelte_kit_build_size=$(du -s svelte-kit/build/ | awk '{print $1}')
react_build_size=$(du -s react/build/ | awk '{print $1}')
react_next_build_size=$(du -s react-next/out/ | awk '{print $1}')
ok

info "Results for node dependencies:"
printf "\n"
echo " ➡ svelte yarn install:       ${svelte_yarn} ms"
echo " ➡ svelte_kit yarn install:   ${svelte_kit_yarn} ms"
echo " ➡ react yarn install:        ${react_yarn} ms"
echo " ➡ react_next yarn install:   ${react_next_yarn} ms"

info "Results for build time:"
printf "\n"
echo " ➡ svelte build time:       ${svelte_build} ms"
echo " ➡ svelte-kit build time:   ${svelte_kit_build} ms"
echo " ➡ react build time:        ${react_build} ms"
echo " ➡ react-next build time:   ${react_next_build} ms"

info "Results for build size:"
printf "\n"
echo " ➡ svelte build size:       ${svelte_build_size} KB"
echo " ➡ svelte_kit build size:   ${svelte_kit_build_size} KB"
echo " ➡ react build size:        ${react_build_size} KB"
echo " ➡ react_next build size:   ${react_next_build_size} KB"

echo "${svelte_yarn};${svelte_kit_yarn};${react_yarn};${react_next_yarn};${svelte_build};${svelte_kit_build};${react_build};${react_next_build};${svelte_build_size};${svelte_kit_build_size};${react_build_size};${react_next_build_size}" >> results.csv
