from fastapi import FastAPI, UploadFile, File
import shutil
import uvicorn
import cv2

app = FastAPI()


@app.post("/requestvaluation")
async def root(image: UploadFile = File(...)):
    print("hello here evaluation")

    with (open("../" + image.filename, "wb")) as buffer:
        shutil.copyfileobj(image.file, buffer)
    img = cv2.imread("../" + image.filename)
    # gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    cascade = cv2.CascadeClassifier("/code/./app/cascade.xml")

    faces = cascade.detectMultiScale3(img,
                                           scaleFactor=1.1,
                                           minNeighbors=9,
                                           flags=cv2.CASCADE_SCALE_IMAGE,
                                           outputRejectLevels=True)

    waste_rect = faces[0]
    weights = faces[2]

    if(len(weights) == 0):
        return {"message": "no found"}

    maxWeight = weights[0]
    for w in weights:
        if(w > maxWeight):
            maxWeight = w

    return {"message": str(maxWeight)}


@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}
