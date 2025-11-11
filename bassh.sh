#!/bin/bash

# Clear the screen before starting
# clear

# Ensure the temporary file exists (create if missing)
touch /tmp/bassh-tmp.sh

# Array to store the script lines in memory
script_lines=()

# Program function
bassh() {
    # Temporarily remove the `tput` commands for debugging
    # trap 'tput rmcup; exit' SIGINT SIGTERM

    while true; do
        # Update the line number to reflect the actual length of the array
        line_number=$(( ${#script_lines[@]} + 1 ))

        # Display the line number in the prompt
        read -p "${line_number}> " user_input

        # Handle 'exit' command to break the loop
        if [ "$user_input" == "exit" ]; then
            break
        fi

        # Handle 'run' command to execute the script and return to editor
        if [ "$user_input" == "run" ]; then
            # Uncomment `tput` if your terminal supports screen save/restore
            # tput smcup
            printf "%s\n" "${script_lines[@]}" > /tmp/bassh-tmp.sh
            bash /tmp/bassh-tmp.sh  # Run the temporary script using `bash`
            # tput rmcup
            continue
        fi

        # Handle 'print' command to display the contents of the temporary file
        if [ "$user_input" == "print" ]; then
            echo  # Blank line before printing
            for i in "${!script_lines[@]}"; do
                echo "$((i+1)): ${script_lines[$i]}"
            done
            continue
        fi

        # Handle 'edit <number> <new line>' command to edit a specific line
        if [[ "$user_input" == edit* ]]; then
            edit_number=$(echo "$user_input" | awk '{print $2}')
            new_text=$(echo "$user_input" | cut -d ' ' -f3-)

            # Validate the line number and replace the corresponding line
            if [[ "$edit_number" =~ ^[0-9]+$ ]] && [ "$edit_number" -le "${#script_lines[@]}" ] && [ "$edit_number" -gt 0 ]; then
                script_lines[$((edit_number-1))]="$new_text"
                echo  # Display a blank line instead of "Line updated."
            else
                echo "Invalid line number."
            fi
            continue
        fi

        # Handle 'del <number>' command to delete a specific line
        if [[ "$user_input" == del* ]]; then
            del_number=$(echo "$user_input" | awk '{print $2}')

            # Validate the line number and delete the corresponding line
            if [[ "$del_number" =~ ^[0-9]+$ ]] && [ "$del_number" -le "${#script_lines[@]}" ] && [ "$del_number" -gt 0 ]; then
                unset script_lines[$((del_number-1))]
                script_lines=("${script_lines[@]}")  # Reindex the array to fill the gap
                echo  # Display a blank line after deletion
            else
                echo "Invalid line number."
            fi
            continue
        fi

        # Append the input to the script array
        script_lines+=("$user_input")
    done

    # Uncomment `tput` if debugging works and your terminal supports it
    # tput rmcup
}

bassh

