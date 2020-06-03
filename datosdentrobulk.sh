

curl -s -XPOST 'localhost:9200/dbpl/_bulk' -H "Content-Type: application/json" --data-binary "@C:\Users\natal\PycharmProjects\Recuperacion_info\elastic.json"

curl -XPUT 'localhost:9200/dbpl' -H 'Content-Type: application/json'


