#!/usr/local/bin/python
# -----------------------------------------------------------------------------
#  File:        format_limits.py
#  Usage:       python format_limits.py 4mu
#  Description: Parse the limits_13tev.txt log file to find the expected limits
#               and error bands, outputting to simple rows in a file.
#  Created:     5-July-2016 Dustin Burns
# -----------------------------------------------------------------------------

import sys

# Parse input file, outputting in simple row format.
channel = sys.argv[1];
limin = open('limits_'+channel+'_13tev.txt')
limout = open('limits_'+channel+'_13tev_out.txt','w')
strobs = ''
str25 = ''
str16 = ''
str50 = ''
str84 = ''
str975 = ''
for line in limin:
  if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected' in line:
    if '2.5%' in line:
      str25 += line.split()[4] + ' '
    if '16.0%' in line:
      str16 += line.split()[4] + ' '
    if '50.0%' in line:
      str50 += line.split()[4] + ' '
    if '84.0%' in line:
      str84 += line.split()[4] + ' '
    if '97.5%' in line:
      str975 += line.split()[4] + ' '
limout.write(str25 + '\n')
limout.write(str16 + '\n')
limout.write(str50 + '\n')
limout.write(str84 + '\n')
limout.write(str975 + '\n')
limout.write(strobs)
limin.close()
limout.close()
