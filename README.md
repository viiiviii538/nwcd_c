# nwcd_c

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installing Python Dependencies and Nmap

This project includes a Python script for network diagnostics located at `scripts/network_scanner/scanner.py`. The script only requires Python 3 but it relies on the `nmap` command being available on the system.

### Install Python

Make sure Python 3 is installed. On most platforms it is already available. If not, install it via your system package manager.

### Install nmap

Install the `nmap` tool so that port scanning works correctly:

- **Ubuntu/Linux**: `sudo apt-get install nmap`
- **macOS**: `brew install nmap`
- **Windows**: `choco install nmap` or download it from [nmap.org](https://nmap.org/). Ensure that the `nmap` executable is in your `PATH`.

No additional Python packages are required for the scanner script.

## Running `scanner.py` Manually

You can execute the scanner directly from the command line. Pass one or more target hosts and optionally `--json` to get structured output:

```bash
python3 scripts/network_scanner/scanner.py 192.168.1.1 --json
```

Some `nmap` scans need elevated permissions. On Linux and macOS run the command with `sudo`; on Windows start the terminal as *Administrator*.

## How the Flutter App Invokes the Script

When the user taps the **診断開始** button on the home screen, the Flutter app launches the Python script using `Process.run` from `dart:io`. The script is executed with the `--json` flag and the results are parsed to populate the widgets on the result page.

Make sure that both Python and `nmap` are installed on the device where the Flutter application runs. Administrator/root privileges may be required for the script to collect all network information.

