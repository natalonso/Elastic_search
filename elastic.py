# -*- coding: utf-8 -*-

import json

f = open('./incollections.json', encoding='utf-8')
incollections = json.load(f)

f3 = open('./incollections_simplif.json', 'w', encoding='utf-8')

c=0
for item in incollections:
    if c<10:
        f3.write(str({"index": {"_index": "incollections", "_type": "incollections"}}) + "\n")
        f3.write(str(item) + "\n")
        c=c+1



