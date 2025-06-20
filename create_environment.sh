#!/bin/bash

#  the submission reminder app
# It asks for the user's name and creates folders and files needed for the app

echo "Hi! Let's set up your submission reminder app"
echo "This will create folders and files you need"

# request the user for the name
echo "Please enter your name:"
read user_name

# check if user entered a name
if [ -z "$user_name" ]; then
    echo "Oops! You forgot to enter your name."
    echo "Please run this script again and type your name when asked."
    exit 1
fi

# then check if name is simple (only letters and numbers)
if [[ ! "$user_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Sorry, your name should only have letters and numbers."
    echo "No spaces or weird symbols please. Try again with a simpler name."
    exit 1
fi

# Cceate the main directory with the user's name
main_dir="submission_reminder_${user_name}"

# Check if directory already exists
if [ -d "$main_dir" ]; then
    echo "Hmm, looks like you already have a folder called $main_dir"
    echo "Should I delete it and make a new one? Type 'yes' or 'no':"
    read answer
    if [ "$answer" != "yes" ]; then
        echo "OK, I won't delete it. Maybe try a different name next time."
        exit 1
    fi
    echo "Removing the old folder..."
    rm -rf "$main_dir"
fi

echo "Creating your folder: $main_dir"
mkdir -p "$main_dir"

# check if folder was created successfully
if [ ! -d "$main_dir" ]; then
    echo "Sorry, I couldn't create the folder. Maybe you don't have permission?"
    exit 1
fi

# Create all the subdirectories inside the main directory
echo "Creating the folders inside..."
mkdir -p "$main_dir/app"
mkdir -p "$main_dir/modules"
mkdir -p "$main_dir/assets"
mkdir -p "$main_dir/config"

# Check if all folders were created
if [ ! -d "$main_dir/app" ] || [ ! -d "$main_dir/modules" ] || [ ! -d "$main_dir/assets" ] || [ ! -d "$main_dir/config" ]; then
    echo "Something went wrong creating the folders. Please try again."
    exit 1
fi

echo "All folders created successfully!"

# Create and populate the config.env file
echo "Creating config file..."
cat > "$main_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Check if config file was created
if [ ! -f "$main_dir/config/config.env" ]; then
    echo "Couldn't create config file. Something went wrong."
    exit 1
fi

# Create and populate the functions.sh file
echo "Creating functions file..."
cat > "$main_dir/modules/functions.sh" << 'EOF'
#!/bin/bash
# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"
    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)
        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Check if functions file was created
if [ ! -f "$main_dir/modules/functions.sh" ]; then
    echo "Couldn't create functions file. Something went wrong."
    exit 1
fi

# Create and populate the reminder.sh file
echo "Creating reminder file..."
cat > "$main_dir/app/reminder.sh" << 'EOF'
#!/bin/bash
# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh
# Path to the submissions file
submissions_file="./assets/submissions.txt"
# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"
check_submissions $submissions_file
EOF

# Check if reminder file was created
if [ ! -f "$main_dir/app/reminder.sh" ]; then
    echo "Couldn't create reminder file. Something went wrong."
    exit 1
fi

# Create and populate the submissions.txt file with original + 5 more students
echo "Creating student data file..."
cat > "$main_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Emmanuel, Shell Navigation, not submitted
Sarah, Git, submitted
Michael, Shell Navigation, not submitted
Jessica, Shell Basics, not submitted
David, Shell Navigation, submitted
EOF

# Check if submissions file was created
if [ ! -f "$main_dir/assets/submissions.txt" ]; then
    echo "Couldn't create student data file. Something went wrong."
    exit 1
fi

# Create the startup.sh script (this is what you need to implement)
echo "Creating startup file..."
cat > "$main_dir/startup.sh" << 'EOF'
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
EOF

# Check if startup file was created
if [ ! -f "$main_dir/startup.sh" ]; then
    echo "Couldn't create startup file. Something went wrong."
    exit 1
fi

# Make all .sh files executable
echo "Making files runnable..."
chmod +x "$main_dir"/*.sh
chmod +x "$main_dir"/app/*.sh  
chmod +x "$main_dir"/modules/*.sh

# Check if files were made executable
if [ ! -x "$main_dir/startup.sh" ]; then
    echo "Couldn't make startup file runnable. You might need to do it manually."
fi

echo ""
echo "Great! Everything is set up and ready to go!"
echo "Your folder is called: $main_dir"
echo "All your files are created and ready to use."
echo ""
echo "To test your app:"
echo "1. cd $main_dir"
echo "2. ./startup.sh"
echo ""
echo "Have fun with your submission reminder app!"
