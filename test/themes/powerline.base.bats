# shellcheck shell=bats
# shellcheck disable=SC2034 # Variables consumed by externally-loaded powerline functions.

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "colors"
	load "${BASH_IT?}/themes/powerline/powerline.base.bash"
}

# Stub a no-op segment so we can run __powerline_prompt_command without
# sourcing every plugin that the default segments depend on.
function __powerline_noop_prompt() { :; }
# _save-and-reload-history is called unconditionally; stub it out.
function _save-and-reload-history() { :; }

# --- __powerline_prompt_command: missing-newline handler (fixes #2372) ---

@test "powerline base: __powerline_prompt_command outputs missing-newline escape sequence to stdout" {
	POWERLINE_PROMPT=("noop")
	run __powerline_prompt_command
	assert_output --partial $'\e[7m%\e[0m\r\e[K'
}

@test "powerline base: __powerline_prompt_command missing-newline sequence is first output" {
	POWERLINE_PROMPT=("noop")
	run __powerline_prompt_command
	# Use bash pattern match to confirm the sequence appears at the very start,
	# meaning it is a direct printf rather than anything embedded in PS1 or segments.
	local prefix=$'\e[7m%\e[0m\r\e[K'
	[[ "${output}" == "${prefix}"* ]]
}
