#!/bin/bash

dpd create $1
cd $1 
dpd -H $2 -P $3 -p $4
