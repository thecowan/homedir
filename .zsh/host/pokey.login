if [ "$color_prompt" = full ]; then
  USER_COLOR=%F{208}
fi
alias angus="python3 ~/src/oss/angusify/angus.py"


function stackdeploy() { filename=$(basename -- "$1"); stack="${filename%.*}"; envfile=".dummy.env"; candidate=".${stack}.env"; if test -f "${candidate}"; then echo "Using env file ${candidate}"; envfile="${candidate}"; fi; docker deployx --env-file="${envfile}" --compose-file "$1" $stack }
