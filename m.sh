# A collection of bash functions that makes creating, starting and stopping tmux sessions slightly easier
# All functions are a word prefixed with the letter 'm'

# List all open tmux sessions
# Usage:
# $ mls
function mls {
    # check if there are no open sessions
    OPEN_SESSIONS=$(tmux ls 2>&1)
    echo $OPEN_SESSIONS | grep -q "no server running"
    if [ $? -ne 0 ]; then
        SESSIONS=$(tmux ls | awk '{print $1}')
        for SESSION in $SESSIONS; do
            NAME=$(echo $SESSION | sed s'/.$//')
            echo $NAME
        done
    fi
}

# Start a new tmux session and attach to it
# Usage
# $ mstart <session-name>
function mstart {
    # if no args given, show usage
    if [[ $# -eq 0 ]]; then
        echo "Usage: mstart <session-name>"
    # otherwise, create session and attach to it
    else
        tmux -2 new-session -d -s $1
        # attach to it
        tmux a -t $1
    fi
}

# Create a new tmux session without attaching to it
# Usage
# $ mcreate <session-name>
function mcreate {
    # if no args given, show usage
    if [[ $# -eq 0 ]]; then
        echo "Usage: mcreate <session-name>"
    # otherwise, create session
    else
        tmux -2 new-session -d -s $1
    fi
}

# Attach to an open tmux session.
# If no tmux session is specified, attach to the first one
# If no tmux sessions are open, don't
# Usage:
# $ mattach <session-name>
function mattach {
    # check if user supplies no session name
    if [[ $# -eq 0 ]]; then
        # get list of all running sessions
        SESSIONS=$(tmux ls 2>&1)
        # if there are no sessions, stop
        echo $SESSIONS | grep -q "no server running"
        if [ $? -ne 0 ]; then
            OPEN_SESSIONS=$(tmux ls 2>&1 | awk '{print $1}')
            FIRST_SESSION_UNFORMATTED=$(echo $OPEN_SESSIONS | awk '{print $1}')
            SESSION=$(echo $FIRST_SESSION_UNFORMATTED | sed s'/.$//')
            tmux a -t $SESSION
        fi
    # otherwise, attach to the specified session
    else
        tmux a -t $1
    fi
}

# Stop an open tmux session
# If no session is specified, display open sessions
# Usage:
# $ mstop <session-name>
function mstop {
    # Check if any sessions are open
    OPEN_SESSIONS=$(tmux ls 2>&1)
    echo $OPEN_SESSIONS | grep -q "no server running"
    if [ $? -ne 0 ]; then
        # If no args given, display open sessions
        if [[ $# -eq 0 ]]; then
            echo "Usage: mstop <session-name>"
        # otherwise, kill the specified session
        else
            tmux kill-session -t $1
        fi
    fi
}

# Kill all open tmux sessions
# Usage:
# $ mkillall
function mkillall {
    # Check if any sessions are open
    OPEN_SESSIONS=$(tmux ls 2>&1)
    echo $OPEN_SESSIONS | grep -q "no server running"
    if [ $? -ne 0 ]; then
        SESSIONS=$(tmux ls | awk '{print $1}')
        # kill all the sessions
        for SESSION in $SESSIONS; do
            NAME=$(echo $SESSION | sed s'/.$//')
            tmux kill-session -t $NAME
        done
    fi
}
