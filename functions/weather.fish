function weather --description "Show the weather."
    curl "http://wttr.in/$WEATHER_WHERE_AM_I?u"
end
