#!/bin/bash
zip_file="aichallenge.zip"
if [ -b "$zip_file" ]
then
    rm $zip_file
fi
zip -r $zip_file ruby
