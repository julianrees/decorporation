#!/bin/bash
if [ "$#" -gt 2 ]; then
  echo "ERROR: Too many arguments! usage: merge.sh filestem fileextention (optional, * is default)"
  exit 1
fi
if [ "$#" == 2 ]; then
  EXT=$2
  STEM=$1
if
if [ "$#" == 1 ]; then
  EXT="*"
  STEM=$1
else
  echo "ERROR: Provide a filename stem! usage: merge.sh filestem fileextention (optional, * is default)"
  exit 1
fi
