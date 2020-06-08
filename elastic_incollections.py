# -*- coding: utf-8 -*-

import json

f_read = open('./incollections.json', encoding='utf-8')
incollections = json.load(f_read)

f_write = open('./incollections_simplif.json', 'w', encoding='utf-8')

c=0
for item in incollections:
    if c<10:
        f_write.write(str({"index": {"_index": "incollections", "_type": "incollections"}}).replace("'", '"') + "\n")

        f_write.write(str(item).replace("'", '"') + "\n")
        c=c+1

