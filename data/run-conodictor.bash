#!/bin/bash
#
#SBATCH --job-name=conodictory
#SBATCH --output=cono.log
#
#SBATCH --ntasks=1
#SBATCH --time=10:00 #10 minutes 
#SBATCH --mem-per-cpu=100 #megabytes
#SBATCH --cpus-per-task=4

work_dir=/home/wqiu/project-home
cono_dir=/home/wqiu/conodictor-files
/home/wqiu/miniconda3/bin/activate conodictor
export CONODB=$cono_dir
conodictor --force --cpu 4 $work_dir/All_Toxins_complete_v4.fasta

