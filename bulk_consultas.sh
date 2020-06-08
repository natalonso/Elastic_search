
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

# RELLENAR SINÓNIMOS:

PUT /911
{
  "settings": {
    "index":{
      "analysis":{
        "filter":{
          "english_stop": {
            "type":"stop",
            "stopwords" : "_english_"
          },
          "english_stemmer":{
            "type": "stemmer",
            "language": "english"
          },
          "english_synonyms":{
            "type":"synonym",
            "synonyms" : ["eee, jik"]
          }
        },
        "normalizer":{
          "lowercase":{"type": "custom", "filter": ["lowercase"]}
        },
        "analyzer":{
          "lowercase":{
            "tokenizer":"keyword",
            "filter":["lowercase"]
          },
          "english":{
            "tokenizer" : "standard",
            "filter" : [
              "lowercase",
              "english_stop",
              "english_stemmer"
            ]
          },
          "english_with_synonyms" : {
            "tokenizer" : "standard",
            "filter" : [
              "lowercase",
              "english_stop",
              "english_synonyms",
              "english_stemmer"
            ]
          }
        }
      }
    }
  },

  "mappings": {
    "properties": {
      "lat" : {"type":"float"},
      "lng" : {"type":"float"},
      "desc" : {"type":"text"},
      "zip" : {"type":"text"},
      "title" : {
        "type":"text",
        "fields": {
          "english" : {
            "type" : "text",
            "analyzer" : "english",
            "search_analyzer":"english_with_synonyms"
          },
          "normalized" : {
            "type":"keyword",
            "normalizer" : "lowercase"
          },
          "raw" : {"type" : "keyword"}
        }
      },
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
    "match": {"title":"EMS: ABDOMINAL PAINS"}
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
# si ordenas: score: null

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

# al quitar la ordenacion, te pone score (TF/TFI)

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title":"abdominal"}
  },
  "_source": {
    "includes": ["title", "timeStamp"]

  }
}

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "bool": {
      "filter" : {"match": {"title" : "abdominal"}}
    }
  },

  "_source": {
    "includes": ["title", "timeStamp"]

  }
}

# Por defecto hace OR
POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title.english": "ems abdominal pains"}
  },
  "_source": {
    "includes": ["title"]

  }
}

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title.normalized": "ems: SUBJECT in Pain"}
  },
  "_source": {
    "includes": ["title"]

  }
}


POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title.raw": "EMS: SUBJECT IN PAIN"}
  },
  "_source": {
    "includes": ["title"]

  }
}


POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {
      "title.english": {
        "query" : "ems pain",
        "operator": "and"
      }
    }
  },
  "_source": {
    "includes": ["title"]

  }
}


POST 911/_analyze
{
  "field": "title.english",
  "text" : "Ems: abdominal in PAIN",
  "explain": true
}


POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "match": {"title.english": "abdomin"}
  },
  "_source": {
    "includes": ["title"]

  }
}



# VER VIDEO CUANDO LO SUBA
# MANDAR CORREO CON MIEMBROS DEL EQUIPO Y PLANTEMIENTO DE LA PRÁCTICA

