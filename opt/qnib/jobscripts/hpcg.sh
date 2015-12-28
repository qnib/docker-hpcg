#!/bin/bash
#SBATCH --job-name=HPCG
#SBATCH --workdir=/scratch/
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

JOBID=${SLURM_JOBID}
NLIST=${SLURM_NODELIST}
JOB_TIME=${1-120}
JOB_SIZE=${2-104}
START_TIME=$(date +%s)
CMD=/opt/hpcg-3.0/Linux_MPI/bin/xhpcg
NODES=$(python -c "from ClusterShell.NodeSet import NodeSet;print ' '.join(NodeSet('${SLURM_NODELIST}'))")
logger -t slurm_${JOBID}  "Job ${JOBID} starts."
echo "####################################################"
echo "################ JOBRUN ############################"
echo "####################################################"
logger -t slurm_${JOBID}  "mpirun -q ${CMD} TIME:${JOB_TIME} SIZE:${JOB_SIZE}"
mkdir -p /scratch/hpcg/${JOBID}
cat << \EOF > /scratch/hpcg/${JOBID}/hpcg.dat
HPCG benchmark input file
Sandia National Laboratories; University of Tennessee, Knoxville
${JOB_SIZE} ${JOB_SIZE} ${JOB_SIZE}
${JOB_TIME}
EOF
cd /scratch/hpcg/${JOBID}/
mpirun -q ${CMD}
echo "####################################################"
echo "################ \JOBRUN ############################"
echo "####################################################"
WTIME=$(echo "$(date +%s) - ${START_TIME}"|bc)
logger -t slurm_${JOBID} "Job ${JOBID} ends K:${KVAL}; wall:${WTIME}"
echo "## $(date +'%F %H:%M:%S') Job ends"
if [ ${EC} -eq 0 ];then
    END_TIME=$(date +%s)
    echo "END_TIME=${END_TIME}"
    WALL_CLOCK=$((${END_TIME}-${START_TIME}))
    echo "WALL_CLOCK=${WALL_CLOCK}" >> job.cfg
    eval_hpcg.py --wall-clock ${WALL_CLOCK}  HPCG-Benchmark-*.yaml
fi
exit 0
