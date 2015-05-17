#!/bin/bash
sudo /usr/bin/scanimage -l 0mm -t 0mm -x 215mm -y 297mm --mode Color --format tiff --resolution 300 | sudo /usr/bin/convert - ~/public_html/so_$(date -d "today" +"%Y%m%dT%H%M%S").jpg
