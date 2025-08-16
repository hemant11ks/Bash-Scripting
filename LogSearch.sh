#!/bin/bash

# ==============================================================================
#
# Title:        Windows Log Searcher
# Description:  This script searches the latest Windows Event Logs for a
#               specific keyword. It is designed to be run within a bash
#               environment on Windows (e.g., Git Bash, WSL).
# Author:       Gemini
# Date:         2024-08-16
#
# ==============================================================================

# --- Script Configuration & Color Definitions ---

# Use color codes to make the output more readable.
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Main Functions ---

# Function to display the script's header and purpose.
print_header() {
    echo -e "${CYAN}=======================================${NC}"
    echo -e "${CYAN}    Windows Event Log Search Tool      ${NC}"
    echo -e "${CYAN}=======================================${NC}"
    echo "This script will help you find specific entries in your Windows logs."
    echo
}

# Function to prompt the user for search parameters.
get_user_input() {
    # Prompt for the log name (e.g., Application, System, Security).
    # Provides common choices and a default value.
    echo -e "${YELLOW}Enter the name of the log to search.${NC}"
    echo "Common choices are: Application, System, Security"
    read -p "Log Name [Application]: " log_name
    # If the user just presses Enter, default to "Application".
    log_name=${log_name:-Application}

    # Prompt for the keyword to search for within the log entries.
    echo -e "\n${YELLOW}Enter the keyword to search for (e.g., 'Error', 'Failed', 'SpecificAppName').${NC}"
    read -p "Search Keyword: " keyword

    # Prompt for the number of recent events to search through.
    # This prevents searching through millions of old logs, making it faster.
    echo -e "\n${YELLOW}How many of the most recent events should be searched?${NC}"
    read -p "Number of events [500]: " event_count
    # If the user just presses Enter, default to 500.
    event_count=${event_count:-500}
}

# Function to execute the search and display the results.
perform_search() {
    echo -e "\n${GREEN}Searching the last ${event_count} events in the '${log_name}' log for '${keyword}'...${NC}\n"

    # The core command of the script.
    # 'wevtutil qe' is the Windows Event Log Utility to query events.
    #   - ${log_name}: The specific log file to query (e.g., "Application").
    #   - /c:${event_count}: Specifies the number of events to retrieve.
    #   - /rd:true: Reads events in reverse direction (newest first).
    #   - /f:Text: Formats the output as human-readable text.
    #
    # The output is then piped (|) to 'grep'.
    # 'grep' is a powerful pattern-matching tool.
    #   - -i: Makes the search case-insensitive.
    #   - --color=auto: Highlights the matching keyword in the output.
    #   - "${keyword}": The term to search for.
    #
    # The result of this pipeline command is stored in the 'results' variable.
    results=$(wevtutil qe "${log_name}" /c:"${event_count}" /rd:true /f:Text | grep -i --color=auto "${keyword}")

    # Check if the 'results' variable has any content.
    if [ -n "${results}" ]; then
        # If results were found, print them.
        echo "--- Search Results Found ---"
        echo -e "${results}"
        echo "--- End of Search Results ---"
    else
        # If no results were found, inform the user.
        echo -e "${YELLOW}No events matching '${keyword}' were found in the last ${event_count} entries of the '${log_name}' log.${NC}"
    fi
}


# --- Script Execution ---

# Clear the screen for a clean start.
clear

# Call the functions in order.
print_header
get_user_input
perform_search

echo -e "\n${GREEN}Script finished.${NC}\n"

