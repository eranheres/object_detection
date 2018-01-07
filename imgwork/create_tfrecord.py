import tensorflow as tf
from object_detection.utils import dataset_util
import json

flags = tf.app.flags
flags.DEFINE_string('output_path', '', 'Path to output TFRecord')
flags.DEFINE_string('dict_path', '', 'Path to dict file')
FLAGS = flags.FLAGS

BOX_ID = 1

def create_tf_example(image_path, item):
    size = item['size']
    box = item['box']

    width = size[0]   # Image width
    height = size[1]  # Image height
    filename = str(image_path)     # Filename of the image. Empty if image is not from file
    with tf.gfile.GFile(image_path, 'rb') as fid:
        encoded_image_data = fid.read()  # Encoded image bytes
    image_format = b'jpeg'    # b'jpeg' or b'png'

    xmins = [box[0]/float(width)]  # List of normalized left x coordinates in bounding box (1 per box)
    xmaxs = [box[2]/float(width)]  # List of normalized right x coordinates in bounding box
    # (1 per box)
    ymins = [box[1]/float(height)]  # List of normalized top y coordinates in bounding box (1 per box)
    ymaxs = [box[3]/float(height)]  # List of normalized bottom y coordinates in bounding box
    # (1 per box)
    classes_text = ['Abyssinian']  # List of string class name of bounding box (1 per box)
    classes = [BOX_ID]  # List of integer class id of bounding box (1 per box)

    tf_label_and_data = tf.train.Example(features=tf.train.Features(feature={
        'image/height': dataset_util.int64_feature(height),
        'image/width': dataset_util.int64_feature(width),
        'image/filename': dataset_util.bytes_feature(filename),
        'image/source_id': dataset_util.bytes_feature(filename),
        'image/encoded': dataset_util.bytes_feature(encoded_image_data),
        'image/format': dataset_util.bytes_feature(image_format),
        'image/object/bbox/xmin': dataset_util.float_list_feature(xmins),
        'image/object/bbox/xmax': dataset_util.float_list_feature(xmaxs),
        'image/object/bbox/ymin': dataset_util.float_list_feature(ymins),
        'image/object/bbox/ymax': dataset_util.float_list_feature(ymaxs),
        'image/object/class/text': dataset_util.bytes_list_feature(classes_text),
        'image/object/class/label': dataset_util.int64_list_feature(classes),
    }))
    return tf_label_and_data


def main(_):
    writer = tf.python_io.TFRecordWriter(FLAGS.output_path)

    dict = json.load(open(FLAGS.dict_path))

    for item_key in dict:
        tf_example = create_tf_example(item_key, dict[item_key])
        writer.write(tf_example.SerializeToString())

    writer.close()


if __name__ == '__main__':
    tf.app.run()
