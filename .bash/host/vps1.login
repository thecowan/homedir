
if [ "$color_prompt" = yes ]; then
    USER_COLOR=$COLOR_MAGENTA
elif [ "$color_prompt" = full ]; then
    USER_COLOR=`extColor 55`
fi

