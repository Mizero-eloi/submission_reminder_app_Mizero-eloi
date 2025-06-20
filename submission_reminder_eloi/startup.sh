#!/bin/bash
# This script starts the submission reminder application
# It runs the reminder script to show which students need reminders

echo "Starting your submission reminder app..."
echo ""

# Check if all required files exist before running
if [ ! -f "./config/config.env" ]; then
    echo "Oh no! I can't find the config file. Something is missing."
    exit 1
fi

if [ ! -f "./modules/functions.sh" ]; then
    echo "Oh no! I can't find the functions file. Something is missing."
    exit 1
fi

if [ ! -f "./app/reminder.sh" ]; then
    echo "Oh no! I can't find the reminder file. Something is missing."
    exit 1
fi

if [ ! -f "./assets/submissions.txt" ]; then
    echo "Oh no! I can't find the student data file. Something is missing."
    exit 1
fi

# Run the reminder application
echo "Checking who needs reminders..."
echo ""
bash ./app/reminder.sh

echo ""
echo "All done! Check complete."
