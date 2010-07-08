#!/usr/bin/python
import sys
import os

def databot(html, s):
    c = os.getcwd()
    files = os.listdir(c)
    for path in files:
        if os.path.isdir(path):
            os.chdir(path)
            databot(html, s+"/"+path)
            os.chdir("..")
        elif path.endswith("readme"):
            f = open(path)
            html.write("<pre>"+f.read()+"</pre>\n")
            f.close()
        elif path.endswith(".mat"):
            html.write("<h4>"+s+"/"+path+"</h4>\n")
        elif path.endswith(".png"):
            html.write("<img src=\""+s+"/"+path+"\" />\n")

html = open('summary.html', 'w')
html.write('<!DOCTYPE html><html><head><title>Summary of Results</title></head><body>\n')
databot(html, os.getcwd())
html.write('</body></html>\n')
html.close()
