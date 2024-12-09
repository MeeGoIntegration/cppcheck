#!/bin/bash

clang-tidy-16 "$@" |tee /dev/stderr

# Let cppcheck use also partiall results. It would discard its output if it
# exited with non-zero.
exit 0
