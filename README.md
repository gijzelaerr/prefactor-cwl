# prefactor-cwl
CWL version of prefactor

https://github.com/lofar-astron/prefactor/

[![Build Status](https://travis-ci.org/EOSC-LOFAR/prefactor-cwl.svg?branch=master)](https://travis-ci.org/EOSC-LOFAR/prefactor-cwl)

Note that this project is still very much in alpha stage and very much in flux.
It is a prototype implementation and is not intended for end user audience.
The goal is to demonstrate various technologies and how they could assist
simplifying construction and deployment of big scale data reduction pipelines.

# requirements

* [Python Virtualenv](https://virtualenv.pypa.io/en/stable/)
* [Node JS](https://nodejs.org/en/)

optional:
* [Slum](https://slurm.schedmd.com/)
* [Docker](https://www.docker.com/)
* [Singularity](http://singularity.lbl.gov/)


# preperations

You first need to preprocess the CWL files since the standard
doesn't support Singularity yet. If you want to use singularity run:

```bash
$ make singularity
```

otherwise run:
```bash
$ make no-singularity
```

# usage

To run the pipeline with the example dataset just run:
```bash
$ make run
```

To Run using a udocker (user space docker) run:
``` bash
$ make run-udocker
```

To try out toil as a schedular run:
```bash
$ make toil
```

## HPC cloud

We've made a set of ansbile scripts to automate the deployment of a cluster
that can run CWL pipelines: https://github.com/EOSC-LOFAR/ansible

## on Cartesius

If you are on cartesius, you first need to activate a python environment:
```bash
$ module load python
```

If you want to use the CWL reference runner, you also need node-js. An easy
way to set this up is using [spack](https://github.com/spack/spack).

```bash
$ git clone https://github.com/spack/spack
$ spack/share/spack/setup-env.sh
$ spack bootstrap
$ spack install node-js
$ spack load node-js
```

Since all jobs are quite small, it is better to use the staging partition.
You can configure toil to use the staging partition with:
```bash
$ export TOIL_SLURM_ARGS="-t 0:30:00 -p staging"
```

```bash
$ make slurm
```

# steps

[![graph](https://raw.githubusercontent.com/EOSC-LOFAR/prefactor-cwl/master/prefactor.png)](https://view.commonwl.org/workflows/github.com/EOSC-LOFAR/prefactor-cwl/blob/master/prefactor.cwl)

the pipeline consists of these steps:

| step name               | status      | file   | comment          |
| ------------------------|-------------|--------|------------------|
| createmap\_cal          | skip        |  | we don't use map files   |
| ndppp\_prep\_cal        | implemented | [steps/ndppp_prep_cal.cwl](steps/ndppp_prep_cal.cwl) |
| combine\_data\_cal\_map | skip        |  |We don't use map files   |
| sky\_cal                | implemented | [steps/sky_cal.cwl](steps/sky_cal.cwl)    |
| sky\_cal\_path          | skip        |  |we don't use map files   |
| calib\_cal              | implemented | [steps/steps/calib_cal.cwl](steps/steps/calib_cal.cwl) |
| h5\_imp\_cal\_map       | skip        |  |we don't use map files   |
| h5imp\_cal              | implemented | [steps/losoto_importer.cwl](steps/losoto_importer.cwl) |
| mk\_inspect\_dir        | skip        |  | we don't need to create dirs |
| copy\_h5imp\_cal        | skip        |  | this is managed by CWL |
| fitclock                | implemented | [steps/fitclock.cwl](steps/fitclock.cwl) |
| ampl                    | implemented | [steps/ampl.cwl](steps/ampl.cwl)  | disabled for test since not enough subbands
| plots                   | implemented | [steps/plots.cwl](steps/plots.cwl) | disabled for test since not enough subbands
| phase                   | implemented | [steps/phase.cwl](steps/phase.cwl) |
| plot\_cal\_phases       | implemented | [steps/plot_cal_phases.cwl](steps/plot_cal_phases.cwl) |
| createmap\_cal\_pngs    | skip        | | we don't use map files |
| copy\_cal\_pngs         | skip        | | this is managed by CWL |
| createmap\_cal\_txts    | skip        | | we don't use map files |
| copy\_cal\_txts         | skip        | | this is managed by CWL |
| mk\_cal\_values\_dir    | skip        | | this is managed by CWL |
| createmap\_cal\_npys    | skip        | | we don't use map files |
| copy\_cal\_npys         | skip        | | this is managed by CWL |
