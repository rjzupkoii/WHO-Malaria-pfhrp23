#!/usr/bin/env python3

# convert.py
#
# This script processes the R data from R6_map.rds to generate a single file 
# for plotting. For this script to work we assume that the data has already 
# been extracted into a CSV file and some light processing - changing text
# enumerations to numeric - has already occurred. 
#
# Order of operations is clean_results, then map_iso; map_regions is provided 
# to generate a JSON file based upon the country-region mapping as extracted
# from the R6_map.rds file.
import json
import os
import pandas as pd


def clean_results():
    data = pd.read_csv('data/numeric_results.csv')

    # Delete the row index column
    del data[data.columns[0]]

    # Delete the PfPR 2-10 column with numeric data
    del data[data.columns[1]]

    # Rename the PfPR 2-10 column the correct name
    data = data.rename(columns={'Micro.2.10.1': 'Micro.2.10'})

    # Save the file to our working directory
    os.makedirs('out', exist_ok=True)
    data.to_csv('out/clean.csv', index=False)


def map_iso():
    numeric = pd.read_csv('out/clean.csv')
    mapping = pd.read_csv('data/mapping.csv')
    iso_codes = pd.read_csv('../data/country_iso_code.csv')

    # Add our ISO file
    numeric.insert(0, 'iso', '')

    # Iterate through the numeric data, map the index to the ISO country, then
    # store the numeric ISO code based upon the mapped ISO3 code
    rows = len(numeric.index)
    for index, row in numeric.iterrows():
        iso3 = mapping.loc[mapping['id_1'] == row.id_1].iso.item()
        numeric.at[index, 'iso'] = iso_codes.loc[iso_codes['iso3'] == iso3].numeric.item()

        # Let the user know we didn't crash 
        if index % 10000 == 0:
            print('Progress: {}%'.format(round((index / rows) * 100.0, 2)))

    # Drop the original mapping column
    del numeric[numeric.columns[1]]

    # Save the data to our working directory
    os.makedirs('out', exist_ok=True)
    numeric.to_csv('out/coded.csv', index=False)


def map_regions():
    data = pd.read_csv('data/mapping.csv')

    # Note the unique regions
    mapping = {}
    for region in data.region.unique():
        mapping[region] = []

    # Map the country ISO codes to the regions
    for _, row in data.iterrows():
        if row.iso not in mapping[row.region]:
            mapping[row.region].append(row.iso)

    # Save as JSON
    os.makedirs('out', exist_ok=True)
    with open('out/mapping.json', 'w') as out:
        json.dump(mapping, out)


map_iso()
