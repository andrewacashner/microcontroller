#!/usr/bin/env sh

receivemidi dev "Samson Carbon61" dump | tio -b 31250 /dev/tty.usbmodemMG3500011
