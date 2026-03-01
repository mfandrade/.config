Describe 'session script'
  setup() {
    export TEST_HOME="$SHELLSPEC_TMPBASE/home"
    mkdir -p "$TEST_HOME/.config/tmux"
    export CONFIG_FILE="$TEST_HOME/.config/tmux/sessionrc"
    
    # Create dummy project directories
    mkdir -p "$TEST_HOME/projects/project1"
    mkdir -p "$TEST_HOME/projects/project2"
  }
  
  # Run setup before each example to define TEST_HOME and CONFIG_FILE
  Before 'setup'
  # Set HOME for the script execution
  BeforeRun 'export HOME="$TEST_HOME"'

  # Mock required tools
  # Mock command 
  #   [ "$1" = "-v" ] || return 0
  #
  #   if [ "$2" = "$TOOL_MISSING" ]; then
  #     return 1
  #   fi
  #   return 0
  # End

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

  # It 'fails if fzf is missing'
  #   export TOOL_MISSING="fzf"
  #   When run script ./session
  #   The status should be failure
  #   The error should include "Required tool not installed: 'fzf'"
  # End

  Context 'selection logic'
    It 'uses the directory provided as an argument'
      When run script ./session "$TEST_HOME/projects/project1"
      The status should be success
    End

    It 'errors if the provided directory or alias does not exist'
      When run script ./session "nonexistent"
      The error should include "Informed dir or alias does not exist"
      The status should be failure
    End

    It 'uses aliases from sessionrc'
      cat <<EOF > "$CONFIG_FILE"
[DEFAULT]
[work.myproj]
path = $TEST_HOME/projects/project2
aliases = p2,work
EOF
      When run script ./session "p2"
      The status should be success
    End

    It 'falls back to fzf when no argument or alias matches'
      cat <<EOF > "$CONFIG_FILE"
[DEFAULT]
project_roots = $TEST_HOME/projects
EOF
      export FZF_SELECT="$TEST_HOME/projects/project2"
      When run script ./session
      The status should be success
    End
  End

  Context 'tmux interaction'
    It 'attaches if the session already exists'
      export TMUX_SESSION_EXISTS=1
      When run script ./session "$TEST_HOME/projects/project1"
      The status should be success
    End

    It 'switches client if already inside tmux'
      export TMUX="/tmp/tmux-1000/default,1234,0"
      export CURRENT_TMUX_SESSION="othersession"
      When run script ./session "$TEST_HOME/projects/project1"
      The status should be success
    End
  End
End



