import datetime 
import requests 

host="http://earth.lan:5001"

now = datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%S.%fZ")


requests.post(host+'/api/electricity', json={'value': 0, 'read_on': now})
requests.post(host+'/api/gas', json={'value': 0, 'read_on': now})
