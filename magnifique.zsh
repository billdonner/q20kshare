#!/bin/zsh

echo "Prompt template: $1"
echo "Topics script: $2"
echo "IOS Game data output: $3"

if [[ $# -ne 3 ]]; then
    echo "Usage: You must provide exactly three arguments!"
    exit 1
fi

snarkyc $1 $2 --output file:///users/fs/between_0_1.txt
pumperc file:///Users/fs/Between_0_1.txt file:///Users/fs/Between_1_2.json --dots true --max 500 --unique false
 prepperc file:///Users/fs/Between_1_2.json file:///Users/fs/Between_2_3.txt
 liedetectorc file:///Users/fs/Between_2_3.txt file:///Users/fs/Between_3_4.json --unique false
 blenderc file:///users/fs/Between_1_2.json file:///users/fs/Between_3_4.json $2 -o $3
 
