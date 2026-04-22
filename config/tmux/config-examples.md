# TMUX config examples

## Popups

Toggleable popup window with a persistent session.
Session current working dir can only be set first time its launched.

```tmux
bind-key -N "Toggle popup shell" -n M-1 if-shell -F '#{==:#{session_name},float}' { detach-client } { popup -E -d "#{pane_current_path}" -w80% -h80% 'tmux attach -t float || tmux new -s float \; display-message "Press Alt-1 to toggle floating popup or Ctrl-D to kill it"' }
```
