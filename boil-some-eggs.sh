#!/bin/bash

# --- 1. Hardcoded Configuration ---
YOUR_USERNAME='Bretzz'
REPO_URL="https://github.com/$YOUR_USERNAME/boilerplate.git"
# Add or remove your subfolders here
OPTIONS=("vue" "OpenGL" "react" "nodejs")

echo "# Boilerplate Selector"
echo "-----------------------"

# --- 2. Selection Menu ---
PS3="Select the boilerplate to clone: "
select SUBFOLDER in "${OPTIONS[@]}"; do
    if [ -n "$SUBFOLDER" ]; then
        echo "✅ Selected: $SUBFOLDER"
        break
    else
        echo "❌ Invalid selection."
    fi
done

# --- 3. Setup Project Name ---
read -p "Enter the name for your new project: " PROJECT_NAME

# --- 4. Sparse Clone Logic (The "Lightweight" Part) ---
echo "Cloning /$SUBFOLDER..."

# Create directory and initialize git
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit
git init
git remote add -f origin "$REPO_URL"

# Enable sparse-checkout
git config core.sparseCheckout true

# Tell Git which folder to pull
echo "$SUBFOLDER/*" >> .git/info/sparse-checkout

# Pull only the necessary files (shallow pull for speed)
git pull --depth=1 origin main 

# --- 5. Clean up the folder structure ---
# Move files from subfolder to root and remove the nested folder
mv "$SUBFOLDER"/* .
mv "$SUBFOLDER"/.* . 2>/dev/null # Move hidden files if any
rmdir "$SUBFOLDER"

# --- 6. Run Initialization ---
if [ -f "./init.sh" ]; then
    echo "Running init.sh..."
    chmod +x init.sh
    ./init.sh
else
    echo "No init.sh found. Running npm install as fallback..."
    [ -f "package.json" ] && npm install
fi

# --- 7. GitHub Repository Creation ---
echo "-----------------------------------"
read -p "Create a new GitHub repository for this project? (y/n): " CREATE_REPO

if [[ "$CREATE_REPO" =~ ^[Yy]$ ]]; then
    if ! command -v gh &> /dev/null; then
        echo "❌ GitHub CLI (gh) not found."
    else
        read -p "Enter new repository name: " REPO_NAME
        echo "Select visibility:"
        select VISIBILITY in "public" "private"; do
            case $VISIBILITY in
                public|private ) break;;
                * ) echo "Please choose 1 or 2";;
            esac
        done

        # Wipe the boilerplate's git metadata and start fresh for the NEW repo
        rm -rf .git
        git init
        git add .
        git commit -m "Initial commit from $SUBFOLDER boilerplate"
        gh repo create "$REPO_NAME" --"$VISIBILITY" --source=. --remote=origin --push
        echo "Project live at: https://github.com/$YOUR_USERNAME/$REPO_NAME"
    fi
fi

echo "Done! Your project is ready in ./$PROJECT_NAME"