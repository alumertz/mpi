#!/bin/bash
#SBATCH --job-name=16384_4_160
#SBATCH --partition=hype
#SBATCH --nodes=4
#SBATCH --ntasks=160
#SBATCH --time=2:00:00
#SBATCH --output=./bloq/out/%x_%j.out
#SBATCH --error=./bloq/out/%x_%j.err

MACHINEFILE="nodes.$SLURM_JOB_ID"
srun -l hostname | sort -n | awk '{print $2}' > $MACHINEFILE

perf stat -e task-clock,cycles,instructions \
mpirun -np $SLURM_NTASKS \
       -machinefile $MACHINEFILE \
       --mca btl ^openib \
       --mca btl_tcp_if_include eno2 \
       --bind-to none -np $SLURM_NTASKS \
       ./mpi_p2p_bloqueante 16384 &>> ./bloq/tm_16384_4_160.out  
sacct -j $SLURM_JOB_ID --format=JobID,JobName,CPUTime,MaxRSS,AveRSS,Elapsed
