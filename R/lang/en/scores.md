## *pfhrp2* deletion risk scores

In this tool we produce two risk scores: the “Innate Risk Score” and the “Prospective Risk Score”. For complete details on both risk scores, please see Watson et al (2023).

### Innate Risk Score

The Innate Risk Score is the innate potential for *pfhrp2* deletions to spread once established in a region based solely on the region’s malaria transmission intensity, treatment-seeking data, and adherence to diagnostic test outcomes. Informed by the current 5% WHO threshold, the Innate Risk Score is the time taken for the percentage of clinical cases to be misdiagnosed by PfHRP2-based RDTs to increase from 1% to 5% if a region uses only PfHRP2-based RDTs. Here, a region’s risk is classified as High, Moderate or Slight, defined as reaching the 5% threshold within 6, 12 and 20 years, respectively, or marginal risk if 5% is not reached within 20 years. 

### Prospective Risk Score

The Prospective Risk Score explores how *pfhrp2* deletions may continue to spread in Africa based on best estimates of the prevalence of *pfhrp2* deletions from the WHO Threat Maps. Informed by the current 5% WHO threshold, the Prospective Risk Score is the time taken for the percentage of clinical cases to be misdiagnosed by PfHRP2-based RDTs to increase from current estimates to 5%. While there are considerable uncertainties in the prevalence of gene deletions across Africa (Thomson et al. 2020), these estimates represent – as of June 2023 – our best understanding of the current genotype frequency of *pfhrp2* deletions in Africa. In countries without molecular surveillance data, we assume the current frequency of *pfhrp2* deletions is 0%. To simulate the spread of pfhrp2 deletions between regions, we assume pfhrp2 deletions are exported from the largest subnational administrative unit of a country (i.e., Administrative Level 1) once pfhrp2 deletions are found in 25% of clinical cases. As a result, the prospective risk score is only produced for Africa where the majority of the most recent surveys for pfhrp2 deletions have been conducted.

## Why do we produce two risk scores?

We chose to produce two risk maps because robust molecular surveys of *pfhrp2\/3* deletions have not been conducted across all regions. Although surveillance for *pfhrp2\/3* deletions has increased rapidly since the widespread introduction of RDTs, by the beginning of 2023, surveys have only been conducted in 22 countries in Africa (WHO 2017). For the Prospective Risk Score, we assumed that countries without surveys have 0% *pfhrp2* deletion frequency. If this assumption is incorrect, the Prospective Risk Score will underestimate the risk in these countries. The Innate Risk Score, on the other hand, focuses on the risk that *pfhrp2* deletions pose once present in a region and assuming the region uses only PfHRP2-based RDTs.

Producing two risk scores has a number of benefits. Firstly, the Innate risk score can be used to confirm that the model correctly identifies regions in which deletions have rapidly increased as High Risk - indeed the Horn of Africa is correctly identified as a High Risk region. This finding increases confidence that the model can predict regions that are susceptible to selecting for gene deletions. Secondly, the Innate Risk Score can also be used to address additional questions relevant to malaria policies, including where to prioritize new *pfhrp2\/3* surveys. For example, if deciding amongst countries without previous surveys, the Innate risk score can be used to identify countries predicted to select for deletions fastest and therefore in greatest need of surveillance. The Prospective Risk Score, however, can be used to identify regions that are both susceptible for deletions to increase once established and spatially close to regions known to have selected for gene deletions.      

## References

Thomson R, Parr JB, Cheng Q, Chenet S, Perkins M, Cunningham J. Prevalence of Plasmodium falciparum lacking histidine-rich proteins 2 and 3: a systematic review. *Bulletin of the World Health Organization*. 2020;98: 558–568F. http://dx.doi.org/10.2471/BLT.20.250621 (PDF file)

World Health Organization. Malaria Threat Maps. 2017 [Date Accessed: 20 Jun 2023]. Available: http://apps.who.int/malaria/maps/threats/
