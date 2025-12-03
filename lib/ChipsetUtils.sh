#!/usr/bin/env bash

# ChipsetUtils: check if chipset is supported
check_chipset() {
    if [[ "$1" == "" ]]; then printf "\033[31mInvalid input, chipset appears invalid\033[0m\n"; exit 1; fi

    # =================== < CONFIG > ===================
    local CHIPSET_LIST
    if [[ -d "misc" ]]; then
        readonly CHIPSET_LIST="misc/devices.xml" # chipset file list
    elif [[ -d "../misc" ]]; then
        readonly CHIPSET_LIST="../misc/devices.xml" # chipset file list
    else
        printf "\033[31mCan't find required resources\033[0m\n"
    fi
    local SUPPORT_AP="" # check if chipset support ap mode
    local SUPPORT_MO="" # check if chipset support monitor mode
    # =================== < CONFIG > ===================

    if [[ ! -f "$CHIPSET_LIST" ]]; then 
        echo "Can't open file"
    fi

    local line
    line=$(grep -n "$1" "$CHIPSET_LIST" | cut -d ":" -f1 | head -n 1) # get current position of chipset
    local length
    length=$(wc -l "$CHIPSET_LIST" | awk '{print $1}')
    if [[ "$line" == "" ]]; then printf "\033[31mChipset is not in list\033[0m\n"; exit 1; fi # Catch if chipset is not present

    local cout=$line
    local i=$cout
    while true;do
        local data
        data=$(sed -n -e "${cout}p" "$CHIPSET_LIST")
        local iden
        iden=$(echo "$data" | cut -d ">" -f1 | cut -d "<" -f2)
        local row
        row=$(echo "$data" | cut -d ">" -f2 | cut -d "<" -f1)

        if [[ "$iden" == "AP" ]]; then
            case $row in
                y) printf "\033[32mChipset support ap mode\033[0m\n"; SUPPORT_AP=true;;
                n) printf "\033[31mChipset doesn't support ap mode\033[0m\n"; SUPPORT_AP=false;;
                ?) printf "\033[33mNo information if chipset support ap mode\033[0m\n"; SUPPORT_AP=unknown;;
            esac
        fi

        if [[ "$iden" == "Monitor" ]]; then
            case $row in
                y) printf "\033[32mChipset support monitor mode\033[0m\n"; SUPPORT_MO=true;;
                n) printf "\033[31mChipset doesn't support monitor mode\033[0m\n"; SUPPORT_MO=false;;
                ?) printf "\033[33mNo information if chipset support monitor mode\033[0m\n"; SUPPORT_MO=unknown;;
            esac
        fi

        if [[ "$SUPPORT_MO" == false || "$SUPPORT_MO" == true ]] && [[ "$SUPPORT_AP" == false || "$SUPPORT_AP" == true ]]; then break; fi

        cout=$((cout + 1))
        if [[ $cout -gt $length ]] || [[ "$cout" -eq $((i + 10)) ]]; then printf "\033[33mDon't receive all required information\033[0m\n"; break; fi # Catch out of range
    done

    if [[ "$SUPPORT_AP" == true ]] && [[ "$SUPPORT_MO" == true ]]; then return 0; else return 1; fi
}
