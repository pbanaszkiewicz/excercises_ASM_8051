#!/bin/bash

filename="$1"

sdas8051 -xlos "$filename.asm" && echo "-mxiu
${filename}.ihx
${filename}.rel
-e" > "$filename.lnk" && sdld -f "$filename.lnk" &&
packihx "$filename.ihx" > "$filename.hex" &&
echo "-------- GOTOWE ---------"
