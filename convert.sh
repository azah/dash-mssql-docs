#!/bin/bash

filetype=$(echo "${1#*.}");
outdir="../../../ms-sql.docset/Contents/Resources/Documents/$(dirname $1)";
test -d $outdir || mkdir -p "$outdir" ;

if [ $filetype = "md" ]; then
  echo "Converting $1";
  pandoc "$1" --output "$outdir/$(basename "$1" .md).html" --from markdown --to html --lua-filter=../../../links-to-html.lua;
else
  echo "copying media file: $1"
  cp $1 $outdir
fi
