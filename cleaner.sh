#!/bin/bash
# Removes old revisions of snaps and performs system cleanup
# Requires user to close snap applications manually

set -euo pipefail

# Function to check for running snaps and warn the user
check_running_snaps() {
  echo "--- Checking for Running Snaps ---"
  snap list | awk 'NR>1 {print $1}' | while read -r snap_name; do
    if pgrep "$snap_name" > /dev/null; then
      echo "WARNING: Snap application '$snap_name' is running. Please close it manually before proceeding."
      echo "Press Enter to confirm closure, or Ctrl+C to exit."
      read -r
      break # Stop checking after the first running snap is found.
    fi
  done
  echo "No running snaps detected (or user confirmed closure)."
  echo ""
}

# Function to display disk usage and other system information
show_disk_usage() {
  echo "--- Disk Usage Before Cleanup ---"
  echo "Snap Directory Usage:"
  du -sh /var/lib/snapd/snaps 2>/dev/null || echo "Snap directory not found."

  echo "--- APT Cache Usage ---"
  sudo du -sh /var/cache/apt 2>/dev/null || echo "APT cache directory not found."

  echo "--- Journal Disk Usage ---"
  journalctl --disk-usage || echo "Failed to retrieve journal disk usage."
  echo ""
}

# Function to monitor system load before performing heavy tasks
check_system_load() {
  local load_limit=2.0 # Define acceptable system load threshold
  local current_load
  current_load=$(awk '{print $1}' < /proc/loadavg)

  echo "--- System Load Check ---"
  echo "Current Load Average: $current_load"
  if (( $(echo "$current_load > $load_limit" | bc -l) )); then
    echo "System load is high. It's recommended to defer cleanup until the load is below $load_limit."
    echo "Proceed with caution. Press Enter to continue, or Ctrl+C to exit."
    read -r
  else
    echo "System load is within acceptable limits."
  fi
  echo ""
}

# Function to perform system cleanup
system_cleanup() {
  echo "--- Performing System Cleanup ---"

  if [[ $(id -u) -ne 0 ]]; then
    echo "Error: This script requires root privileges for system cleanup."
    return 1 # Indicate failure
  fi

  sudo apt-get autoremove -y
  sudo apt-get autoclean -y
  sudo apt-get clean -y
  sudo journalctl --vacuum-time=3d
  echo "System cleanup complete."
  echo ""
}

# Function to remove old snap revisions
remove_snap_revisions() {
  echo "--- Removing Old Snap Revisions ---"
  snap list --all | awk '/disabled/{print $1, $3}' | while read -r snapname revision; do
    echo "Removing $snapname revision $revision..."
    if ! snap remove "$snapname" --revision="$revision"; then
      echo "Failed to remove $snapname revision $revision. It may be in use or have dependencies. Please investigate."
    fi
  done
  echo "Snap revision cleanup complete."
  echo ""
}

# Main script execution
echo "--- System Cleanup Starting ---"
check_system_load
check_running_snaps
show_disk_usage

read -rp "Do you want to proceed with snap revision removal? (y/N) " proceed
if [[ ! "$proceed" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Snap revision removal cancelled."
  system_cleanup
  exit 0 # Exit gracefully
fi

remove_snap_revisions
show_disk_usage
system_cleanup

echo "--- Disk Usage After Cleanup ---"
du -sh /var/lib/snapd/snaps 2>/dev/null || echo "Snap directory not found."
echo ""
echo "Script completed successfully."
exit 0
