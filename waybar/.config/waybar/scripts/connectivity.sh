#!/bin/bash

connectivity=$(nmcli networking connectivity)

if [[ "$connectivity" == "limited" ]]; then
	echo "!"
else
	echo ""
fi
