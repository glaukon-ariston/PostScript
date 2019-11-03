#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Author: Glaukon Ariston
# Date: 20.05.2019
# Abstract:
#
import glob
import os.path
import codecs
import re
import pickle
import datetime
import yaml
import pprint
import subprocess
import shlex


GhostScript = 'gswin64c'
rootDir = 'C:\\app\\dev\\hp\\projects\\github\\ting-reveng\\books\\'
#rootDir = 'C:\\boris\\app\\dev\\hp\\projects\\github\\ting-reveng\\books\\'
#yamlFile = rootDir + Glazbena petica_TextBook.yaml'
yamlFile = rootDir + 'Bullhit.yaml'
#yamlFile = rootDir + 'Frederick Noad_Solo Guitar Playing 1.yaml'


def postscriptStringEscape(s):
    return s.replace('\\', '\\\\')


def pythonToPostscript(obj, indent=4):
    if type(obj) is int:
        return '%d' % obj
    if type(obj) is float:
        return '%f' % obj
    if type(obj) is str:
        return '(%s)' % postscriptStringEscape(obj)
    if type(obj) is list:
        inter = '\n'+' '*indent
        final = '\n'+' '*(indent-4)
        return '[%s%s%s]' % (inter, inter.join(pythonToPostscript(x, indent+4) for x in obj), final)
    if type(obj) is dict:
        inter = '\n'+' '*indent
        final = '\n'+' '*(indent-4)
        return '<<%s%s%s>>' % (inter, inter.join('/%s %s' % (key, pythonToPostscript(val, indent+4)) for key, val in obj.items() ), final)
    assert False


def toPostscript(yamlFile):
    with codecs.open(yamlFile, 'rb', 'utf-8') as f:
        # use safe_load instead load
        dataMap = yaml.safe_load(f)
        pp = pprint.PrettyPrinter(indent=4)
        pp.pprint(dataMap)
        return pythonToPostscript(dataMap)


def main():
    postscript = toPostscript(yamlFile)
    print(postscript)
    filename = os.path.basename(yamlFile)
    (basename,ext) = os.path.splitext(filename)
    psFile = basename+'.ps'
    with codecs.open(psFile, 'wb', 'windows-1250') as ps:
        ps.write(postscript)
    # gswin64c -dstartTingId=%1 -dperiodTingId=%2 -dLabelWidth=20.3 -dLabelHeight=10 @ps2pdf-oid.opt -sOutputFile#oids/tingid-%1-%2.pdf -fgenerateContactSheet.ps
    cmd = '''%s -sinputYaml="%s.ps" @ps2pdf.opt -sOutputFile="pdf/%s.pdf" -ftingPlaylist.ps''' % (GhostScript, basename, basename)
    print(cmd)
    subprocess.check_call(shlex.split(cmd))


if __name__ == "__main__":
    main()

