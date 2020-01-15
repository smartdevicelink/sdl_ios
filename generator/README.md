# Proxy Library RPC Generator

## Overview

This script provides the possibility to auto-generate iOS code based on a given SDL MOBILE_API XML specification.

## Requirements

The script requires Python 3.5 pre-installed in the system. This is the minimal Python 3 version that has not reached the end-of-life (https://devguide.python.org/devcycle/#end-of-life-branches).

Some required libraries are described in `requirements.txt` and should be pre-installed by the command:
```shell script
pip install -r requirements.txt
```
Please also make sure before usage the 'generator/rpc_spec' Git submodule is successfully initialized, because the script uses the XML parser provided there.

## Usage
```shell script
usage: runner.py [-h] [-v] [-xml SOURCE_XML] [-xsd SOURCE_XSD]
                 [-d OUTPUT_DIRECTORY] [-t [TEMPLATES_DIRECTORY]]
                 [-r REGEX_PATTERN] [--verbose] [-e] [-s] [-m] [-y] [-n]

Proxy Library RPC Generator

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         print the version and exit
  -xml SOURCE_XML, --source-xml SOURCE_XML, --input-file SOURCE_XML
                        should point to MOBILE_API.xml
  -xsd SOURCE_XSD, --source-xsd SOURCE_XSD
  -d OUTPUT_DIRECTORY, --output-directory OUTPUT_DIRECTORY
                        define the place where the generated output should be
                        placed
  -t [TEMPLATES_DIRECTORY], --templates-directory [TEMPLATES_DIRECTORY]
                        path to directory with templates
  -r REGEX_PATTERN, --regex-pattern REGEX_PATTERN
                        only elements matched with defined regex pattern will
                        be parsed and generated
  --verbose             display additional details like logs etc
  -e, --enums           only specified elements will be generated, if present
  -s, --structs         only specified elements will be generated, if present
  -m, -f, --functions   only specified elements will be generated, if present
  -y, --overwrite       force overwriting of existing files in output
                        directory, ignore confirmation message
  -n, --skip            skip overwriting of existing files in output
                        directory, ignore confirmation message
```
