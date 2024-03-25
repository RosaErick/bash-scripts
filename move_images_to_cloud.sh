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

# Function to process file upload
process_file() {
    local filename="$1"
    basefile=$(basename "$filename")

    # Check if the file already exists in Nextcloud
    response=$(curl -s -o /dev/null -w "%{http_code}" -u "$USERNAME:$PASSWORD" "$WEBDAV_URL$basefile" -X PROPFIND)

    if [ "$response" = "207" ]; then
        echo "$(date): $basefile already exists in Nextcloud. Skipping." | tee -a "$LOGFILE"
    else
        echo "$(date): Moving $basefile to Nextcloud." | tee -a "$LOGFILE"
        # Use curl to upload, and if upload succeeds, remove the local file
        if curl -u "$USERNAME:$PASSWORD" -T "$filename" "$WEBDAV_URL$basefile"; then
            echo "$(date): Upload finished. Removing local file." | tee -a "$LOGFILE"
            rm "$filename"
        else
            echo "$(date): Failed to upload $basefile." | tee -a "$LOGFILE"
        fi
    fi
}

# Find .jpg and .png files and upload them
find "$SEARCH_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -iname "*.jpeg" \) | while read filename; do
    process_file "$filename"
done
