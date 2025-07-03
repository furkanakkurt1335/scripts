#!/bin/zsh
# chronometer.sh - A simple chronometer shell script that runs forever

# Function to handle script termination with Ctrl+C
trap 'echo -e "\nChronometer stopped at $(printf "%02d" $hours):$(printf "%02d" $minutes):$(printf "%02d" $seconds)"; exit' INT

# Initialize counters
seconds=0
minutes=0
hours=0

# Clear screen
clear

echo "Chronometer started. Press Ctrl+C to stop."
echo "----------------------------------------"

# Infinite loop
while true; do
    # Format time with leading zeros
    formatted_seconds=$(printf "%02d" $seconds)
    formatted_minutes=$(printf "%02d" $minutes)
    formatted_hours=$(printf "%02d" $hours)
    
    # Display the time
    echo -ne "\r$formatted_hours:$formatted_minutes:$formatted_seconds"
    
    # Wait 1 second
    sleep 1
    
    # Increment seconds
    ((seconds++))
    
    # Handle time rollover
    if [ $seconds -eq 60 ]; then
        seconds=0
        ((minutes++))
        
        if [ $minutes -eq 60 ]; then
            minutes=0
            ((hours++))
            
            if [ $hours -eq 24 ]; then
                hours=0
            fi
        fi
    fi
done