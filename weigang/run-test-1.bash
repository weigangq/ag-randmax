#!/usr/bin/env bash

alg=$1
for tsize in {1..20}; do
    for asize in {1..10}; do
		for run in {1..10}; do
			./cam-test-1-adaptation.py -t "run_$run" -tsize $tsize -asize $asize -alg $alg
		done
	done
done


	
