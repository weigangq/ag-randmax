#!/usr/bin/env bash

alg=$1
for tsize in {1..10}; do
    for asize in {1..10}; do
		for run in {1..1}; do
			./run-cam.py -t "run_$run" -tsize $tsize -asize $asize -alg $alg
		done
	done
done


	
