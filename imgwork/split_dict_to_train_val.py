import argparse
import json
import random
import os

parser = argparse.ArgumentParser()
parser.add_argument('--dict', dest='dict')
parser.add_argument('--destpath', dest='destpath')
parser.add_argument('--ratio', dest='ratio', type=int)


def split_dict(dict_filename, destpath, ratio):
    dict = json.load(open(dict_filename))
    sample = random.sample(list(dict.keys()), (len(dict) * ratio) / 100)
    grp_a = {}
    grp_b = {}
    for v in dict:
        if v in sample:
            grp_a[v] = dict[v]
        else:
            grp_b[v] = dict[v]
    with open(os.path.join(destpath, "train.txt"), 'w') as outfile:
        json.dump(grp_b, outfile)
    with open(os.path.join(destpath, "eval.txt"), 'w') as outfile:
        json.dump(grp_b, outfile)


if __name__ == '__main__':
    args = parser.parse_args()
    dict = args.dict
    destpath = args.destpath
    ratio = args.ratio
    split_dict(dict, destpath, ratio)
