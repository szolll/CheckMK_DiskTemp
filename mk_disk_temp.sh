#!/bin/bash

##############################################################################
# 
# Description   : Checkmk plugin to monitor disk temperatures (HDD, SSD, NVMe).
#                 Provides warnings and critical alerts based on temperature thresholds.
#
# Author        : Daniel Sol
# Git           : https://github.com/szolll
# Email         : daniel.sol@gmail.com
# Version       : 1.2
# License       : GNU General Public License v3.0
# Usage         : Add the plugin to the default Checkmk agent's local checks folder.
# Notes         : This script checks the temperatures of all detected disks and 
#                 outputs the results in a format compatible with Checkmk.
#                 It supports SATA, SAS, and NVMe drives. The script also verifies 
#                 the necessary tools are installed and skips execution on VMs.
#
# Checkmk Version: 2.2.0.cre
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
####################################################################################

# Check if running on a VM
if grep -qE '(vmware|virtualbox|kvm|xen|hyperv)' /proc/cpuinfo; then
  exit 0
fi

# Define temperature thresholds
CRITICAL_TEMP=60
WARNING_TEMP=50

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Ensure necessary commands are available
for cmd in smartctl nvme; do
  if ! command_exists $cmd; then
    echo "3 disk_temp - UNKNOWN - Required command '$cmd' is not installed."
    exit 3
  fi
done

# Function to check temperature of a disk
check_temp() {
  local device=$1
  local type=$2
  local temp
  local output
  local status=3

  if [ "$type" == "nvme" ]; then
    temp=$(sudo nvme smart-log $device | grep -i temperature | awk '{print $3}')
  else
    temp=$(sudo smartctl -A $device | grep -i Temperature_Celsius | awk '{print $10}')
  fi

  if [ -z "$temp" ]; then
    output="UNKNOWN - Could not read temperature for $device"
  else
    if [ "$temp" -ge "$CRITICAL_TEMP" ]; then
      status=2
      output="CRITICAL - $device temperature is $temp°C"
    elif [ "$temp" -ge "$WARNING_TEMP" ]; then
      status=1
      output="WARNING - $device temperature is $temp°C"
    else
      status=0
      output="OK - $device temperature is $temp°C"
    fi
  fi

  echo "$status disk_temp_$device temperature=$temp;${WARNING_TEMP};${CRITICAL_TEMP};0;100 $output"
  return $status
}

# Main function to check all disks
check_all_disks() {
  local exit_code=0

  # Check SATA and SAS drives
  for device in $(lsblk -dno NAME | grep -E 'sd|hd|vd'); do
    check_temp /dev/$device "sata"
    local result=$?
    if [ $result -gt $exit_code ]; then
      exit_code=$result
    fi
  done

  # Check NVMe drives
  for device in $(lsblk -dno NAME | grep -E 'nvme'); do
    check_temp /dev/$device "nvme"
    local result=$?
    if [ $result -gt $exit_code ]; then
      exit_code=$result
    fi
  done

  return $exit_code
}

# Run the check and capture the exit code
check_all_disks
exit $?
