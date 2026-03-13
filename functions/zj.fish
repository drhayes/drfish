function zj --description "attach to existing zellij session or create a new one"
  # Get the name of the first active (non-EXITED) session.
  set -l session (zellij list-sessions --no-formatting 2>/dev/null | string match -rv 'EXITED' | head -1 | string replace -r '\s.*' '')
  if test -n "$session"
    zellij attach $session $argv
  else
    zellij $argv
  end
end
