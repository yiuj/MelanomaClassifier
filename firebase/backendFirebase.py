import pyrebase
import uuid

config = {
    "apiKey": "AIzaSyAV0TvyJyabGoebULn3DYv4NzvFsSwt4oo",
    "authDomain": "skincheck-6d167.firebaseapp.com",
    "databaseURL": "https://skincheck-6d167.firebaseio.com/",
    "storageBucket": "skincheck-6d167.appspot.com",
    "serviceAccount": "skincheck-6d167-firebase-adminsdk-46vox-c1bc950c21.json"
}

firebase = pyrebase.initialize_app(config)

storage = firebase.storage()
db = firebase.database()

urlset = set()

# From backend to firebase
def send_results(strID, strResults):
    data = {"id": strID, "results": strResults}
    db.child("kevins").child(strID).set(data)
    

def stream_handler(message):
    urls = db.child("urls").get()
    for urlItem in urls.each():
        url = urlItem.val()["url"]
        s = set()
        s.add(url)
        if(not s.issubset(urlset)):
            urlset.update(s)
            # DO STUFF WITH URL HERE
            print(url)
            # SEND RESULTS WITH send_results

# Listens for changes in URL bucket
def urlListener():
    my_stream = db.child("urls").stream(stream_handler)

# upload_image("sausage.jpg")
send_results("randomID", "M75%")
urlListener()