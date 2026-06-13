#!/bin/bash

pid=$(niri msg pick-window | awk '$1 == "PID:" {print $2}')
kill -9 "$pid"
