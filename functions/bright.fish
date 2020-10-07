function dim --description "Make my screens dimmer."
  set displays (xrandr | grep connected | grep -v disconnected | cut -f1 -d' ')
  for display in $displays
    xrandr --output $display --brightness 1
  end
end
