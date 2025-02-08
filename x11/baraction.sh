#!/bin/bash

# set -x -e
RED='\033[0;31m'
NC='\033[0m'

function print_volume_level() {
  VOLUME=$(amixer -D default get Master | awk -F 'Left:|[][]' 'BEGIN {RS=""}{ print $3 }')
  echo -n "VOL: $VOLUME "
}

function print_disk_usage() {
  DISK_INFO=$(df -h --output=used,avail / | sed 1d  | awk '{ printf("%s (%s)", $1, $2) }')
  echo -n "Disk: $DISK_INFO "
}

function print_bat() {
  AC_STATUS="$3"
  BAT_STATUS="$6"
  # Most battery statuses fit into a single word, except "Not charging"
  # for which we need to have special handling.
  if [ "$BAT_STATUS" = "Not" ]; then
    BAT_STATUS="$BAT_STATUS $7"
    shift
  fi
  BAT_LEVEL=$(echo "$7" | tr -d ',')

  if [ "$AC_STATUS" != "" -o "$BAT_STATUS" != "" ]; then
    if [ "$BAT_STATUS" = "Discharging," ]; then
      echo -n "Battery: [$BAT_LEVEL]"
    else
      case "$AC_STATUS" in
        on-line)
          AC_STRING="On AC [$BAT_LEVEL] "
          ;;
        *)
          AC_STRING=""
          ;;
      esac
      case "$BAT_STATUS" in
        "")
          BAT_STRING="No battery"
          ;;
        *harging,|Full,)
          BAT_STRING="Battery: Full [$BAT_LEVEL]"
          ;;
        *)
          BAT_STRING="Battery: unknown"
          ;;
      esac

      FULL="${AC_STRING}${BAT_STRING}"
      if [ "$FULL" != "" ]; then
        echo -n "$FULL"
      fi
    fi
  fi
}

function print_battery_status() {
  AC_STATUS=$(acpi -a | awk '{ print $3; }') # "on-line or off-line"
  BATTERY_REGEXP='Battery \d: Discharging, \d+%, .* remaining'
  if [[ ${AC_STATUS} == "on-line" ]]; then
    # on AC
    BATTERY_STATUS="On AC"
    BATTERY_PERCENT=$(acpi -b | grep -E 'Full|Charging' | sort | awk '{ print $4; }' | tr -d ,% | head -n 1)
    echo -n "| Battery: $BATTERY_STATUS [$BATTERY_PERCENT%]"
    return
  else
    # on battery
    BATTERY_STATUS=$(acpi -b | grep -Pe "${BATTERY_REGEXP}" | awk '{ print $5; }' | head -n 1) # 07:34:52 rate
    BATTERY_TIME=${BATTERY_STATUS%:*}                       # 07:34
    BATTERY_PERCENT=$(acpi -b | grep -Pe "${BATTERY_REGEXP}" | awk '{ print $4; }' | tr -d ,% | head -n 1)
  fi

  echo -n "| Battery: $BATTERY_TIME [$BATTERY_PERCENT%]"
}

function print_gcp_project() {
  ACTIVE_PROJECT=$(gcloud config configurations list --format json --filter='is_active = true' | jq -r '.[0].name')
  echo -n " | GCP: $ACTIVE_PROJECT"
}

# Cache the output of acpi(8), no need to call that every second
ACPI_DATA=""
I=0
while :; do
  #PID="$!"
  #trap "kill $PID; exit" TERM
  if [ $I -eq 0 ]; then
    ACPI_DATA=$(acpi -a 2>/dev/null; acpi -b 2>/dev/null)
  fi
  print_disk_usage
  print_volume_level
  # print_bat $ACPI_DATA
  print_battery_status
  # print_gcp_project
  echo ""
  I=$(( ( I + 1 ) % 11 ))
  sleep 1s
done
