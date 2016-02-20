#!/bin/bash

TARGET=$1

make "$TARGET" &>make_"$TARGET".log
tail -n100 ./make_"$TARGET".log
