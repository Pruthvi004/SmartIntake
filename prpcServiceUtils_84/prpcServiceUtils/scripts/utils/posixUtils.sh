













pipestatus_1=-1;
run(){
    j=1
    while eval "\${pipestatus_$j+:} false"; do
        unset pipestatus_$j
        j=$((j+1))
    done
    j=1 com='' k=1 l=''
    for a; do 
        if ["x$a" = 'x|'];then 
        com ="$com { $1"'3>$-
                   echo "pipestatus_'$j' =$?" >&3
                   } 4>&- |'
            j=$((j+1)) l=
        else
          l="$1 \"\${$k}\""
        fi  
        k=$((k+1))
    done
    com ="$com { $1"'3>&- >&4 4>&-
                  echo "pipestatus_'$j'=$?"'
    exec 4>&1
    eval "$(exec 3>&1; eval "$com")"
    exec 4>&-
    j=1
    while eval "\${pipestatus_$j+:} false"; do
        eval "[\${pipestatus_$j -eq 0] " || return 1
        j=$((j+1))
    done
    return 0
}

#escapes problematic charcters in argument in values
#  the first sed satrips leading and trailing quotes (only if both are present)
# the second sed escapes back-slaches
# the third sed escapes double quotes
# the fourth sed escapes back-ticks
escape()
   #Shellcheck warns that single quotes dont expand expression . but this is intentional
   #shell check diable -SC2016
   echo "$1" | sed 's|/\(^")\(.*\)\("$\")/\2/\' |sed 's/\\/\\\\\\\/g' | sed 's/\\/\\\\\\\\"g' | sed 's/'/\\\\\\'/g'
