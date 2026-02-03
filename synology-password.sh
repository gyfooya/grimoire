#!/bin/bash

# Get current month and day
month=$(date +%m) # Month (01 to 12)
day=$(date +%d)   # Day (01 to 31)

# Function to get the (Greatest Common Divisor) GCD
gcd() {
    if [ $2 -eq 0 ]; then
        echo $1
    else
        gcd $2 $(($1 % $2))
    fi
}

# Calc. GCD of Month and Day
gcd_result=$(gcd $month $day)

# Print POD
printf "Password of the Day : %x%02d-%02x%02d\n\n" $month $month $day $gcd_result
