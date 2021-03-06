.PHONY: clean run small docker run-udocker run-singularity toil-udocker toil-singularity
all: run
SHELL=bash
RUN := $(PWD)/runs/run_$(shell date +%F-%H-%M-%S)
ARCHIVE=ftp://ftp.astron.nl/outgoing/EOSC/datasets/
TINY=L591513_SB000_uv_delta_t_4.MS
PULSAR=GBT_Lband_PSR.fil
SMALL=L570745_SB000_uv_first10.MS

# archive name is different from file name
SMALL_ARCHIVE=L570745_uv_first10.MS.tar.xz


.virtualenv/:
	virtualenv -p python2 .virtualenv
 
.virtualenv/bin/cwltool: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/cwltoil: .virtualenv/
	.virtualenv/bin/pip install -r requirements.txt

.virtualenv/bin/udocker: .virtualenv/
	curl https://raw.githubusercontent.com/indigo-dc/udocker/master/udocker.py > .virtualenv/bin/udocker
	chmod u+rx .virtualenv/bin/udocker
	.virtualenv/bin/udocker install

data/$(PULSAR):
	cd data && wget $(ARCHIVE)$(PULSAR)

data/$(TINY)/:
	cd data && wget $(ARCHIVE)$(TINY).tar.xz && tar Jxvmf $(TINY).tar.xz

tiny: data/$(TINY)/
	echo "data/$(TINY)/ is downloaded"

data/$(SMALL_ARCHIVE): 
	cd data && wget $(ARCHIVE)$(SMALL_ARCHIVE)

data/$(SMALL)/: data/$(SMALL_ARCHIVE)
	cd data && tar Jxmvf $(SMALL_ARCHIVE)

small: data/$(SMALL)/
	echo "data/$(SMALL)/ is downloaded"

run-udocker: .virtualenv/bin/udocker .virtualenv/bin/cwltool
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
	        --parallel \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--cachedir cache \
		--outdir $(RUN)/results \
		prefactor.cwl \
		jobs/job_20sb.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

run: .virtualenv/bin/cwltool
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--parallel \
		--leave-tmpdir \
		--cachedir cache \
		--outdir $(RUN)/results \
		prefactor.cwl \
		jobs/job_20sb.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)

run-singularity: .virtualenv/bin/cwltool
	mkdir -p $(RUN)
	.virtualenv/bin/cwltool \
		--parallel \
		--singularity \
		--leave-tmpdir \
		--cachedir cache \
		--outdir $(RUN)/results \
		prefactor.cwl \
		jobs/job_20sb.yaml > >(tee $(RUN)/output) 2> >(tee $(RUN)/log >&2)


toil: data/$(SMALL)/ .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--tmp-outdir-prefix $(PWD)/tmp \
		--workDir $(PWD)/work \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output

toil-singularity: data/$(SMALL)/ .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--singularity \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--tmp-outdir-prefix $(PWD)/tmp \
		--workDir $(PWD)/work \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output

toil-udocker: data/$(SMALL)/ .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--tmp-outdir-prefix $(PWD)/tmp \
		--workDir $(PWD)/work \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output

slurm: data/$(SMALL) .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--batchSystem=slurm  \
		--preserve-environment PATH \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output


slurm-singularity: data/$(SMALL) .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--singularity \
		--batchSystem=slurm  \
		--preserve-environment PATH \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output


slurm-udocker: data/$(SMALL) .virtualenv/bin/cwltoil
	mkdir -p $(RUN)/results
	.virtualenv/bin/toil-cwl-runner \
		--user-space-docker-cmd `pwd`/.virtualenv/bin/udocker \
		--batchSystem=slurm  \
		--preserve-environment PATH \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output

mesos: data/$(SMALL) 
	export PYTHONPATH=/usr/lib/python2.7/site-packages
	mkdir -p $(RUN)/results
	toil-cwl-runner \
		--batchSystem=mesos \
		--mesosMaster=145.100.59.50:5050 \
		--preserve-environment PATH \
		--logFile $(RUN)/log \
		--outdir $(RUN)/results \
		--jobStore file://$(RUN)/job_store \
		prefactor.cwl \
		jobs/job_20sb.yaml | tee $(RUN)/output

docker:
	docker build -t kernsuite/prefactor .
