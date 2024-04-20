#!/bin/bash

# Function to print usage instructions
print_usage() {
    echo "Usage: $0 [-p] <directory>"
    echo "Options:"
    echo "  -p: Print actions without executing git commands"
}

# Check if the -p flag is provided
print_only=false
while getopts ":p" opt; do
    case ${opt} in
        p )
            print_only=true
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            print_usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check if the directory parameter is provided
if [ $# -ne 1 ]; then
    print_usage
    exit 1
fi

# Assign the directory parameter to a variable
directory="$1"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Navigate to the specified directory
cd "$directory" || exit

# Iterate over each file in the directory
for file in *; do
    # Check if the file is a regular file (not a directory)
    if [ -f "$file" ]; then
        # Check if print only flag is set
        if [ "$print_only" = true ]; then
            echo "Would add $file to git"
            echo "Would commit $file to git"
        else
            # Add the file to the staging area
            git add "$file"
            
            # Commit the file with a commit message indicating the file name
            git commit -m "Add $file"
        fi
    fi
done
