#!/usr/bin/env python3

# convert.py
#
# This script processes the R data from R6_map.rds to generate a single file 
# for plotting. 
#
# Order of operations is clean_results, then map_iso; map_regions is provided 
# to generate a JSON file based upon the country-region mapping as extracted
# from the R6_map.rds file.
import os
import pandas as pd
import re
import urllib.request

from unidecode import unidecode

# The following comes from https://github.com/OJWatson/hrpup
ANALYSIS_DATA = 'temp/full_results.csv'
ANALYSIS_URL = 'https://github.com/OJWatson/hrpup/raw/main/analysis/data_out/full_results.csv'

# The following comes from https://github.com/wooorm/iso-3166
ISO_6166_1 = 'temp/iso_3166-1.csv'
ISO_6166_2 = 'temp/iso_3166-2.csv'
ISO_6166_TEMPLATE = 'temp/iso_3166-{}.csv'
ISO_6166_URL = 'https://raw.githubusercontent.com/wooorm/iso-3166/main/{}.js'

# The following is produced by this script
ERRORS_LOG = 'temp/errors.txt'
REGION_MAPPING = 'out/mapping.yml'


def clean_results(filename):
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
    data.to_csv('temp/clean.csv', index=False)
    return 'temp/clean.csv'


def get_iso(level):
    TEMP_FILE = 'temp/{}.js'
    working = []

    # Download the data
    print('Downloading ISO 3166-{} codes...'.format(level), end='', flush=True)
    urllib.request.urlretrieve(ISO_6166_URL.format(level), TEMP_FILE.format(level))
    print('done!')    

    # Read the file and strip the header information
    print('Parsing ISO 3166-{} codes...'.format(level), end='', flush=True)
    with open(TEMP_FILE.format(level), 'r') as file:
        data = file.read()
    data = data[data.find('export const iso3166{}'.format(level)):]

    # Parse the subregion codes out of the file
    while data.find('}') != -1:
        # Find the subregion
        lbrace = data.find('{')
        rbrace = data.find('}')
        region = data[lbrace + 1:rbrace]

        # Update our list
        matched = re.findall(r"['\"](.*)[\"']", region)
        if matched != None and level == 1:
            working.append('{},{},{},"{}"\n'.format(int(matched[4]),matched[2],matched[3], unidecode(matched[0])))
        elif matched != None and level == 2:
            working.append('{},{},"{}"\n'.format(matched[2], matched[0], unidecode(matched[1])))

        # Move to the next group
        data = data[rbrace + 1:]

    # Save the data to disk
    with open(ISO_6166_TEMPLATE.format(level), 'w') as file:
        if level == 1:
            file.write('numeric,alpha2,alpha3,name\n')
        elif level == 2:
            file.write('parent,code,name\n')
        for line in working:
            file.write(line)
    print('done!')


def map_iso(clean_filename, mapping_filename):
    # Recursive assignment to allow for duplicate subregions to be resolved
    def assign(subregion, recursive = False):
        message = None
        if len(subregion) == 0:
            message = 'Subregion not found: {}, country: {}'.format(row.subregion, row.iso)
        elif len(subregion) == 1:
            data.at[index, 'subregion'] = subregion.code.item()
        elif not recursive:
            assign(subregion[subregion.parent.str.startswith(country.alpha2.item())], True)
        else:
            message = 'Duplicate regions found for: {}, country: {}'.format(row.subregion, row.iso)
        return message

    # Load the relevant data
    data = pd.read_csv(clean_filename)
    iso_world = pd.read_csv(ISO_6166_1)
    iso_region = pd.read_csv(ISO_6166_2)
    
    # Set the working variables, then start processing the data
    errors, rows = [], len(data.index)
    for index, row in data.iterrows():
    
        # Match the country, then match the region. Use the assign function to actually make the assignment.
        country = iso_world[iso_world.alpha3 == row.iso]
        message = assign(iso_region[iso_region.name == row.subregion])

        # Deal with any errors in matching
        if message != None and message not in errors:
            print(message)
            with open(ERRORS_LOG, 'a') as out:
                out.write(message + '\n')
            errors.append(message)
            message = None

        # Update the ISO code
        data.at[index, 'iso'] = country.numeric.item()

        # Let the user know we didn't crash 
        if index % 10000 == 0:
            print('Progress: {}%'.format(round((index / rows) * 100.0, 2)))

    # Save any errors to the temp directory
    if len(errors) != 0:
        print('Errors saved to {}'.format(ERRORS_LOG))

    # Save the data to our working directory
    data.to_csv('out/coded.csv', index=False)
    return 'out/coded.csv'


def map_regions(filename):
    data = pd.read_csv(filename)
    iso_codes = pd.read_csv(ISO_6166_1)

    # Note the unique regions
    mapping = {}
    for region in data.region.unique():
        mapping[region] = []

    # Map the country ISO codes to the regions
    for _, row in data.iterrows():
        iso3 = iso_codes[iso_codes.alpha3 == row.iso.lower()].id.item()
        if iso3 not in mapping[row.region]:
            mapping[row.region].append(iso3)

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

    # Remove existing errors
    if os.path.isfile(ERRORS_LOG):
        os.remove(ERRORS_LOG)

    # Get or refresh the data as needed
    if not os.path.isfile(ANALYSIS_DATA) or refresh:
        print('Downloading data file...', end='', flush=True)
        urllib.request.urlretrieve(ANALYSIS_URL, ANALYSIS_DATA)
        print('done!')
    if not os.path.isfile(ISO_6166_1) or refresh:
        get_iso(1)
    if not os.path.isfile(ISO_6166_2) or refresh:
        get_iso(2)

    # Map the regions
    if not os.path.isfile(REGION_MAPPING):
        print('Mapping regions...')
        mapping = map_regions('data/mapping.csv')
        print('Mapped data saved as: ', mapping)
    
    # Prepare the coded data file
    print('Processing data file...')
    # clean = clean_results(ANALYSIS_DATA)
    coded = map_iso('temp/clean.csv', 'data/mapping.csv')
    print('Cleaned and mapped results saved as: ', coded)


if __name__ == '__main__':
    main()
