#!usr/bin/env bash

for file in ./*.sh;do
  if [[ $file =~ $0 ]];
     continue
  fi
  printf "%s\n" "$file"
done
