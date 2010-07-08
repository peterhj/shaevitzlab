#!/usr/bin/python
import sys
import os
import time

def sortbydate(t):
    datefiles = []
    paths = []
    for path in t:
        stats = os.stat(path)
        lastmod = time.localtime(stats[8])
        datefile = lastmod, path
        datefiles.append(datefile)
    datefiles.sort()
    for entry in datefiles:
        paths.append(entry[1])
    return paths

def databot(html, s):
    files = os.listdir(os.getcwd())
    files = sortbydate(files)
    isimage = False
    parity = 0
    for path in files:
        if os.path.isdir(path):
            if isimage == True:
                html.write("</table>")
                isimage = False
            os.chdir(path)
            databot(html, s+"/"+path)
            os.chdir("..")
        elif path.endswith(".mat"):
            if isimage == True:
                html.write("</table>")
                isimage = False
            html.write("<h4>"+s+"/"+path+"</h4>\n")
        elif path.endswith("_readme.txt"):
            if isimage == True:
                html.write("</table>")
                isimage = False
            f = open(path)
            html.write("<pre>"+f.read()+"</pre>\n")
            f.close()
        elif path.startswith("overview"):
            if isimage == False:
                html.write("<table>")
                isimage = True
            html.write("<tr><td><img src=\""+s+"/"+path+"\" /></td></tr>\n")
        elif path.endswith(".png"):
            if isimage == False:
                html.write("<table>")
                isimage = True
            if parity == 0:
                html.write("<tr>")
            html.write("<td><img width=\"480\" height=\"360\" src=\""+s+"/"+path+"\" /></td>\n")
            if parity == 1:
                html.write("</tr>")
                parity = 0
            elif parity == 0:
                parity = 1

html = open("summary.html", "w")
html.write("<!DOCTYPE html><html><head>\n")
html.write("<style type=\"text/css\">\nimg {padding: 0; margin: 0;}\n</style>\n")
html.write("<title>Summary of Results</title></head><body>\n")
databot(html, os.getcwd())
html.write("</body></html>\n")
html.close()
