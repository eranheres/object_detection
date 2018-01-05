import argparse
from PIL import Image
import json
import random
import os

BASE_FILENAME = 'image'
ITEMS_DICT_FILENAME = 'dict.txt'

def create_image(background_filename, foreground_filename, box, output_filename):
    bgnd_png = Image.open(background_filename)
    background = Image.new('RGBA', size=bgnd_png.size)
    background.paste(bgnd_png)
    fgnd_png = Image.open(foreground_filename)
    layer = Image.new('RGBA', size=bgnd_png.size)
    layer.paste(fgnd_png, box=(box[:2]))
    result = Image.alpha_composite(background, layer)
    jpg = Image.new('RGB', size=result.size)
    jpg.paste(result)
    jpg.save(output_filename, "JPEG")


def build_images(background_filename, foreground_filename, amount, destpath):
    img_size = Image.open(foreground_filename).size
    bg_size = Image.open(background_filename).size
    items_dict = {}
    for i in range(amount):
        xpos = random.randint(0, bg_size[0]-img_size[0])
        ypos = random.randint(0, bg_size[1]-img_size[1])

        box = (xpos, ypos, xpos+img_size[0], ypos+img_size[1])
        output_filename = os.path.join(destpath, BASE_FILENAME+"_{}.jpeg".format(i))
        create_image(background_filename, foreground_filename, box, output_filename)
        items_dict[output_filename] = {'size': bg_size, 'box': box}
    with open(os.path.join(destpath, ITEMS_DICT_FILENAME), 'w') as outfile:
        json.dump(items_dict, outfile)


parser = argparse.ArgumentParser()
parser.add_argument('--background', dest='background', required=True)
parser.add_argument('--foreground', dest='foreground', required=True)
parser.add_argument('--amount', dest='amount', required=True, type=int)
parser.add_argument('--destpath', dest='destpath', required=True)

if __name__ == '__main__':
    args = parser.parse_args()
    background_filename = args.background
    foreground_filename = args.foreground
    amount = args.amount
    destpath = args.destpath
    build_images(background_filename, foreground_filename, amount, destpath)


