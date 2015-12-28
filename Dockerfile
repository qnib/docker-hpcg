FROM qnib/compute

RUN yum install -y gcc-c++
RUN curl -sfL http://www.hpcg-benchmark.org/downloads/hpcg-3.0.tar.gz | tar xzf - -C /opt/ && \
    mkdir /opt/hpcg-3.0/Linux_MPI && \
    cd /opt/hpcg-3.0/Linux_MPI && \
    /opt/hpcg-3.0/configure Linux_MPI && \
    source /etc/profile && \
    module load mpi && \
    make -j2
ADD opt/qnib/jobscripts/hpcg.sh /opt/qnib/jobscripts/
ADD opt/qnib/bin/eval_hpcg.py /opt/qnib/bin/
