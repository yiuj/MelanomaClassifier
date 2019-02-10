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

#From app to firebase
def upload_image(pathToImage):
    #UPLOAD
    #first string is what it will be uploaded as
    #second is the local file to be uploaded
    newID = str(uuid.uuid4())
    storage.child("images/" + newID + ".jpg").put(pathToImage)

    url = storage.child("images/" + newID + ".jpg").get_url(None)

    data = {"url": url}
    db.child("urls").child(newID).set(data)
    # data = {"results": "75%"}
    # db.child("kevins").child(newID).set(data)
  

#From firebase to backend (kevin stuff)
def download_image(nameOfImage):
    #DOWNLOAD
    storage.child("images/" + nameOfImage + ".jpg").download(nameOfImage + ".jpg")

upload_image("sausage.jpg")