#! /bin/bash

kill $(ps aux | grep "nginx: master" | grep -v grep | awk '{print $2}')
