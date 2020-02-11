#!/usr/bin/env bash

# takes filename as argument
# if no filename given, reads from standard input

# prints parse tree to standard output

first_argument="$1"

filename="$first_argument"

filename_given=$([ -n "$filename" ] && echo true || echo false)

script_directory=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)

parser="$script_directory/parse.rkt"

if [ "$filename_given" = true ]
then
  $parser "$filename"
else
  $parser <(cat)
fi
