#!/usr/bin/env python
#
# Author        : Christian Giese (GitHub: GIC-de)
# Version       : 1.0
# Last Modified : 10/04/2017
# Release       : JunOS 16.1R4 and above
# License       : BSD-Style
#
# Copyright (c) 2017, Juniper Networks, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY Juniper Networks 'AS IS' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Juniper Networks BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Python script which humanizes the CLI output of a given command.

This script replaces all numbers greater than 1.000 with a humanized
representation (e.g. 1337 --> 1.3K) without breaking the indentation.
Lines containing one of the exception keywords are skipped
(e.g index, address, mtu, vlan, cache, ...).
"""
from __future__ import print_function
from jnpr.junos import Device
import argparse
import jcs
import re

# define arguments dictionary (key: argument value: help text)
arguments = {
    'command':  'mandatory cli command',
    'round':    'decimal places (default 1)'
}

# skip lines containing one of these keywords
EXCEPT = ("index", "address", "mtu", "vlan", "cache")

# units
UNITS = (
    (1000000000000000000.0, "E"),
    (1000000000000000.0, "P"),
    (1000000000000.0, "T"),
    (1000000000.0, "G"),
    (1000000.0, "M"),
    (1000.0, "K"),
)


def humanize(value_string, decimal=None):
    """return humanized string"""
    value = int(value_string)
    for u_value, unit_sign in UNITS:
        if value > u_value:
            result = round(value / u_value, decimal) if decimal is not None else value / u_value
            if decimal == 0:
                result = int(result)
            return ('{:>%s}%s' % (len(value_string)-len(unit_sign), unit_sign)).format(result)
    return value_string


def main():
    """main function"""
    # parse arguments ----------------------------------------------------------
    parser = argparse.ArgumentParser()
    parser.add_argument('-command')
    parser.add_argument('-round', default=1)
    args, unknown_args = parser.parse_known_args()
    if unknown_args:
        raise ValueError("unknown argument %s" % unknown_args[0][1:])
    if not args.command:
        raise ValueError("missing argument command")
    try:
        decimal = int(args.round)
        if decimal < 0:
            raise Exception
    except:
        raise ValueError("invalid value '%s' for argument round" % args.round)
    # execute command ----------------------------------------------------------
    try:
        dev = Device(gather_facts=False)
        dev.open()
        output = dev.cli(args.command, format='text', warning=False)
    finally:
        try:
            dev.close()
        except:
            pass
    # humanize output ----------------------------------------------------------
    counter_pattern = re.compile("(\s+\d+)")
    for line in output.splitlines():
        l_line = line.lower()
        for x in EXCEPT:
            # skip line based on keywords
            if x in l_line:
                print(line)
                break
        else:
            # humanize values
            matches = counter_pattern.finditer(line)
            if matches:
                i = 0   # string position
                humanized_line = []
                for match in matches:
                    # replace subscring
                    humanized_line.append(line[i:match.start()])
                    humanized_line.append(humanize(match.group(1), decimal))
                    i = match.start() + len(match.group(1))
                humanized_line.append(line[i:])  # append remaining
                print("".join(humanized_line))
            else:
                print(line)


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        jcs.emit_error(str(error))
