function r = getGlobalc0
    global x
    value = x;
    if value 
       r = x;
    else
       r = defaultc0();
    end
end