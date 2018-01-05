import matplotlib.pyplot as plt
from PIL import Image

# paste img1 on top of img2
png = Image.open('stinkbug.png')  # opens the file using Pillow - it's not an array yet
background = Image.new('RGBA', size=png.size)
background.paste(png)
forground = Image.open('box.png')
layer  = Image.new('RGBA', size=png.size)
layer.paste(forground, box=(0, 0))

result = Image.alpha_composite(background, layer)
'''
newimg1.paste(img2, shift)
newimg1.paste(img1, (0, 0))

# paste img2 on top of img1
newimg2 = Image.new('RGBA', size=(nw, nh), color=(0, 0, 0, 0))
newimg2.paste(img1, (0, 0))
newimg2.paste(img2, shift)

# blend with alpha=0.5
result = Image.blend(newimg1, newimg2, alpha=0.5)


background = Image.open('stinkbug.png')  # opens the file using Pillow - it's not an array yet
overlay = Image.open('box.png')
# background = background.convert("RGBA")
# overlay = overlay.convert("RGBA")
# new_img = Image.blend(background, overlay, 0.5)
new_img = background.paste(overlay, (0,0))
# new_img.save("new.png","PNG")
'''
imgplot = plt.imshow(result)
plt.show()
