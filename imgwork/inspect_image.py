import argparse
from PIL import Image
from PIL import ImageDraw
import json

parser = argparse.ArgumentParser()
parser.add_argument('--image', dest='image', required=True)
parser.add_argument('--dict', dest='dict')

def show_image(image_filename, dict_filename):
    dict = json.load(open(dict_filename))
    img = Image.open(image_filename)
    draw = ImageDraw.Draw(img)
    box = dict[image_filename]['box']
    draw.rectangle(box, outline=(255, 0, 0, 128))
    img.show()


if __name__ == '__main__':
    args = parser.parse_args()
    image_filename = args.image
    dict_filename = args.dict
    show_image(image_filename, dict_filename)


