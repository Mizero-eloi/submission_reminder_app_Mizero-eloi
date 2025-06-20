#!/bin/bash

# this script allows users to change the assignment name in the config file
# and then rerun the startup script to check submissions for the new assignment

echo "Hi! This tool lets you change which assignment to check."
echo "You can switch from one assignment to another."

# ask user for the new assignment name
echo ""
echo "What assignment do you want to check?"
echo "(For example: Git, Shell Basics, Shell Navigation)"
read new_assignment

# then checking if user entered something
if [ -z "$new_assignment" ]; then
    echo "Oops! You forgot to enter an assignment name."
    echo "Please run this script again and type an assignment name."
    exit 1
fi

# checking if assignment name is reasonable (not too long, no weird characters)
if [ ${#new_assignment} -gt 50 ]; then
    echo "That assignment name is too long. Please use something shorter."
    exit 1
fi

# finding the submission reminder directory
# Look for directories that start with "submission_reminder_"
reminder_dir=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -1)

# Check if directory was found
if [ -z "$reminder_dir" ]; then
    echo "I can't find your submission reminder folder!"
    echo "Make sure you ran the create_environment.sh script first."
    echo "It should create a folder that starts with 'submission_reminder_'"
    exit 1
fi

# Path to the config file
config_file="$reminder_dir/config/config.env"

# Checking if config file exists
if [ ! -f "$config_file" ]; then
    echo "I found your folder but can't find the config file inside it."
    echo "Expected to find it at: $config_file"
    echo "Something might be wrong with your setup."
    exit 1
fi

echo "Found your submission reminder folder: $reminder_dir"
echo "Changing assignment to: $new_assignment"

# Use sed to replace the assignment name in the config file
# This finds the line that starts with ASSIGNMENT= and replaces the whole line
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

# Check if the replacement was successful
if grep -q "ASSIGNMENT=\"$new_assignment\"" "$config_file"; then
    echo "Great! Assignment name updated successfully!"
else
    echo "Something went wrong. Couldn't update the assignment name."
    echo "You might need to check the config file manually."
    exit 1
fi

echo ""
echo "Here's what's in your config file now:"
echo "---"
cat "$config_file"
echo "---"

echo ""
echo "Now let me run the app with your new assignment..."
echo ""

# Change to the reminder directory and run startup.sh
cd "$reminder_dir"

# Check if startup.sh exists and is executable
if [ ! -f "startup.sh" ]; then
    echo "I can't find the startup.sh file in your folder."
    echo "Something might be wrong."
    exit 1
fi

if [ ! -x "startup.sh" ]; then
    echo "The startup.sh file isn't runnable. Let me fix that..."
    chmod +x startup.sh
fi

./startup.sh

echo ""
echo "All done! Your assignment has been changed and checked."
