#!/bin/bash

file="$1"

if [ -w "$file" ] && [ -w "$(dirname "$file")" ]; then
    exec mousepad "$file"
else
    exec plus mousepad "$file"
fi