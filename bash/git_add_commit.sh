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

# Get the list of changed files using git status
changed_files=$(git status --porcelain | grep -E '^(M|A|D|..)' | cut -c 4-)

# Iterate over each changed file
for file in $changed_files; do
    # Get the status of the file
    status=$(git status --porcelain "$file" | cut -c 1)

    # Determine the appropriate commit message based on the file status
    case $status in
        M )
            commit_msg="Modify $file"
            ;;
        A )
            commit_msg="Add $file"
            ;;
        D )
            commit_msg="Delete $file"
            ;;
        * )
            commit_msg="Update $file"
            ;;
    esac
        
    # Check if print only flag is set
    if [ "$print_only" = true ]; then
        echo "Would add $file to git"
        echo "Would commit with message: $commit_msg"
    else
        git add "$file"
        git commit -m "$commit_msg"
    fi
done
