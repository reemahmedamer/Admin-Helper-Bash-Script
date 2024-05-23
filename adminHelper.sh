#!/bin/bash

whiptail --msgbox "Welcome to Admin Helper!" 10 40

while true;
do


choice=$(whiptail --menu "Choose an option:" 20 40 12 \
  "1" "Add New User" \
  "2" "Remove User" \
  "3" "List User Details" \
  "4" "Add New Group" \
  "5" "Remove Group" \
  "6" "Enable User" \
  "7" "Disable User" \
  "8" "Lock Account" \
  "9" "Unlock Account" \
  "10" "Change Password" \
  "11" "Change Password Expiration Date" \
  "12" "Exit" \
  3>&1 1>&2 2>&3)

case $choice in
  1)
	username=$(whiptail --inputbox "Enter the new username:" 10 40 3>&1 1>&2 2>&3)
        password=$(whiptail --passwordbox "Enter the password for $username:" 10 40 3>&1 1>&2 2>&3)

        # Check if the username already exists
        if id "$username" &>/dev/null; 
	then
            whiptail --msgbox "Error: User '$username' already exists." 10 40
        else
            # Add the new user
            useradd -m -s /bin/bash "$username"

            # Set the password for the new user
            echo "$username:$password" | chpasswd

            whiptail --msgbox "User '$username' has been created successfully." 10 40
        fi
        ;;
  2)
    	user_to_remove=$(whiptail --inputbox "Enter the username to remove:" 10 40 3>&1 1>&2 2>&3)

         if id "$user_to_remove" &>/dev/null;
	 then

            # Ask the user whether to delete the home director
            if whiptail --yesno "Do you want to delete the home directory of $user_to_remove?" 10 40;
	    then
                userdel -r "$user_to_remove"
                whiptail --msgbox "User '$user_to_remove' and its home directory have been removed." 10 40
            else
                userdel "$user_to_remove"
                whiptail --msgbox "User '$user_to_remove' has been removed, but the home directory is preserved." 10 40
            fi
        else
            whiptail --msgbox "Error: User '$user_to_remove' does not exist." 10 40
        fi
        ;;
  3)
	username=$(whiptail --inputbox "Enter the new username:" 10 40 3>&1 1>&2 2>&3)

        if id "$username" &>/dev/null; 
        then

            user_details=$(getent passwd "$username")
            whiptail --msgbox "User Details for '$username':\n\n$user_details" 20 60
	else
	    whiptail --msgbox "Error: User '$username' does not exist." 10 40

        fi
        ;;
  4)
	group_name=$(whiptail --inputbox "Enter the new group name:" 10 40 3>&1 1>&2 2>&3)

        # Check if the group already exists
        if grep -q "^$group_name:" /etc/group; then
            whiptail --msgbox "Error: Group '$group_name' already exists." 10 40
        else
            # Add the new group
            groupadd "$group_name"
            whiptail --msgbox "Group '$group_name' has been created successfully." 10 40
        fi
        ;;

  5)
	group_to_remove=$(whiptail --inputbox "Enter the group name to remove:" 10 40 3>&1 1>&2 2>&3)

        if grep -q "^$group_to_remove:" /etc/group; then
            groupdel "$group_to_remove"
            whiptail --msgbox "Group '$group_to_remove' has been removed." 10 40
        else
            whiptail --msgbox "Error: Group '$group_to_remove' does not exist." 10 40
        fi
        ;;
  6)
	user_to_enable=$(whiptail --inputbox "Enter the username to enable the account:" 10 40 3>&1 1>&2 2>&3)

        if id "$user_to_enable" &>/dev/null; then
            usermod -e "" "$user_to_enable"
            whiptail --msgbox "Account for '$user_to_enable' has been enabled." 10 40
        else
            whiptail --msgbox "Error: User '$user_to_enable' does not exist." 10 40
        fi
        ;;
  7)
	 user_to_disable=$(whiptail --inputbox "Enter the username to disable the account:" 10 40 3>&1 1>&2 2>&3)

        if id "$user_to_disable" &>/dev/null; then
            usermod -e 1 "$user_to_disable"
            whiptail --msgbox "Account for '$user_to_disable' has been disabled." 10 40
        else
            whiptail --msgbox "Error: User '$user_to_disable' does not exist." 10 40
        fi
        ;;
  8)
	user_to_lock=$(whiptail --inputbox "Enter the username to lock the account:" 10 40 3>&1 1>&2 2>&3)

        if id "$user_to_lock" &>/dev/null; then
            usermod -L "$user_to_lock"
            whiptail --msgbox "Account for '$user_to_lock' has been locked." 10 40
        else
            whiptail --msgbox "Error: User '$user_to_lock' does not exist." 10 40
        fi
        ;;
  9)
	 user_to_unlock=$(whiptail --inputbox "Enter the username to unlock the account:" 10 40 3>&1 1>&2 2>&3)

         if id "$user_to_unlock" &>/dev/null; then
            usermod -U "$user_to_unlock"
            whiptail --msgbox "Account for '$user_to_unlock' has been unlocked." 10 40
         else
            whiptail --msgbox "Error: User '$user_to_unlock' does not exist." 10 40
         fi
         ;;
  10)
	 user_to_change_password=$(whiptail --inputbox "Enter the username to change the password:" 10 40 3>&1 1>&2 2>&3)

         if id "$user_to_change_password" &>/dev/null; then
            new_password=$(whiptail --passwordbox "Enter the new password for $user_to_change_password:" 10 40 3>&1 1>&2 2>&3)
            echo "$user_to_change_password:$new_password" | chpasswd
            whiptail --msgbox "Password for '$user_to_change_password' has been changed." 10 40
         else
            whiptail --msgbox "Error: User '$user_to_change_password' does not exist." 10 40
         fi
         ;;
  11)
	 user_to_modify=$(whiptail --inputbox "Enter the username to change password expiration date:" 10 40 3>&1 1>&2 2>&3)

         if id "$user_to_modify" &>/dev/null; then
            expiration_date=$(whiptail --inputbox "Enter the new password expiration date (YYYY-MM-DD):" 10 40  3>&1 1>&2 2>&3)

            chage -E "$expiration_date" "$user_to_modify"
            whiptail --msgbox "Password expiration date for '$user_to_modify' has been updated." 10 40
         else
            whiptail --msgbox "Error: User '$user_to_modify' does not exist." 10 40
         fi
         ;;

  12)
       whiptail --msgbox "Exiting Admin Helper" 10 40
       exit 0
       ;;
  *)
        whiptail --msgbox "Invalid choice" 10 40
        ;;
esac

done

