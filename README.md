# WHO-Malaria-pfhrp23

## Overview

Rapid diagnostic tests (RDTs) are one component of *Plasmodium falciplarim* malaria case management in many parts of the world; however, deletion of histidine-rich protein genes *pfhrp2/3* can result in false-negative RDT results in tests based upon detection of the histidine-rich protein 2 (HRP2) and its paralog histidine-rich protein 3 (HRP3). Projecting the spread of *pfhrp2/3* deletions may allow local policymakers and international support agencies to plan for the possibility of increased false-negative RDT results.

This repository contains some of the computational work that was done in support of the pre-print "Global risk of selection and spread of *Plasmodium falciparum* histidine-rich protein 2 and 3 gene deletions" by Watson et al. as well as the "hrp2/3 Deletion Risk Explorer" app that allows users to explore how changes in model assumptions impact *pfhrp2/3* deletion risk at a national level.

## Repository Organization

`/` is limited to repository documentation and configuration files.\
`data/` contains data files that were used in preparation of the model, or the Deletion Risk Explorer.\
`R/` contains the source for the Deletion Risk Explorer.\
`task_1/` contains data and the Python Notebooks used to evaluate RDT data for the model.\
`utility/` contains various scripts used to processing the model data from [hrpup](https://github.com/OJWatson/hrpup) for the Deletion Risk Explorer.


# hrp2/3 Deletion Risk Explorer

The hrp2/3 Deletion Risk Explorer is an R [Shiny](https://www.rstudio.com/products/shiny/) web application that can be accessed at URL, run locally in [RStudio Desktop](https://posit.co/download/rstudio-desktop/), or deployed to a web host such as [shinyapps.io](https://www.shinyapps.io/). 

## Running in RStudio

After this repository has been downloaded to your local machine and opened in RStudio, the dependencies can be installed via the following commands:

```R
install.packages("devtools")
devtools::install_deps('.')
```

After which the app can be launched by either opening `R/launch.R` and clicking "Run App" or by the following command:

```R
runApp('R/launch.R')
```

The first time that the app runs warnings may be produced by `CPL_gdal_init()`, but these can generally be ignored if the app loads successfully.

---

## Sources / Licenses

Underlying model data from [hrpup](https://github.com/OJWatson/hrpup), which is released under [CC-0](https://creativecommons.org/publicdomain/zero/1.0/).

World map data is from [Natural Earth](https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/) (version 5.1.1), which is in the public domain.