# *pfhrp2\/3* Deletion Risk Explorer

## Introduction

Malaria rapid diagnostic tests (RDTs) commonly deployed for the diagnosis of *Plasmodium falciparum* malaria detect the *P. falciparum* histidine-rich protein 2 (PfHRP2) and its paralog *P. falciparum* histidine-rich protein 3 (PfHRP3). However, progress against malaria is now treated by an increase in *pfhrp2\/3* gene deletions. 

The timeline for countries to transition away from HRP2-based RDTs to alternative diagnostic methods is dependent upon several factors, to include: the current epidemiological situation, the availability of alternative RDTs, and individual national strategies. The objective of this *pfhrp2\/3* deletion risk explorer is to allow users to explore how changes in the underlying modeling assumptions 

## Model Description

An individual-based mathematical model of *P. falciparum* malaria transmission was used to simulate the selection of *pfhrp2* deletions based upon several model parameters ([Watson et al. 2017](https://doi.org/10.7554/eLife.25008)). Six of the key drivers associated with the spread of *pfhrp2* deletions can be explored using this application:

| <div style="width: 13.5em">Drivers of selection</div> | Impact on selection | Model data source |
| --- | --- | --- |
| Treatment Seeking Rate | Increased treatment seeking will increase the rate at which the selective advantage conferred by *pfhrp2\/3* is realized by evading diagnosis and treatment. | [DHS/MIS Surveys](https://dhsprogram.com/methodology/survey-types/mis.cfm) used in generalized additive mixed model (GAMM) to predict car seeking patterns |
| Probability of a Positive RDT | If a *pfhrp2\/3* deletion continues to yield a positive RDT result, then the selective advantage is negated. | Estimate based upon literature review |
| Adherence to RDT Outcomes | Increased non-adherence to RDT outcomes (i.e., treating an RDT negative individual) will negate the selective advantage of *pfhrp2\/3* deletions. | Spatial model of the probability of care-seeking fevers receiving any antimalarial informed by [DHS data](https://dhsprogram.com/Data/), along with a literature review of presumptive treatment rates |
| Microscopy Based Diagnosis | The use of microscopy for malaria diagnosis will negate the advantage conferer by *pfhrp2\/3* deletions. | [WHO World Malaria Report](https://www.who.int/teams/global-malaria-programme/reports)'s "proportion of cases confirmed by diagnostic" table along with literature reviews to fill data gaps |
| Malaria Prevalence | Lower prevalence will increase selection by increasing the likelihood that individuals are infected by *pfhrp2\/3* deleted parasites and are less likely to be treated. | [Malaria Atlas Project](https://malariaatlas.org/) maps of blood slide positivity for ages two to ten (*Pf*PR<sub>2-10</sub>) |
| Deletion Fitness | Fitness costs associated with *pfhrp2/3* gene deletions will reduce the transmissibility of gene deleted parasites. | Parameterized via model fitting to Eritrean and Ethiopian deletion data, with priors from in vitro competition assay data ([Nair et al. 2022](https://doi.org/10.1093/infdis/jiac240))  |


## References

Nair, S., Li, X., Nkhoma, S. C., & Anderson, T. (2022). Fitness Costs of pfhrp2 and pfhrp3 Deletions Underlying Diagnostic Evasion in Malaria Parasites. The Journal of Infectious Diseases, 226(9), 1637–1645. https://doi.org/10.1093/infdis/jiac240

Watson, O. J., Slater, H. C., Verity, R., Parr, J. B., Mwandagalirwa, M. K., Tshefu, A., Meshnick, S. R., & Ghani, A. C. (2017). Modelling the drivers of the spread of Plasmodium falciparum hrp2 gene deletions in sub-Saharan Africa. ELife, 6, e25008. https://doi.org/10.7554/eLife.25008

