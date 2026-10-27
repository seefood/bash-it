# shellcheck shell=bash
cite about-plugin
about-plugin 'zoxide is a smarter cd command for your shell.'
url "https://github.com/ajeetdsouza/zoxide"

if ! _binary_exists zoxide; then
	_bash-it-plugin-self-disable zoxide 'zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
	return 0
fi

# shellcheck disable=SC1090
source < <(zoxide init bash)
