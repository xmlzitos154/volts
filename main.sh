#!/usr/bin/env bash

## VOLTS - A Simple script for show laptops battery status - v0.1.0

### Vars ###

NO_COLOR='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RED='\033[0;31m'

args="$1"

### Ascii ###

style1() {
    line001="    *******    "
    line002="***************"
    
    line003="$line002"
    line004="$line002"
    line005="$line002"
    line006="$line002"
    line007="$line002"
    line008="$line002"
    line009="$line002"
    line010="$line002"
    line011="$line002"
    line012="$line002"
    line013="$line002"
    line014="$line002"
    line015="$line002"
}

style2() {
    line001="    :&&&&&&:    "
    line002=":&&&&&&&&&&&&&&:"
    
    line003="$line002"
    line004="$line002"
    line005="$line002"
    line006="$line002"
    line007="$line002"
    line008="$line002"
    line009="$line002"
    line010="$line002"
    line011="$line002"
    line012="$line002"
    line013="$line002"
    line014="$line002"
    line015="$line002"
}

style3() {
    ## This one need unicode caracthers
    
    line001="    ████████    "
    line002="████████████████"
    
    line003="$line002"
    line004="$line002"
    line005="$line002"
    line006="$line002"
    line007="$line002"
    line008="$line002"
    line009="$line002"
    line010="$line002"
    line011="$line002"
    line012="$line002"
    line013="$line002"
    line014="$line002"
    line015="$line002"
}

### Data Fetch ###

BAT_PATH="/sys/class/power_supply/BAT0"
AC_PATH="/sys/class/power_supply/AC"

data_fetch() {
    capacity="$(<"$BAT_PATH/capacity")"
    status="$(<"$BAT_PATH/status")"
    current_now="$(( $(<"$BAT_PATH/current_now") / 1000 ))"
    charge_now="$(( $(<"$BAT_PATH/charge_now") / 1000 ))"
    charge_full="$(( $(<"$BAT_PATH/charge_full") / 1000 ))"
    charge_design="$(( $(<"$BAT_PATH/charge_full_design") / 1000 ))"
    cycles="$(<"$BAT_PATH/cycle_count")"
    ac_online="$(<"$AC_PATH/online")"
    [[ "$ac_online" == "1" ]] && ac_status="Plugged" || ac_status="Unplugged"
    
    local awk_health_script='BEGIN { printf "%.2f", (full/design)*100 }'
    health="$(awk -v full="$charge_full" -v design="$charge_design" "$awk_health_script")"
}

### Functions ###

print_status() {
    data_fetch
    echo -e ${YELLOW}"Capacity:          ${CYAN}${capacity}.00%"
    echo -e ${YELLOW}"AC:                ${CYAN}${ac_status}"
    echo -e ${YELLOW}"Status:            ${CYAN}${status}"
    echo -e ${YELLOW}"Current:           ${CYAN}${current_now}.000 mA"
    echo -e ${YELLOW}"Charge now:        ${CYAN}${charge_now}.000 mAh"
    echo -e ${YELLOW}"Charge full:       ${CYAN}${charge_full}.000 mAh"
    echo -e ${YELLOW}"Design capacity:   ${CYAN}${charge_design}.000 mAh"
    echo -e ${YELLOW}"Battery health:    ${CYAN}${health}%"
    echo -e ${YELLOW}"Charge cycles:     ${CYAN}${cycles:-0} (or not supported)"
}

### Execution ###

style="1"

if [[ -n "$args" ]]; then
    case "$args" in
        -s|--style)
            req="$2"
            case "$req" in
                1) style="1" ;;
                2) style="2" ;;
                3) style="3" ;;
                *) echo "Invalid style, using default" ;;
            esac
        ;;
        *) echo "Invalid argument."; exit 1 ;;
    esac
fi

case "$style" in
    1) style1 ;;
    2) style2 ;;
    3) style3 ;;
esac

print_ascii() {
    local total_lines=15
    local filled_lines
    filled_lines=$(( capacity * total_lines / 100 ))

    for i in $(seq 1 15); do
        local idx
        idx=$(printf "%03d" "$i")
        local line_var="line${idx}"
        local line_content="${!line_var}"
        local pos_from_bottom=$(( total_lines - i + 1 ))

        if (( pos_from_bottom <= filled_lines )); then
            if (( capacity <= 20 )); then
                color="$RED"
            elif (( capacity <= 50 )); then
                color="$YELLOW"
            else
                color="$GREEN"
            fi
        else
            color="$NO_COLOR"
        fi

        echo -e "${color}${line_content}${NO_COLOR}"
    done
}

data_fetch

echo
print_ascii
echo
print_status