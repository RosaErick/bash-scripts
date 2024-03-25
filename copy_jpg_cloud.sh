#!/bin/bash

# Define the search directory
SEARCH_DIR="/run/media/erickrosa/Seagate Backup Plus Drive/fotosnossas"

# Nextcloud WebDAV URL
WEBDAV_URL="http://100.109.17.95:10081/remote.php/dav/files/erick/Photos/fotosnossas"

# Your Nextcloud username and password
USERNAME="erick"
PASSWORD="Xjk6n4b1s!105994"

# Log file
LOGFILE="/home/erickrosa/bash-scripts/upload.log"

# Find .jpg files and upload them
find "$SEARCH_DIR" -type f -name "*.jpg" | while read filename; do
    basefile=$(basename "$filename")
    
    # Check if the file already exists in Nextcloud
    response=$(curl -s -o /dev/null -w "%{http_code}" -u "$USERNAME:$PASSWORD" "$WEBDAV_URL$basefile" -X PROPFIND)
    
    if [ "$response" = "207" ]; then
        echo "$(date): $basefile already exists in Nextcloud. Skipping." | tee -a "$LOGFILE"
    else
        echo "$(date): Uploading $basefile to Nextcloud." | tee -a "$LOGFILE"
        curl -u "$USERNAME:$PASSWORD" -T "$filename" "$WEBDAV_URL$basefile"
        echo "$(date): Upload finished." | tee -a "$LOGFILE"
    fi
done

