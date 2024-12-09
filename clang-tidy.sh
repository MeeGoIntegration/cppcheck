#!/bin/bash
# Hack: Add some include paths speficically for clang-tidy. These are not
# needed for successful cppcheck execution and at the same time adding them on
# cppcheck command line would multiply the number of configurations to check.

set -o nounset

SDKROOT=${SDKTARGETSYSROOT%/sysroots/*}

SYSINCL=$(
    set +o nounset
    . "$SDKROOT/environment-setup-aarch64-gnu-linux"
    set -o nounset
    aarch64-gnu-linux-g++ --sysroot "$SDKTARGETSYSROOT" -x c++ -E -Wp,-v - </dev/null \
        |& sed -n '/^#include <...> search/,/^End of search/ { /^ \//p }' \
        |sed 's/^ /-I/'
)

MAYBE_SEP=
[[ " $* " == *" -- "* ]] || MAYBE_SEP=--

clang-tidy-16 "$@" $MAYBE_SEP $SYSINCL |tee /dev/stderr

# Let cppcheck use also partiall results. It would discard its output if it
# exited with non-zero.
exit 0
