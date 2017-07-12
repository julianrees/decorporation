#!/usr/bin/env python3

import sys
import math
import subprocess
import numpy as np

# check for correct number of inputs
if len(sys.argv) != 2:
    sys.exit("You must supply exactly one filename!")

# open filename
fname = str(sys.argv[1])
Group = []
Type = []
Sample = []
Source = []
with open(fname, "U") as f:
    linenum = 1
    for line in f:
        line = line.strip()
        content = line.split(",")
        if linenum == 1:
            headers = content
            print(headers)

        elif content[0] == "Background":
            Group.append("Background")
            Type.append("Background")
            Sample.append("Background")
            Source.append("Background")

        elif content[0] == "Standards":
            for i in range(0,int(content[2])):
                for j in range(0,int(content[4])):
                    for k in range(0,int(content[7])):
                        Group.append(content[3].split(";")[i])
                        Type.append("Standard")
                        Sample.append(content[6].split(";")[j])
                        Source.append("Aliquot%s" %(k+1))

        elif content[0] == "Urine":
            for i in range(0,int(content[2])):
                for j in range(0,int(content[4])):
                    for k in range(0,int(content[7])):
                        Group.append(content[6].split(";")[j])
                        Type.append("Excreta")
                        Sample.append("Urine")
                        Source.append(content[3].split(";")[i])

        elif content[0] == "Feces":
            for i in range(0,int(content[2])):
                for j in range(0,int(content[4])):
                    for k in range(0,int(content[7])):
                        Group.append(content[6].split(";")[j])
                        Type.append("Excreta")
                        Sample.append("Feces")
                        Source.append(content[3].split(";")[i])

        elif content[0] == "Organs":
            for i in range(0,int(content[2])):
                for j in range(0,int(content[4])):
                    for k in range(0,int(content[7])):
                        Group.append(content[6].split(";")[j])
                        Type.append("Mouse")
                        Sample.append("Organ")
                        Source.append(content[3].split(";")[i])

        linenum = linenum+1
print(len(Group))

samples = np.column_stack((Group, Type, Sample, Source))
print(samples)
np.savetxt("Data/ExpandedLSC.csv", samples, delimiter=",", fmt="%s")
