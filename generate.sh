#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
shopt -s nullglob
IFS=$'\n\t'

main() {
	local template

	cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

	for template in templates/*.tera; do
		whiskers "$template" \
			--color-overrides palette.json \
			--overrides palette.json
	done

	cp 'themes/bat/Poisonbloom Dark.tmTheme' themes/yazi/poisonbloom-dark.yazi/tmtheme.xml
	cp 'themes/bat/Poisonbloom Light.tmTheme' themes/yazi/poisonbloom-light.yazi/tmtheme.xml
}

main "$@"
