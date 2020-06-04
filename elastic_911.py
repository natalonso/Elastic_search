# -*- coding: utf-8 -*-

import json
import csv
from datetime import datetime

f_read = open('./911.csv', encoding='utf-8')
reader = csv.DictReader(f_read)
f_write = open('./911_simplif.json', 'w', encoding='utf-8')
f_write_sin_index = open('./911_simplif_sin_index.json', 'w', encoding='utf-8')

contador = 0
for raw in reader:
    if contador < 1000:
        contador = contador + 1

        # '%Y-%m-%d %H:%M:%S'
        raw['timeStamp'] = raw['timeStamp'].split(' ')[0]

        raw['lat'] = float(raw['lat'])
        raw['lng'] = float(raw['lng'])

        index = str({"index": {"_index": "911", "_type": "911"}}).replace("'", '"')
        f_write.write(index + "\n")

        raw_dict = dict(raw)
        raw_dict = str(raw_dict).replace("'", '"')
        f_write.write(raw_dict + "\n")

        index = str({'index': {"_index": "911"}}).replace("'", '"')
        f_write_sin_index.write(index + "\n")
        f_write_sin_index.write(raw_dict + "\n")



