#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

function invalid_opt() {
	echo ""
	echo "Invalid option"
	echo ""
	sleep 2

	}

function menu() {

	# clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 

		1) admin_menu
		;;
		
		2) security_menu
		;;
		
		3) exit 0
		;;

		*) 
			invalid_opt

			# Call the main menu
			menu
		;;
		
	esac

}

function admin_menu() {

	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 

		L|l) ps -ef | less
		;;

		N|n) netstat -an --inet | less
		;;

		V|v) vpn_menu
		;;

		4) exit 0
		;;
		
		*)
			invalid_opt
		;;
		
	esac

admin_menu

}


function vpn_menu() {

	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in 

		A|a) 

			bash peer.bash
			tail -6 wg0.conf | less
		;;

		D|d)
			# Create a prompt for the user
			# Call the manage-user.bash and pass the proper switches and argument
			# to delete the user
			cat  wg0.conf
			read -p "Which user would you like to delete? " user
			echo ""
			echo "You would like to delete ${user}"
			
			bash manage-users.bash -d -u ${user}
			echo ""
			cat wg0.conf
		;;
	
		B|b) admin_menu
		;;
	
		M|m) menu
		;;

		E|e) exit 0
		;;
		

		*)
			invalid_opt
		;;

	esac

vpn_menu
}


function security_menu() {
	echo "[1] List open network sockets"
	echo "[2] Check if any user besides root has a UID of 0"
	echo "[3] Check the last 10 logged in users"
	echo "[4] See currently logged in users"
	echo "[5] Exit"
	read -p "Please select an option: " choice

	case "$choice" in
		1)
			clear
			ss -l | less
			echo ""
		;;

		2)
			clear
			uid=$(grep 'x:0:' /etc/passwd | cut -d\: -f1)
			if echo ${uid} == "root"
			then
				echo "Only  the root user has a UID of 0."
				echo ""
				else
					echo "Another user or users besides root has a UID of 0."
					echo ""
			fi
		;;

		3)
			clear
			last | head -n 10
			echo ""
		;;

		4) 
			clear
			who
			echo ""
		;;

		5) exit 0
		;;

		*)
			invalid_opt
		;;
	esac

security_menu
}


# Call the main funciton
menu
