import datetime
import requests
import re
from dateutil.parser import parse
from datetime import datetime
from pytz import timezone
import json
import sys

from datetime import datetime, timezone


# file = open('meter_log.txt', 'r')
#
#
# def utc_to_local(utc_dt):
#     return utc_dt.replace(tzinfo=timezone.utc).astimezone(tz=None)
#
#
# def local_to_utc(local_dt):
#     return local_dt.replace(tzinfo=None).astimezone(tz=timezone.utc)
#
#
# def parse_readout(input):
#     reader = input
#     result = {}
#
#     if not reader:
#         return []
#     else:
#         while len(reader) > 0 and not re.match(".*CEST", reader[0]):
#             first = reader[0]
#             if first.startswith("1-0:1.8.1"):
#                 match = re.search("\((\d+\.\d+)\*kWh\)", first)
#                 float_str = match.group(1)
#                 result['day_use'] = float_str
#
#             elif first.startswith("1-0:1.8.2"):
#                 match = re.search("\((\d+\.\d+)\*kWh\)", first)
#                 float_str = match.group(1)
#                 result['night_use'] = float_str
#
#             elif first.startswith("1-0:2.8.1"):
#                 match = re.search("\((\d+\.\d+)\*kWh\)", first)
#                 float_str = match.group(1)
#                 result['day_inject'] = float_str
#
#             elif first.startswith("1-0:2.8.2"):
#                 match = re.search("\((\d+\.\d+)\*kWh\)", first)
#                 float_str = match.group(1)
#                 result['night_inject'] = float_str
#
#             elif first.startswith("0-1:24.2.3"):
#                 match = re.search("\((\d+\.\d+)\*m3\)", first)
#                 float_str = match.group(1)
#                 result['gas'] = float_str
#
#             # Drop the processed line.
#             reader = reader[1:]
#
#         # Return remainder
#         return reader, result
#
#
# def parse_telegram(lines):
#     total = len(lines)
#     dicts = []
#     # Iterate entire file.
#     while len(lines) > 0:
#         sys.stdout.write("\rParing lines {}/{}                       ".format(total - len(lines), total))
#         first = lines[0]
#         if re.match(".*CEST", first):
#             r = local_to_utc(parse(first))
#             lines, dict = parse_readout(lines[1:])
#             dict['when'] = r
#             dicts.append(dict)
#         else:
#             lines = lines[1:]
#     print("")
#     return dicts
#
#
# lines = file.readlines()
#
# dicts = parse_telegram(lines)
# host="http://localhost:4000"
#
#
# def post_dict(dict):
#     gas = {'value': float(dict['gas']), 'read_on': dict['when']}
#     elec = {'value': float(dict['day_use']) + float(dict['night_use']), 'read_on': dict['when']}
#     solar = {'value': float(dict['day_inject']) + float(dict['night_inject']), 'read_on': dict['when']}
#     print(gas)
#     # requests.post(host + '/api/gas', json=gas)
#     # requests.post(host + '/api/electricity', json=elec)
#     # requests.post(host + '/api/solar', json=solar)
#
# for dict in dicts:
#     dict['when'] = dict['when'].strftime("%Y-%m-%dT%H:%M:%S.%fZ")
#     post_dict(dict)


###########
# Helpers #
###########

def clean_line(line):
    """
    Sanitizes input a bit before processing.
    :param line: The line.
    :return: Returns the stripped line.
    """
    return line.strip()


def local_to_utc(local_dt):
    return local_dt.replace(tzinfo=None).astimezone(tz=timezone.utc)


##############
# Predicates #
##############

def is_start_of_chunk(line):
    """
    Checks if the given line is a timestamp.
    :param line: The line.
    :return: True/False
    """
    return re.match(".*CEST", line)


def is_gas_reading(line):
    return line.startswith("0-1:24.2.3")


def is_day_elec_usage(line):
    return line.startswith("1-0:1.8.1")


def is_night_elec_usage(line):
    return line.startswith("1-0:1.8.2")


def is_day_elec_inject(line):
    return line.startswith("1-0:2.8.1")


def is_night_elec_inject(line):
    return line.startswith("1-0:2.8.2")


###########
# Parsers #
###########


def parse_start_of_chunk(line):
    return local_to_utc(parse(line))


def parse_gas_reading(line):
    return parse_line("\((\d+\.\d+)\*m3\)", line)


def parse_day_elec_usage(line):
    return parse_line("\((\d+\.\d+)\*kWh\)", line)


def parse_day_elec_inject(line):
    return parse_line("\((\d+\.\d+)\*kWh\)", line)


def parse_night_elec_inject(line):
    return parse_line("\((\d+\.\d+)\*kWh\)", line)


def parse_night_elec_usage(line):
    return parse_line("\((\d+\.\d+)\*kWh\)", line)


def parse_line(regex, line):
    match = re.search(regex, line)
    float_str = match.group(1)
    return float(float_str)


def parse_file(filename, proc):
    """
    Parses the file. Reads into measurement chunks and processes each chunk.
    :param filename: The filename to read.
    :return: Returns nothing.
    """
    chunks = []
    chunk = []
    with open(filename) as infile:

        for line in infile:
            line = clean_line(line)
            if is_start_of_chunk(line):
                if chunk != []:
                    chunks.append(chunk)
                    proc(chunk)
                chunk = []

            chunk.append(line)


def parse_chunk(lines):
    chunk = {}

    for line in lines:
        if is_day_elec_usage(line):
            chunk['day_elec_usage'] = parse_day_elec_usage(line)
        elif is_day_elec_inject(line):
            chunk['day_elec_inject'] = parse_day_elec_inject(line)
        elif is_night_elec_inject(line):
            chunk['night_elec_inject'] = parse_night_elec_inject(line)
        elif is_night_elec_usage(line):
            chunk['night_elec_usage'] = parse_night_elec_usage(line)
        elif is_start_of_chunk(line):
            chunk['timestamp'] = parse_start_of_chunk(line)
        elif is_gas_reading(line):
            chunk['gas'] = parse_gas_reading(line)
    return chunk


###############
# Post to API #
###############

endpoint = "http://localhost:4000"


def post_chunk(chunk):
    timestamp = chunk['timestamp'].strftime("%Y-%m-%dT%H:%M:%S.%fZ")
    gas = {'value': chunk['gas'], 'read_on': timestamp}
    requests.post(endpoint + '/api/gas', json=gas)

    elec = {'value': chunk['day_elec_usage'] + chunk['night_elec_usage'], 'read_on': timestamp}
    requests.post(endpoint + '/api/electricity', json=elec)

    solar = {'value': chunk['day_elec_inject'] + chunk['night_elec_inject'], 'read_on': timestamp}
    requests.post(endpoint + '/api/solar', json=solar)


########
# Main #
########

filename = sys.argv[1]
parse_file(filename, lambda chunk: post_chunk(parse_chunk(chunk)))
