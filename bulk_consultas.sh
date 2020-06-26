
POST _search
{
  "query": {
    "match_all": {}
  }
}

DELETE 911

# ["lat","lng","desc","zip","title","timeStamp","twp","addr","e"]

PUT /911
{
  "mappings": {
    "properties": {
      "timeStamp":{"type":"date"},
      "location": {"type":"geo_point"},
      "zip" : {"type":"integer"},
      "title" : {
        "type":"text",
        "fields": { "title_keyword": {"type":"keyword"}}
      },
      "ems_categ" : {
        "type" : "text",
        "fields": { "ems_categ_keyword": {"type":"keyword"}}
      },
      "ems_desc" : {
        "type" : "text",
        "fields": { "ems_desc_keyword": {"type":"keyword"}}
      },
      "twp" : {"type":"text"},
      "addr" : {"type":"text"}

    }
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
      "zip" : {"type":"integer"},
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

# Insertar un documento desde kibana

POST 911/_doc/
{
    "lat": 40.1211818, 
    "lng": -75.3519752, 
    "desc": "HAWS AVE; NORRISTOWN; 2015-12-10 @ 14:39:21-Station:STA27;", 
    "zip": "19401", 
    "title": "Fire: GAS-ODOR/LEAK", 
    "timeStamp": "2015-12-10", 
    "twp": "NORRISTOWN", 
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

# Algunas consultas más elaboradas

# Por ejemplo filtrar por zipcode y ordenar por fecha:

POST 911/_search
{
   "from":0,"size":1000,
  "query": {
    "bool": {
      "should": [
        {"match": {"title.english": "pain"}},
        {"match": {"title.english": "abdominal"}}
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range" : {"zip" : {"gte" : 19446, "lte" : 19525}}}
      ]
    }
  },
  "sort":[
    {"timeStamp":"asc"}
  ],
  "_source": {
    "includes": ["title", "zip", "timeStamp"]
    
  }
}

# Por ejemplo filtrar por fecha:

POST 911/_search
{
   "from":0,"size":1000,
  "query": {
    "bool": {
      "should": [
        {"match": {"title.english": "Fires"}}
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range": { "timeStamp": { "gte": "2015-12-01", "lte": "2016-11-01"}}}
      ]
    }
  },
  "sort":[
    {"timeStamp":"asc"}
  ],
  "_source": {
    "includes": ["title", "zip", "timeStamp"]
    
  }
}

# Consultas con Boost que dan más importacia a cierto match, quitar sort para tener valor de score y luego ordenar por score

POST 911/_search
{
   "from":0,"size":1000,
  "query": {
    "bool": {
      "should": [
        {"match": {"title.english": "EMS"}},
        {"match": {"title.english": { "query" : "Fires", "boost": 2}}}
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range": { "timeStamp": { "gte": "2015-12-01", "lte": "2016-11-01"}}}
      ]
    }
  },
 
  "_source": {
    "includes": ["title", "zip", "timeStamp"]
    
  }
}

# Usar mismo filtro sobre diferentes campos o el mismo campo con diferentes procesamientos

POST 911/_search
{
   "from":0,"size":1000,
  "query": {
    "bool": {
      "should": [
        {"match": {"title.english":  { "query" : "Fires", "boost": 2}}},
        {"match": {"title.raw": {"query" : "Fires"}}}
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range": { "timeStamp": { "gte": "2015-12-01", "lte": "2016-11-01"}}}
      ]
    }
  },
 
  "_source": {
    "includes": ["title", "zip", "timeStamp"]
  }
}

# Multimatch, otra forma de buscar en varios campos un mismo patrón:

POST 911/_search
{
  "from":0,"size":1000,
  "query": {
    "multi_match": {
      "query": "fires",
      "fields": ["title.english", "title.normalized"]
    }
  },
  "_source": {
    "includes": ["title", "zip", "timeStamp"]
  }
}

# AGREGACIONES:

# Ejemplo: recuento por zipcode y title.normalize
# Si pones size 0, no devuelve los docs, solo los recuentos

POST 911/_search
{
  "size" : 0,
  "aggregations" : {
    "zip" : {"terms" : {"field": "zip"}},
    "title" : {"terms" : {"field": "title.normalized"}}
  }
}

# NUBE DE PALABRAS:

POST 911/_search
{
  "size" : 0,
  "aggregations" : {
    "Plot TagCloud" : {"terms" : {"field": "title.normalized"}}
  }
}

# VER VIDEO CUANDO LO SUBA
# MANDAR CORREO CON MIEMBROS DEL EQUIPO Y PLANTEMIENTO DE LA PRÁCTICA

# QUERY COMPLEJA

POST 911/_search
{
  "from": 0, "size": 5,
  "query": {
    "bool": {
      "should": [
        {
          "multi_match": {
            "query": "pain",
            "fields": ["title", "title.english"]
          }
        },
        {
          "multi_match" : {
            "query": "ems",
            "fields": ["title", "title.english"]
          }
        }
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range": { "timeStamp": { "gte": "2015-12-01", "lte": "2016-11-01"}}},
        {"bool" : {"must_not" : {"match" : {"title.english" : "accident" }}}}
      ]
    }
  }
}

# MATCH + FILTER + SORT + AGGREGATION

POST 911/_search
{
  "size": 0,
  "query": {
    "bool": {
      "should": [
        {
          "multi_match": {
            "query": "pain",
            "fields": ["title", "title.english"]
          }
        },
        {
          "multi_match" : {
            "query": "ems",
            "fields": ["title", "title.english"]
          }
        }
      ],
      "minimum_should_match": 1,
      "filter": [
        {"term": {"e": "1"}},
        {"range": { "timeStamp": { "gte": "2015-12-01", "lte": "2016-11-01"}}},
        {"bool" : {"must_not" : {"match" : {"title.english" : "accident" }}}}
      ]
    }
  },
  "sort":[
  {"timeStamp":"asc"}
  ],
  
  "aggregations" : {
    "zip" : {"terms" : {"field": "zip"}},
    "title" : {"terms" : {"field": "title.normalized"}}
  }
}












