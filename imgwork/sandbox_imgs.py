import matplotlib.pyplot as plt
from PIL import Image
img = Image.open('/Users/eranh/Downloads/stinkbug.png')  # opens the file using Pillow - it's not an array yet
imgplot = plt.imshow(img)
plt.show()
