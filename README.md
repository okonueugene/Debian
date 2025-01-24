# cleaner.sh

This script helps clean up old snap revisions and perform general system maintenance on Ubuntu (and other Debian-based) systems. It also includes checks for running snaps and high system load before proceeding with cleanup operations.

## Features

*   **Snap Revision Removal:** Removes disabled snap revisions to free up disk space.
*   **System Cleanup:** Performs `apt autoremove`, `apt autoclean`, `apt clean`, and `journalctl --vacuum-time=3d` to clean up unused packages, APT cache, and system logs.
*   **Running Snap Check:** Warns the user if any snap applications are running and requires manual closure before proceeding with snap removal.
*   **System Load Check:** Checks the current system load and warns the user if it's high, suggesting to postpone the cleanup.
*   **Error Handling:** Includes basic error handling to gracefully handle situations like missing directories or failed commands.
*   **Clear Output:** Provides informative messages throughout the script to indicate progress and potential issues.

## Prerequisites

*   A Debian-based Linux distribution (e.g., Ubuntu, Debian, Mint).
*   `snapd` must be installed if you want to use the snap revision removal functionality.
*   `apt` package manager.
*   `journalctl` for log management.
*   `bc` for floating-point arithmetic in load checking.

## How to Use

1.  **Download the script:** Download the `cleaner.sh` script to your local machine. You can do this by copying the script content and saving it to a file named `cleaner.sh`.

2.  **Make the script executable:** Open a terminal and navigate to the directory where you saved the script. Then, run the following command:

    ```bash
    chmod +x cleaner.sh
    ```

3.  **Run the script:** Execute the script using `sudo` because some cleanup operations require root privileges:

    ```bash
    sudo ./cleaner.sh
    ```

## Script Execution Flow

1.  **System Load Check:** The script first checks the current system load. If it's above a defined threshold (2.0 by default), it warns the user.
2.  **Running Snap Check:** It checks for any running snap applications and prompts the user to close them manually.
3.  **Initial Disk Usage:** Displays disk usage information for snap directory, APT cache, and journal logs.
4.  **Confirmation:** Asks the user to confirm if they want to proceed with snap revision removal.
5.  **Snap Revision Removal (if confirmed):** Removes old snap revisions.
6.  **Disk Usage After Snap Removal:** Displays disk usage information again to show the effect of the cleanup.
7.  **System Cleanup:** Performs system cleanup operations using `apt` and `journalctl`.
8.  **Final Disk Usage:** Displays disk usage information again.
9.  **Completion Message:** Displays a message indicating successful completion.

## Error Handling

The script includes basic error handling:

*   Uses `|| echo "message"` to display messages if certain commands fail (e.g., if a directory is not found).
*   Checks the exit status of `snap remove` and displays a message if a specific revision cannot be removed.

## Customization

*   **Load Threshold:** You can change the system load threshold in the `check_system_load()` function by modifying the `load_limit` variable.

## Example

```bash
sudo ./cleaner.sh
```

## Contributing

If you find this script useful and want to contribute, please fork the repository and create a pull request. Your contributions are appreciated!

## License

This script is released under the [MIT License](LICENSE).

## Author

This script was created by [Okonu Eugene](https://github.com/okonueugene).

## Acknowledgments

The reccomendations I obtained from various online articles.

1. [7 Simple Ways to Free Up Space on Ubuntu and Linux Mint](https://itsfoss.com/free-up-space-ubuntu-linux/)

2. [8 Ways to Maintain a Clean, Lean Ubuntu Machine](https://www.maketecheasier.com/8-ways-to-maintain-a-clean-lean-ubuntu-machine/)

## Special Thanks

Special thanks to [GitHub](https://github.com) for providing a platform for sharing code and inspiring others.
