function bright --description "Make my screens brighter."
  set displays (xrandr | grep ' connected' | cut -f1 -d' ')
  for display in $displays
    xrandr --output $display --brightness 1
  end
end
