# WHO-Malaria-pfhrp23

## Overview

Rapid diagnostic tests (RDTs) are one component of *Plasmodium falciplarim* malaria case management in many parts of the world; however, deletion of histidine-rich protein genes *pfhrp2/3* can result in false-negative RDT results in tests based upon detection of the histidine-rich protein 2 (HRP2) and its paralog histidine-rich protein 3 (HRP3). Projecting the spread of *pfhrp2/3* deletions may allow local policymakers and international support agencies to plan for the possibility of increased false-negative RDT results.

This repository contains some of the computational work that was done in support of the pre-print "Global risk of selection and spread of *Plasmodium falciparum* histidine-rich protein 2 and 3 gene deletions" by Watson et al. as well as the "HRP2/3 Deletion Risk Explorer" app that allows users to explore how changes in model assumptions impact *pfhrp2/3* deletion risk at a national level.

## Repository Organization

`/` is limited to repository documentation and configuration files.\
`data/` contains data files that were used in preparation of the model, or the Deletion Risk Explorer.\
`R/` contains the source for the Deletion Risk Explorer.\
`task_1/` contains data and the Python Notebooks used to evaluate RDT data for the model.\
`utility/` contains various scripts used to processing the model data from [hrpup](https://github.com/OJWatson/hrpup) for the Deletion Risk Explorer.


# HRP2/3 Deletion Risk Explorer

The HRP2/3 Deletion Risk Explorer is an R [Shiny](https://www.rstudio.com/products/shiny/) web application that can be accessed at URL, run locally in [RStudio Desktop](https://posit.co/download/rstudio-desktop/), or deployed to a web host such as [shinyapps.io](https://www.shinyapps.io/). 

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

## Contributing Translations

Additional language translations are welcomed and should be submitted as a pull request on GitHub after forking the [rjzupkoii/WHO-Malaria-pfhrp23](https://github.com/rjzupkoii/WHO-Malaria-pfhrp23) repository on GitHub. 

The directory `R/lang` contains all of the necessary files for the user interface, structured as follows:

- Directories that are the [two character ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) (ex., `lang/es` for Spanish) containing Markdown files (ex., `explainer.md`) that are rendered as such, with some adjustments to the layout supplied by `style.css`. All Markdown files in `lang/en` need to be supplied as part of a new translation.
- CSV files named as `translation_[ISO CODE].csv` (ex., `translation_fr.csv` for French) that contains two columns. The first of which is `en` and contains the English labels in the user interface, and the second two character ISO code for the target language and contains the translated text. 
- The `translation.yml` file which supplies the translation for rendered maps. The top level key for each language is the two character ISO code, followed by fields for `choices`, `regions`, `labels`, `risk_map`, and `composite_map`. 

When the loads for a user it defaults to English, after which the language can be changed by the user via the Change Language dropdown list. The list of language is determined by the contents of the `choices` list supplied to the `language` `selectInput` control. New languages will need to be added to this `choices` list and should be added in alphabetical order, with the control text being the name of the language as it would appear to a native speaker (i.e., French is listed as Français in the list). The value returned by the control is the two character ISO language code, which is the used to select the correct language information from the server.

---

## Sources / Licenses

Underlying model data from [hrpup](https://github.com/OJWatson/hrpup), which is released under [CC-0](https://creativecommons.org/publicdomain/zero/1.0/).

World map data is from [Natural Earth](https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-admin-0-countries-2/) (version 5.1.1), which is in the public domain.