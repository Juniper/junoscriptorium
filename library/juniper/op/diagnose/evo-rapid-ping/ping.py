#!/usr/bin/env python

"""

Copyright 2014-2021 Juniper Networks, Inc. All rights reserved.
Licensed under the Juniper Networks Script Software License (the 'License').
You may not use this script file except in compliance with the License, which is located
at http://www.juniper.net/support/legal/scriptlicense/
Unless required by applicable law or otherwise agreed to in writing by the parties,
software distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

Filename      : ping.py
Author        : Anton Elita <aelita@juniper.net>
Platform      : Junos Evolved
Release       : Junos 20.4R2
Description   : Alternative to a rapid ping utility from the stock linux
Version       : GIT_BUILD

"""



import subprocess
import argparse
import re
import socket
import time

arguments = { "dst": "Hostname or IP address of remote host",
              "source": "Source address of echo request",
              "count": "Number of ping requests to send (2..1000 packets)",
              "bypass": "Bypass routing table, use specified interface (yes / no)",
              "interface": "Source interface (multicast, all-ones, unrouted packets)"
            }

bashCommand = "LD_PRELOAD=libsi.so chvrf -JU default ping -c 1 -w 1 -W 1 "

start_time = time.time()


def is_ip_address(address):
    try:
        socket.inet_pton(socket.AF_INET, address)
    except socket.error:
        try:
            socket.inet_pton(socket.AF_INET6, address)
        except socket.error:
            return False
    return True

def main():
    ping_options = ""
    parser = argparse.ArgumentParser(description="Alternative ping command.")
    for parameter, description in arguments.items():
        if parameter == "count":
            parser.add_argument(('-' + parameter), type=int, help=description)
        elif parameter == "dst":
            parser.add_argument(('-' + parameter), type=str, required=True, help=description)
        elif parameter == "interface":
            parser.add_argument(('-' + parameter), type=str, help=description)
        elif parameter == "source":
            parser.add_argument(('-' + parameter), type=str, help=description)
        elif parameter == "bypass":
            parser.add_argument(('-' + "bypass"), type=str, help=description)

    args = parser.parse_args()

    if args.count < 2 or args.count > 1000:
        print("Adjusting count to 10, range is 2 to 1000")
        count = 10
    else:
        count = args.count

    # check if interface is defined, add the .0 if required
    if isinstance(args.interface, str):
        if bool(re.search('\.[0-9]+$', args.interface)) == False:
            args.interface+=".0"
        ping_options += " -I " + args.interface + " "

    # check if source IP is defined
    if isinstance(args.source, str):
        # Check if it's an IP address
        if is_ip_address(args.source) == True:
            ping_options += " -I " + args.source + " "

    # check if bypass-routing is desired
    if isinstance(args.bypass, str):
        # Check if it's an IP address
        if args.bypass == "yes":
            ping_options += " -r "

    visual = ""
    success_echo = 0
    fail_echo = 0
    print("PING "+args.dst+": 56(84) data bytes")

    for cnt in range(0,count):
        time.sleep(0.1)
        if cnt % 10 == 0:
            print(visual)
            visual = ""
        try:
            ping_cmd = bashCommand+ping_options+args.dst
            output = subprocess.check_output(['bash','-c', ping_cmd])
            visual += "!"
            success_echo += 1
        except:
            visual += "."
            fail_echo += 1

    end_time = time.time()

    print(visual)

    percent_loss = (fail_echo * 100 / (cnt+1) )

    print(str(cnt+1)+" packets transmitted, "+str(success_echo)+" packets received "+str(percent_loss)+"% packet loss")
    print("Start time: "+time.strftime('%Y-%m-%d %H:%M:%S %Z', time.localtime(start_time)))
    print("End   time: "+time.strftime('%Y-%m-%d %H:%M:%S %Z', time.localtime(end_time)))
    #print ping_cmd

if __name__ == "__main__":
    main()
