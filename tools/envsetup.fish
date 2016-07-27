# Generally, use bass wrapper to use functions in envsetup.sh
set TOP (realpath (dirname (status -f))/../)

set -x OSC_ROOT $TOP/oscroot

# NOTE as in bash, existence returns 0
if test ! -d $OSC_ROOT
  mkdir -pv $OSC_ROOT
end

function ctop -d 'cd back to top directory'
  cd $TOP
end

function croot -d 'cd back to osc root (the most used one)'
  cd $OSC_ROOT
end

# NOTE: not working, I think this type of functions are against how shell actually works
#
# function reload_envsetup -d 'reload envsetup without refer to script path'
#   source $TOP/tools/envsetup.sh
# end

# TODO migrate to docker compose?
function __docker_run -d 'internal docker run wrapper'
  set -l image carltonf/obs-toolbox:latest
  docker run -it --rm  \
    -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro \
    -u (id -u):(id -g)  \
    -w (pwd | sed -re "s|^$OSC_ROOT|$HOME|") \
    -v $OSC_ROOT:$HOME  \
    -v {$TOP}/tools/macros.stub:/etc/rpm/macros.stub \
    $image $argv
end

alias osc "__docker_run osc"
alias isc "__docker_run osc -A https://api.suse.de"
alias quilt "__docker_run quilt"

set MACROS_STUB_FILE $TOP/tools/macros.stub
function stub_rpm_macro -d 'Helper function to stub a macro without %'
  set -l macro_name (string replace -r '^%' '' "$argv")
  if test (string length "$macro_name") -eq 0
    echo 'ERROR: No valid macro name. Abort.'
    return -1
  end

  echo '%'$macro_name    '#' >> $MACROS_STUB_FILE
end

# TODO: any way to print relative path to sub file
function list_stub_macros -d 'list all stub macros'
  echo "* List all macro stubs [$MACROS_STUB_FILE] :"
  grep -e '^%' $MACROS_STUB_FILE
end
