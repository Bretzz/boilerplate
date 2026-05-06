#!/bin/bash

# The parent script should ideally export the PROJECT_NAME 
# or you can grab the current directory name
CURRENT_DIR_NAME=$(basename "$PWD")

# Update the name field
sed -i '' "s/\"name\": \".*\"/\"name\": \"$CURRENT_DIR_NAME\"/" package.json

# Now proceed with the rest of your setup
npm install