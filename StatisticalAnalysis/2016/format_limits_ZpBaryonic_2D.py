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
in300 = open('limits_ZpBaryonic_MChi1.txt')
in400 = open('limits_ZpBaryonic_MChi10.txt')
in500 = open('limits_ZpBaryonic_MChi50.txt')
in600 = open('limits_ZpBaryonic_MChi150.txt')
in700 = open('limits_ZpBaryonic_MChi500.txt')
in800 = open('limits_ZpBaryonic_MChi1000.txt')

limout = open('limits_ZpBaryonic_2D_out.txt','w')

strobs = ''
str300  = ''
str400  = ''
str500  = ''
str600  = ''
str700  = ''
str800  = ''
for line in in300:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str300 += line.split()[4] + ' '
for line in in400:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str400 += line.split()[4] + ' '
for line in in500:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str500 += line.split()[4] + ' '
for line in in600:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str600 += line.split()[4] + ' '
for line in in700:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str700 += line.split()[4] + ' '
for line in in800:
  #if 'Observed' in line: strobs += line.split()[4] + ' '
  if 'Expected 50.0%' in line:
    str800 += line.split()[4] + ' '

limout.write(str300 + '\n')
limout.write(str400 + '\n')
limout.write(str500 + '\n')
limout.write(str600 + '\n')
limout.write(str700 + '\n')
limout.write(str800 + '\n')
#limout.write(strobs)
in300.close()
in400.close()
in500.close()
in600.close()
in700.close()
in800.close()
limout.close()
