# prefactor-cwl
CWL version of prefactor

https://github.com/EOSC-LOFAR/prefactor-cwl

[![Build Status](https://travis-ci.org/gijzelaerr/prefactor-cwl.svg?branch=master)](https://travis-ci.org/gijzelaerr/prefactor-cwl)

# requirements

* [Docker](https://www.docker.com/)
* A [CWL](http://www.commonwl.org/) runner (like [the reference CWL runner](https://github.com/common-workflow-language/cwltool))
# usage


To run the pipeline with the example dataset just run:
```bash
$ make run
```

# steps

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
