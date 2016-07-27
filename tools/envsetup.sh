#!/bin/sh
# fix permissions:
# 1. pass uid, gid as env vars and run some adduser/chown stuff as entry point
#    A little tedious, but no extra interaction with the host. Supposedly the
#    most safe option.
# 2. mount host password, group file....
#    If inside container, processes are run with current users' id, then no
#    security issue. The extra benifit is no need to setup HOME

# TODO Possibly a routing to find osc root
# OSC_ROOT=/home/vagrant/try

# # NOTE the way osc works, it needs ~/.oscrc file and all parent directories
# # leading to the current working package directory
# docker run -it --rm \
#   -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro \
#   -u $(id -u):$(id -g) \
#   -w $(pwd | sed -re "s|^${OSC_ROOT}|${HOME}|") \
#   -v $OSC_ROOT:$HOME \
#   -v ${OSC_ROOT}/macros.stub:/etc/rpm/macros.stub \
#   carltonf/osc-quilt:latest $*

echo "ERROR: INCOMPLETE!!! I've only implemented fish envsetup"

# Copied from: https://android.googlesource.com/platform/build/+/master/envsetup.sh
function gettop
{
    local TOPFILE=tools/osc-quilt-run
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function croot()
{
    T=$(gettop)
    if [ "$T" ]; then
        if [ "$1" ]; then
            \cd $(gettop)/$1
        else
            \cd $(gettop)
        fi
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

