#!/bin/bash
zip_file="aichallenge.zip"
if [ -f "$zip_file" ]
then
    rm $zip_file
fi
zip -r $zip_file ruby
