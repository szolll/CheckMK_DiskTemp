# Monitor Disk Temp

Checkmk plugin to monitor disk temperatures (HDD, SSD, NVMe). Provides warnings and critical alerts based on temperature thresholds.


# Description   

Checkmk plugin to monitor disk temperatures (HDD, SSD, NVMe).
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

# Tested on
Checkmk Version: 2.2.0.cre
ram.  If not, see <https://www.gnu.org/licenses/>.

