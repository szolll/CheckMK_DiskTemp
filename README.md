Checkmk plugin to monitor disk temperatures (HDD, SSD, NVMe). Provides warnings and critical alerts based on temperature thresholds.


Description   : Checkmk plugin to monitor disk temperatures (HDD, SSD, NVMe).
                 Provides warnings and critical alerts based on temperature thresholds.

Author        : Daniel Sol
Git           : https://github.com/szolll
Email         : daniel.sol@gmail.com
Version       : 1.2
License       : GNU General Public License v3.0
Usage         : Add the plugin to the default Checkmk agent's local checks folder.

Notes         : This script checks the temperatures of all detected disks and 
                 outputs the results in a format compatible with Checkmk.
                 It supports SATA, SAS, and NVMe drives. The script also verifies 
                 the necessary tools are installed and skips execution on VMs.

# Checkmk Version: 2.2.0.cre

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

