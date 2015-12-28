#!/bin/bash
#SBATCH --job-name=HPCG
#SBATCH --workdir=/scratch/
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

JOBID=${SLURM_JOBID}
NLIST=${SLURM_NODELIST}
START_TIME=$(date +%s)
NODES=$(python -c "from ClusterShell.NodeSet import NodeSet;print ' '.join(NodeSet('${SLURM_NODELIST}'))")
logger -t slurm_${JOBID}  "Job ${JOBID} starts."
echo "####################################################"
echo "################ JOBRUN ############################"
echo "####################################################"
logger -t slurm_${JOBID}  "mpirun -q ${CMD}"
mkdir -p /scratch/hpcg/${JOBID}
cat << \EOF > /scratch/hpcg/${JOBID}/hpcg.dat
HPCG benchmark input file
Sandia National Laboratories; University of Tennessee, Knoxville
104 104 104
120
EOF
cd /scratch/hpcg/${JOBID}/
mpirun -q /opt/hpcg-3.0/Linux_MPI/bin/xhpcg
echo "####################################################"
echo "################ \JOBRUN ############################"
echo "####################################################"
WTIME=$(echo "$(date +%s) - ${START_TIME}"|bc)
logger -t slurm_${JOBID} "Job ${JOBID} ends K:${KVAL}; wall:${WTIME}"
exit 0
