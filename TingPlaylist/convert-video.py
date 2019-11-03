#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Author: Glaukon Ariston
# Date: 31.10.2019
# Abstract:
#	Extract audio form video files, making sure the directory structure stays the same.
#
#	The video files must be in the 'raw' folder.
#	The converted files will be saved in the 'converted' folder, replicating the directory structure of the source video.
#
#    Usage:
#         python convert-video.py

import argparse
import subprocess
import os, os.path, fnmatch, time, datetime, string, re, time

ROOT = 'C:/Temp/Frederick Noad'
#ROOT = os.path.dirname(os.path.realpath(__file__))
RAW = ROOT + '/raw'
CONVERTED = ROOT + '/converted'
TEMP = ROOT + '/tmp'
LOG = ROOT + '/log'
VIDEO_FILE_FILTER = re.compile(r'.+\.(avi|mts|m2ts|m2t|mp4|mov|mkv|webm|m4a)$', re.IGNORECASE)
OUTPUT_EXTENSION = '.mp3'
FFMPEG = 'ffmpeg.exe'
FFMPEG_PARAMS = '-y -i "%s" -vn -ab 128 "%s"'


def timestamp():
	#FORMAT = '%Y-%m-%d %H:%M:%S'
	FORMAT = '%H:%M:%S'
	ts = time.time()
	return datetime.datetime.fromtimestamp(ts).strftime(FORMAT)


def converted_path(root, relpath):
	head, ext = os.path.splitext(os.path.join(root, relpath))
	return head + OUTPUT_EXTENSION


def convert_video_file(relpath, source, dest):
	head_path, filename = os.path.split(relpath)
	dest_dir = os.path.join(dest, head_path)
	if not os.path.isdir(dest_dir):
		os.makedirs(dest_dir)

	name, ext = os.path.splitext(filename)
	dest_filename = name + OUTPUT_EXTENSION

	src_file = os.path.normpath(os.path.join(source, relpath))
	dest_file = os.path.normpath(converted_path(dest, relpath))
	tmp_file = os.path.normpath(os.path.join(TEMP, dest_filename))
	#print('Converting %s to %s' % (src_file, dest_file))
	retcode = subprocess.call('%s %s' % (FFMPEG, FFMPEG_PARAMS % (src_file, tmp_file)))
	if retcode != 0:
		raise Exception('FFMPEG', retcode)
	os.rename(tmp_file, dest_file)


def walk_the_tree(source, dest):
	matches = []
	for root, dirnames, filenames in os.walk(source):
		matches.extend(os.path.relpath(os.path.join(root, name), source) for name in filenames if VIDEO_FILE_FILTER.match(name))
	print('Matched %d files.' % len(matches))
	missing = [relpath for relpath in matches if not os.path.isfile(converted_path(dest, relpath))]
	print('%d files missing.' % len(missing))
	print('About to process %d files...' % len(missing))
	i = 1
	for f in missing:
		print('%s %d/%d %s' % (timestamp(), i, len(missing), f))
		convert_video_file(f, source, dest)
		i = i + 1

	#mtime = os.path.getmtime(filepath)
	#size = os.path.getsize(filepath)


def main():
	print('Video converter started.')
	if not os.path.isdir(TEMP):
		os.makedirs(TEMP)
	walk_the_tree(RAW, CONVERTED)
	print('Done.')


if __name__ == "__main__":
	main()
