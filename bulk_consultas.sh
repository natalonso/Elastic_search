
#######################
# CARGAR DATOS
#######################

# Cargar incollections directamente sin mapping:

curl -s -XPOST "localhost:9200/incollections/_bulk" -H "Content-Type: application/json" --data-binary "@C:\Users\natal\PycharmProjects\Recuperacion_info\incollections_simplif.json"

# Cargar json 911 con el mapping ya creado:

curl -s -XPOST "localhost:9200/_bulk" -H "Content-Type: application/json" --data-binary "@911_simplif_sin_index.json"; echo


#######################
# CONSULTAS
#######################


POST incollections/_search

DELETE 911

POST _search
{
  "query": {
    "match_all": {}
  }
}

PUT /911
{
  "mappings": {
    "properties": {
      "lat" : {"type":"float"},
      "lng" : {"type":"float"},
      "desc" : {"type":"text"},
      "zip" : {"type":"text"},
      "title" : {"type":"text"},
      "timeStamp" : {"type":"date"},
      "twp" : {"type":"text"},
      "addr" : {"type":"text"},
      "e" : {"type":"text"}
    }
  }
}

POST 911/_doc/
{
    "lat": 40.1211818,
    "lng": -75.3519752,
    "desc": "HAWS AVE; NORRISTOWN; 2015-12-10 @ 14:39:21-Station:STA27;",
    "zip": "19401", "title": "Fire: GAS-ODOR/LEAK",
    "timeStamp": "2015-12-10", "twp": "NORRISTOWN",
    "addr": "HAWS AVE",
    "e": "1"
}


POST 911/_search
{
  "query": {
    "match_all": {}
  }
}

POST 911/_search
{
  "from":0,"size":100,
  "query": {
    "match_all": {}
  },
  "_source": {
    "includes": ["title"]

  }
}

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match_all": {}
  },
  "sort":[
    {"timeStamp":"desc"}
  ],
  "_source": {
    "includes": ["lat", "timeStamp"]

  }
}

# title.keyword para ordenar

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match_all": {}
  },
  "sort":[
    {"timeStamp":"asc"},
    {"title.keyword":"asc"}
  ],
  "_source": {
    "includes": ["title", "timeStamp"]

  }
}

# title.keyword para filtrar tienes que poner el título entero tal cual

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title.keyword":"EMS: ABDOMINAL PAINS"}
  },
  "sort":[
    {"timeStamp":"asc"},
    {"title.keyword":"asc"}
  ],
  "_source": {
    "includes": ["title", "timeStamp"]

  }
}

# title para filtrar puedes usar una palabra y mayus o minus

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title":"abdominal"}
  },
  "sort":[
    {"timeStamp":"asc"},
    {"title.keyword":"asc"}
  ],
  "_source": {
    "includes": ["title", "timeStamp"]

  }
}





