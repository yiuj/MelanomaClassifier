import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
import urllib
import json

cred = credentials.Certificate('skincheck-6d167-firebase-adminsdk-46vox-c1bc950c21.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'skincheck-6d167.appspot.com'
})

bucket = storage.bucket()

print("finished authentication")

def upload_file():

    my_file = open("sausage.jpg", "rb")
    my_bytes = my_file.read()
    my_url = "https://firebasestorage.googleapis.com/v0/b/skincheck-6d167.appspot.com/o/images%2Fsausage.jpg"
    my_headers = {"Content-Type": "text/plain"}

    my_request = urllib.request.Request(my_url, data=my_bytes, headers=my_headers, method="POST")

    try:
        loader = urllib.request.urlopen(my_request)
    except urllib.error.URLError as e:
        message = json.loads(e.read())
        print(message["error"]["message"])
    else:
        print(loader.read())

print("uploading file")
upload_file()