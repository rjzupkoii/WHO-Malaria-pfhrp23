#!/usr/bin/env python3

# convert.py
#
# This script processes the R data from R6_map.rds to generate a single file 
# for plotting. 
#
# Order of operations is clean_results, then map_iso; map_regions is provided 
# to generate a JSON file based upon the country-region mapping as extracted
# from the R6_map.rds file.
import urllib.request
import json
import os
import pandas as pd


def clean_results(filename):
    data = pd.read_csv(filename)

    # Delete the row index column
    del data[data.columns[0]]

    # Delete the PfPR 2-10 column with numeric data
    del data[data.columns[1]]

    # Rename the PfPR 2-10 column the correct name
    data = data.rename(columns={'Micro.2.10.1': 'Micro.2.10'})

    # Replace the text values with numeric ones
    for column in ['Micro.2.10', 'ft', 'microscopy.use', 'rdt.nonadherence', 'fitness', 'rdt.det']:
        for value, label in enumerate(['best', 'central', 'worst']):
            data.loc[data[column] == label, column] = value + 1
    for column in ['hrp2_risk', 'hrp2_composite_risk']:
        for value, label in enumerate(['High', 'Moderate', 'Slight', 'Marginal']):
            data.loc[data[column] == label, column] = value + 1

    # Save the file to our working directory
    data.to_csv('temp/clean.csv', index=False)
    return 'temp/clean.csv'


def map_iso(clean_filename, mapping_filename):
    numeric = pd.read_csv(clean_filename)
    mapping = pd.read_csv(mapping_filename)
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
    numeric.to_csv('out/coded.csv', index=False)
    return 'out/coded.csv'


def map_regions(filename):
    data = pd.read_csv(filename)
    iso_codes = pd.read_csv('../data/country_iso_code.csv')

    # Note the unique regions
    mapping = {}
    for region in data.region.unique():
        mapping[region] = []

    # Map the country ISO codes to the regions
    for _, row in data.iterrows():
        iso3 = iso_codes[iso_codes['iso3'] == row.iso].numeric.item()
        if iso3 not in mapping[row.region]:
            mapping[row.region].append(iso3)

    # # Save as JSON
    # with open('out/mapping.json', 'w') as out:
    #     json.dump(mapping, out)
    # return 'out/mapping.json'
    # Save as YAML
    with open('out/mapping.yml', 'w') as out:
        ndx = 0
        for key in mapping:
            out.write('{}:\n'.format(ndx))
            out.write('  region: {}\n'.format(key))
            values = ', '.join(map(str, mapping[key]))
            out.write('  iso3n: [{}]\n'.format(values))
            ndx += 1
    return 'out/mapping.yml'


def main(refresh=False):
    # Make our temp and output directories
    os.makedirs('temp', exist_ok=True)
    os.makedirs('out', exist_ok=True)

    # Download the latest version if requested
    filename = 'temp/full_results.csv'
    if refresh:
        print('Downloading data file...')
        urllib.request.urlretrieve('https://media.githubusercontent.com/media/OJWatson/hrpup/main/analysis/tables/full_results.csv', filename)
        print('done!')

    # Map the regions
    if not os.path.isfile('out/mapping.json'):
        print('Mapping regions...')
        mapping = map_regions('data/mapping.csv')
        print('Mapped data saved as: ', mapping)
    
    # Prepare the coded data file
    if not os.path.isfile('out/coded.csv'):
        print('Processing data file...')
        clean = clean_results(filename)
        coded = map_iso(clean, 'data/mapping.csv')
        print('Cleaned and mapped results saved as: ', coded)

if __name__ == '__main__':
    main(False)
