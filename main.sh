#!/usr/bin/env bash

## VOLTS - A Simple script for show laptops battery status

version="0.1.1"

### Vars ###

NO_COLOR='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RED='\033[0;31m'

args="$1"

compact_mode=0

### Ascii ###

style1() {
    line001="    *******    "
    line002="***************"
    
    for i in $(seq -w 3 15); do
        declare -g "line0$i=$line002"
    done
}

style2() {
    line001="    :&&&&&&:    "
    line002=":&&&&&&&&&&&&&&:"
    
    for i in $(seq -w 3 15); do
        declare -g "line0$i=$line002"
    done
}

style3() {
    ## This one need unicode caracthers.
    line001="    ████████    "
    line002="████████████████"
    
    for i in $(seq -w 3 15); do
        declare -g "line0$i=$line002"
    done
}

style4() {
    ## This one too.
    line001="    ████████    "
    
    for i in $(seq 2 5); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=░░░░░░░░░░░░░░░░"
    done
    
    for i in $(seq 6 11); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
    done
    
    for i in $(seq 12 15); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=████████████████"
    done
}

style5() {
    ## Compact style
    line001="    *******    "
    line002="***************"
    
    for i in $(seq 3 11); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=$line002"
    done
    
    compact_mode=1
}

style6() {
    ## Compact style
    
    line001="    :&&&&&&:    "
    line002=":&&&&&&&&&&&&&&:"
    
    for i in $(seq 3 11); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=$line002"
    done
    
    compact_mode=1
}

style7() {
    ## This one need unicode caracthers (Compact style)
    
    line001="    ████████    "
    line002="████████████████"
    
    for i in $(seq 3 11); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=$line002"
    done
    
    compact_mode=1
}

style8() {
    ## This one too (Compact style)
    line001="    ████████    "
    
    for i in $(seq 2 4); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=░░░░░░░░░░░░░░░░"
    done
    
    for i in $(seq 5 8); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
    done
    
    for i in $(seq 9 11); do
        printf -v idx "%02d" "$i"
        declare -g "line0$idx=████████████████"
    done
    
    compact_mode=1
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

data_fetch

### Functions ###

print_status() {
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

display_version() {
    echo "volts $version"
    exit 0
}

help_message() {
    echo "usage: volts [ -v | -s | -h ]"
    echo "usage: volts [ --version | --style | --help ]"
    echo -e "\n-s [NUM]     change battery style (available styles: 5)"
    echo -e "-h, --help     show this message again"
    echo -e "-v, --version  show program version\n"
    display_version
    exit 0
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
                4) style="4" ;;
                5) style="5" ;;
                6) style="6" ;;
                7) style="7" ;;
                8) style="8" ;;
                *) echo "Invalid style, using default" ;;
            esac
        ;;
        -v|--version) display_version ;;
        -h|--help)    help_message ;;
        *)            echo "Invalid argument."; exit 1 ;;
    esac
fi

case "$style" in
    1) style1 ;;
    2) style2 ;;
    3) style3 ;;
    4) style4 ;;
    5) style5 ;;
    6) style6 ;;
    7) style7 ;;
    8) style8 ;;
esac

print_ascii() {
    local total_lines=15
    [[ "$compact_mode" == "1" ]] && total_lines=11
    local filled_lines
    filled_lines=$(( (capacity * total_lines + 99) / 100 ))
    
    for i in $(seq 1 "$total_lines"); do
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

echo
print_ascii
echo
print_status