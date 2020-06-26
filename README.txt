
Los pasos que se deben seguir para reproducir, la carga de datos con Logstash, las consultas con Elastic y las visualizaciones con Kibana, son las siguientes:

1. Modificar el fichero logstash en la línea del path, a la ruta donde esté el fichero de datos:

input {
    file {
        path => "[PATH_HASTA_FIHERO_911.CSV]/911.csv"
	    start_position => beginning
	    sincedb_path => "NUL"
    }
}

2. Inicializar el índice desde Dev Tools de Kibana y crear un mapping para el campo location:


PUT /911
{
  "mappings": {
    "properties": {
      "location" : {"type":"geo_point"}
    }
  }
}

3. Realizar la ingesta de datos desde la carpeta de Logstash indicando la ruta hasta el fichero logstash911.conf:

C:\logstash-7.6.2> bin\logstash -f [PATH_HASTA_EL_FICHERO_CONFIG]\logstash911.conf

4. Realizar las consultas desde Dev Tools de Kibana, el código de dichas consultas se adjunta en el fichero Consultas911.txt.

5. Se crea el índice de kibana a través del índice ya cargado en Elastic:
	-Se selecciona la opción "I don’t want to use the Time Filter".
	-Se edita el campo Date para que tenga la forma YYYY-MM-DD.

6. Importar el fichero export.ndjson, asociar al índice 911 creado y abrir el item 911_Dashboard.