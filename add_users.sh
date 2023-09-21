#!/bin/bash

path="/mnt/eufs003/student_lnxhome01"
symlink="/uolstore/home/student_lnxhome01"
log_file="/var/log/script.log"
userlist="/root/cs_new_student/user_list"
testlist="~/root/cs_new_student/test_list"

# Initialize the log file
echo "Script started at $(date)" > "$log_file"

# Check if the user_list file exists
#if [ ! -f "$userlist" ]; then
#    echo "Error: The user_list file '$userlist' does not exist." | tee -a "$log_file"
#    exit 1
#fi

readarray -t user_list < "$testlist"

for i in "${!user_list[@]}"; do
   source_dir="$path/${user_list[$i]}"
   
   # Check if the source_dir already exists
   if [ -d "$source_dir" ]; then
       echo "Warning: Directory '$source_dir' already exists. Skipping." | tee -a "$log_file"
       continue  # Skip to the next iteration of the loop
   fi
   
   # Attempt to create the directory
   mkdir "$source_dir"
   if [ $? -ne 0 ]; then
       echo "Error: Failed to create directory '$source_dir'." | tee -a "$log_file"
       exit 1
   fi
   
   # Set ownership and permissions
   chown -R "${user_list[$i]}" "$source_dir"
   chmod 700 "$source_dir"
   
   # Create the symbolic link
   ln -s "/home/csunix/${user_list[$i]}" "$symlink/${user_list[$i]}"
   if [ $? -ne 0 ]; then
       echo "Error: Failed to create symbolic link for '${user_list[$i]}'." | tee -a "$log_file"
       # You can choose to exit or continue with the loop based on your preference
   fi

done

# Log script completion
echo "Script completed successfully at $(date)" | tee -a "$log_file"