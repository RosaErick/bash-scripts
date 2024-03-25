#!/bin/bash

# Define the search directory
SEARCH_DIR=""

# Nextcloud WebDAV URL
WEBDAV_URL=""

# Your Nextcloud username and password
USERNAME=""
PASSWORD=""

# Log file
LOGFILE="/home/username/bash-scripts/upload.log"

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

