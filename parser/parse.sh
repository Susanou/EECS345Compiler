#!/usr/bin/env bash

# takes filename as argument
# if no filename given, reads from standard input

# prints parse tree to standard output

first_argument="$1"

filename="$first_argument"

filename_given=$([ -n "$filename" ] && echo true || echo false)

parser="./parse.rkt"

if [ "$filename_given" = true ]
then
  $parser "$filename"
else
  $parser <(cat)
fi
