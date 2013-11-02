#!/bin/bash
echo -n "Upgrading in 3 seconds, press any key to cancel!"

if read -t 3 response; then
	echo "Cancelled!"
	/bin/login -f root
else
	echo "Upgrading"
	/bin/login -f root
fi

