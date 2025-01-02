#!/bin/bash
#SBATCH --job-name=mpi_coletiva
#SBATCH --partition=hype
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --time=2:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

MACHINEFILE="nodes.$SLURM_JOB_ID"
srun -l hostname | sort -n | awk '{print $2}' > $MACHINEFILE

perf stat -e task-clock,cycles,instructions \
mpirun -np $SLURM_NTASKS \
       -machinefile $MACHINEFILE \
       --mca btl ^openib \
       --mca btl_tcp_if_include eno2 \
       --bind-to none -np $SLURM_NTASKS \
       ./mpi_coletiva 1024 & >> coletiva_1024_1_10.out
sacct -j $SLURM_JOB_ID --format=JobID,JobName,CPUTime,MaxRSS,AveRSS,Elapsed