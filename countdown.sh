#!/bin/zsh
# countdown.sh - Calculate remaining time until a given date and time

# Function to display usage
show_usage() {
    echo "Usage: ./countdown.sh [YYYY-MM-DD] [HH:MM:SS]"
    echo "       ./countdown.sh [YYYY-MM-DD HH:MM:SS]"
    echo ""
    echo "Examples:"
    echo "  ./countdown.sh 2025-12-31 23:59:59"
    echo "  ./countdown.sh '2025-12-31 23:59:59'"
    echo "  ./countdown.sh 2025-07-15 10:30:00"
    echo ""
    echo "If time is not provided, defaults to 00:00:00"
    exit 1
}

# Function to validate date format
validate_date() {
    local date_str="$1"
    if ! date -j -f "%Y-%m-%d %H:%M:%S" "$date_str" >/dev/null 2>&1; then
        return 1
    fi
    return 0
}

# Function to format time components
format_time_component() {
    local value=$1
    local unit=$2
    local plural_unit=$3
    
    if [ $value -eq 0 ]; then
        return
    elif [ $value -eq 1 ]; then
        echo -n "$value $unit"
    else
        echo -n "$value $plural_unit"
    fi
}

# Function to calculate and display countdown
calculate_countdown() {
    local target_date="$1"
    
    # Get current timestamp and target timestamp (macOS date command)
    local current_timestamp=$(date +%s)
    local target_timestamp=$(date -j -f "%Y-%m-%d %H:%M:%S" "$target_date" +%s 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "Error: Invalid date format. Please use YYYY-MM-DD HH:MM:SS"
        show_usage
    fi
    
    # Calculate difference in seconds
    local diff=$((target_timestamp - current_timestamp))
    
    # Check if the date is in the past
    if [ $diff -lt 0 ]; then
        echo "The specified date and time is in the past!"
        diff=$((diff * -1))
        echo "Time since that date"
    else
        echo "Time remaining until $target_date"
    fi
    
    # Calculate time components
    local weeks=$((diff / 604800))  # 604800 seconds in a week
    diff=$((diff % 604800))
    
    local days=$((diff / 86400))    # 86400 seconds in a day
    diff=$((diff % 86400))
    
    local hours=$((diff / 3600))    # 3600 seconds in an hour
    diff=$((diff % 3600))
    
    local minutes=$((diff / 60))    # 60 seconds in a minute
    local seconds=$((diff % 60))
    
    # Format and display the result
    echo ""
    echo "================================================"
    
    # Build output string
    local output_parts=()
    
    if [ $weeks -gt 0 ]; then
        if [ $weeks -eq 1 ]; then
            output_parts+=("$weeks week")
        else
            output_parts+=("$weeks weeks")
        fi
    fi
    
    if [ $days -gt 0 ]; then
        if [ $days -eq 1 ]; then
            output_parts+=("$days day")
        else
            output_parts+=("$days days")
        fi
    fi
    
    if [ $hours -gt 0 ]; then
        if [ $hours -eq 1 ]; then
            output_parts+=("$hours hour")
        else
            output_parts+=("$hours hours")
        fi
    fi
    
    if [ $minutes -gt 0 ]; then
        if [ $minutes -eq 1 ]; then
            output_parts+=("$minutes minute")
        else
            output_parts+=("$minutes minutes")
        fi
    fi
    
    if [ $seconds -gt 0 ]; then
        if [ $seconds -eq 1 ]; then
            output_parts+=("$seconds second")
        else
            output_parts+=("$seconds seconds")
        fi
    fi
    
    # Join parts with commas and "and"
    if [ ${#output_parts[@]} -eq 0 ]; then
        echo "The time has arrived!"
    elif [ ${#output_parts[@]} -eq 1 ]; then
        echo "${output_parts[1]}"
    else
        local last_part="${output_parts[-1]}"
        unset 'output_parts[-1]'
        if [ ${#output_parts[@]} -gt 0 ]; then
            local joined=$(printf "%s, " "${output_parts[@]}")
            joined="${joined%, }"  # Remove trailing comma and space
            echo "${joined} and ${last_part}"
        else
            echo "${last_part}"
        fi
    fi
    
    echo "================================================"
    echo ""
    
    # Display exact breakdown
    printf "Exact breakdown:\n"
    printf "  Weeks:   %d\n" $weeks
    printf "  Days:    %d\n" $days
    printf "  Hours:   %d\n" $hours
    printf "  Minutes: %d\n" $minutes
    printf "  Seconds: %d\n" $seconds
    
    # Display total seconds
    local total_seconds=$((target_timestamp - current_timestamp))
    if [ $total_seconds -lt 0 ]; then
        total_seconds=$((total_seconds * -1))
    fi
    printf "\nTotal seconds: %d\n" $total_seconds
}

# Main script logic
main() {
    # Check for help flag
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
    fi
    
    # Check if at least one argument is provided
    if [ $# -eq 0 ]; then
        echo "Error: No date provided."
        show_usage
    fi
    
    local target_date=""
    
    # Parse arguments
    if [ $# -eq 1 ]; then
        # Single argument - could be "YYYY-MM-DD" or "YYYY-MM-DD HH:MM:SS"
        if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            # Date only, add default time
            target_date="$1 00:00:00"
        elif [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]][0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]; then
            # Full date and time
            target_date="$1"
        else
            echo "Error: Invalid date format."
            show_usage
        fi
    elif [ $# -eq 2 ]; then
        # Two arguments - date and time
        if [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ "$2" =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]; then
            target_date="$1 $2"
        else
            echo "Error: Invalid date or time format."
            show_usage
        fi
    else
        echo "Error: Too many arguments."
        show_usage
    fi
    
    # Calculate and display countdown
    calculate_countdown "$target_date"
}

# Run main function with all arguments
main "$@"
