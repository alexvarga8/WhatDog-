import turicreate
import os

data = turicreate.image_analysis.load_images("images/")

data["label"] = data["path"].apply(lambda path: os.path.basename(os.path.dirname(path)))

data.save("dog_classifier.sframe")

data = turicreate.SFrame("dog_classifier.sframe")

testing, training = data.random_split(0.8)

classifier = turicreate.image_classifier.create(testing, target="label", model="resnet-50")

testing = classifier.evaluate(training)
print testing["accuracy"]

classifier.save("dog_classifier.model")
classifier.export_coreml("dog_classifier.mlmodel")
