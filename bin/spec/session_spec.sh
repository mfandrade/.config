#shellcheck shell=bash
Describe 'session script'
setup() { # {{{
    export TEST_HOME="$SHELLSPEC_TMPBASE/home"
    mkdir -p "$TEST_HOME/.config/tmux"
    export CONFIG_FILE="$TEST_HOME/.config/tmux/sessionrc"

    # Create dummy project directories
    mkdir -p "$TEST_HOME/projects/project1"
    mkdir -p "$TEST_HOME/projects/project2"
}

Before 'setup'
BeforeRun 'export HOME="$TEST_HOME"'

Mock fzf
echo "${FZF_SELECT:-$TEST_HOME/projects/project1}"
End

Mock tmux
case "$1" in
has-session) [ "${TMUX_SESSION_EXISTS:-0}" = "1" ] && return 0 || return 1 ;;
display-message) echo "${CURRENT_TMUX_SESSION:-mysession}" ;;
*) return 0 ;;
esac
End

Mock realpath
[ -n "${1:-}" ] && echo "$1" || echo "$PWD"
End

Mock find
echo "$TEST_HOME/projects/project1"
echo "$TEST_HOME/projects/project2"
End
# }}}

It 'is simple'
When call echo 'ok'
The output should eq 'ok'
End

Describe 'call evaluation'
foo() { echo "foo"; }
It 'calls function'
When call foo
The output should eq 'foo'
End

It 'calls external command'
When call expr 1 + 2
The output should eq 3
End

It 'has max one call per example'
When call echo 'foo'
# When call echo 'bar' # error
The output should eq 'foo'
End

It 'does not need to call anything'
The value 123 should eq 123
End

It 'prefers function to external commands'
expr() { echo 'be called'; }
When call expr 1 + 2
The output should eq 'be called'
End

It 'needs to call external commands explicitly in this case'
expr() { echo 'not called'; }
When run command expr 1 + 2
The output should eq 3
End

End

End
# vim: fdm=marker
