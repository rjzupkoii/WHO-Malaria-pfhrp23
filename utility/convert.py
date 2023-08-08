#!/usr/bin/env python3

# convert.py
#
# This script processes the R data from R6_map.rds to generate a single file 
# for plotting. 
import os
import pandas as pd
import urllib.request

# The following comes from https://github.com/OJWatson/hrpup
ANALYSIS_DATA = 'temp/full_results.csv'
ANALYSIS_URL = 'https://github.com/OJWatson/hrpup/raw/main/analysis/data_out/full_results.csv'
COVARIATE_DATA = 'temp/covariate_ranges.rds'
COVARIATE_RANGES = 'https://github.com/OJWatson/hrpup/raw/main/analysis/data_derived/global_covariate_ranges.rds'

# Data files referenced by this script
REFERENCE_REGION_MAPPING = 'data/region_mapping.csv'

# Data files produced by this script
REGION_MAPPING = 'out/mapping.csv'
RESULTS_MAPPING = 'out/coded.csv'


def code_results(filename):
    # Expected headings: "","id_1","hrp2_risk","hrp2_prospective_risk","Micro.2.10","ft","microscopy.use","rdt.nonadherence","fitness","rdt.det","name_1","iso"
    data = pd.read_csv(filename)

    # Delete the row index column and then the id column
    del data[data.columns[0]]
    del data[data.columns[0]]

    # Rename the subregion column
    data = data.rename(columns={'name_1': 'subregion'})

    # Replace the text values with numeric ones
    for column in ['Micro.2.10', 'ft', 'microscopy.use', 'rdt.nonadherence', 'fitness', 'rdt.det']:
        for value, label in enumerate(['best', 'central', 'worst']):
            data.loc[data[column] == label, column] = value + 1
    for column in ['hrp2_risk', 'hrp2_prospective_risk']:
        for value, label in enumerate(['High', 'Moderate', 'Slight', 'Marginal']):
            data.loc[data[column] == label, column] = value + 1

    # Remove any rows that contain NA for the name or ISO code, but make sure we inform the user
    rows = len(data[data['iso'].isna()])
    if rows != 0:
        print('Removing {} rows with unknown ISO codes...'.format(rows))
        data = data[~data['iso'].isna()]

    # Save the file to our working directory
    data.to_csv(RESULTS_MAPPING, index=False)
    return RESULTS_MAPPING


def code_regions(filename):
    # Load the data provided
    data = pd.read_csv(filename)
    
    # Delete the row index column
    del data[data.columns[0]]

    # Add a region id column
    data['region_id'] = ''
    for value, label in enumerate(['Africa', 'Asia', 'Latin America and the Caribbean', 'Oceania']):
        data.loc[data['region'] == label, 'region_id'] = value + 2
    
    # Save the data to our out directory
    data.to_csv(REGION_MAPPING, index=False)
    return REGION_MAPPING


def main(refresh=False):
    # Make our temp and output directories
    os.makedirs('temp', exist_ok=True)
    os.makedirs('out', exist_ok=True)

    # Get or refresh the data as needed
    if not os.path.isfile(ANALYSIS_DATA) or refresh:
        print('Downloading data file...', end='', flush=True)
        urllib.request.urlretrieve(ANALYSIS_URL, ANALYSIS_DATA)
        print('done!')
    if not os.path.isfile(COVARIATE_DATA) or refresh:
        print('Downloading covariant data...', end='', flush=True)
        urllib.request.urlretrieve(COVARIATE_RANGES, COVARIATE_DATA)
        print('done!')

    # Make sure the regions are coded with the order that we want
    code_regions(REFERENCE_REGION_MAPPING)
    code_results(ANALYSIS_DATA)


if __name__ == '__main__':
    main()
