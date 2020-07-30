import datetime
import requests
import re
from dateutil.parser import parse
from datetime import datetime
from pytz import timezone
import json

from datetime import datetime, timezone

file = open('meter_log.txt', 'r')


def utc_to_local(utc_dt):
    return utc_dt.replace(tzinfo=timezone.utc).astimezone(tz=None)


def local_to_utc(local_dt):
    return local_dt.replace(tzinfo=None).astimezone(tz=timezone.utc)


def parse_readout(input):
    reader = input
    result = {}

    if not reader:
        return []
    else:
        while len(reader) > 0 and not re.match(".*CEST", reader[0]):
            first = reader[0]
            if first.startswith("1-0:1.8.1"):
                match = re.search("\((\d+\.\d+)\*kWh\)", first)
                float_str = match.group(1)
                result['day_use'] = float_str

            elif first.startswith("1-0:1.8.2"):
                match = re.search("\((\d+\.\d+)\*kWh\)", first)
                float_str = match.group(1)
                result['night_use'] = float_str

            elif first.startswith("1-0:2.8.1"):
                match = re.search("\((\d+\.\d+)\*kWh\)", first)
                float_str = match.group(1)
                result['day_inject'] = float_str

            elif first.startswith("1-0:2.8.2"):
                match = re.search("\((\d+\.\d+)\*kWh\)", first)
                float_str = match.group(1)
                result['night_inject'] = float_str

            elif first.startswith("0-1:24.2.3"):
                match = re.search("\((\d+\.\d+)\*m3\)", first)
                float_str = match.group(1)
                result['gas'] = float_str

            # Drop the processed line.
            reader = reader[1:]

        # Return remainder
        return reader, result


def parse_telegram(lines):
    dicts = []
    # Iterate entire file.
    while len(lines) > 0:
        first = lines[0]
        if re.match(".*CEST", first):
            r = local_to_utc(parse(first))
            lines, dict = parse_readout(lines[1:])
            dict['when'] = r
            dicts.append(dict)
        else:
            lines = lines[1:]

    return dicts


lines = file.readlines()

dicts = parse_telegram(lines)
host="http://localhost:4000"


def post_dict(dict):
    print(dict)
    gas = {'value': float(dict['gas']), 'read_on': dict['when']}
    elec = {'value': float(dict['day_use']) + float(dict['night_use']), 'read_on': dict['when']}
    solar = {'value': float(dict['day_inject']) + float(dict['night_inject']), 'read_on': dict['when']}
    print(json.dumps(gas))
    requests.post(host + '/api/gas', json=gas)
    requests.post(host + '/api/electricity', json=elec)
    requests.post(host + '/api/solar', json=solar)
    
for dict in dicts:
    dict['when'] = dict['when'].strftime("%Y-%m-%dT%H:%M:%S.%fZ")
    post_dict(dict)
