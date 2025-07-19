# nwcd_c

This Flutter project contains a minimal home screen with three tabs:
**リアルタイム診断** for a quick real-time scan, **フルスキャン** for a full
network scan, and **ネットワーク図** for displaying a network diagram.
Pressing either scan button shows a short progress indicator. Once the
actual scanning logic is implemented, each workflow will navigate to a results
page summarizing the findings.

## Workflows

### Real-time scan
1. Tap **リアルタイム** on the home screen.
2. The app performs a quick scan and displays a progress indicator.
3. When finished, it navigates to the results page.

### Full scan
1. Tap **フルスキャン** on the home screen.
2. A more thorough scan is executed and a progress indicator is shown.
3. The workflow invokes **device_version_scan** to collect OS, firmware,
   and installed software versions from discovered devices.
4. After completion, the app navigates to the results page.

### Network diagram
1. Tap **ネットワーク図** on the home screen.
2. A placeholder diagram is displayed showing where network visuals will appear.

**Note:** Only scan devices or networks that you own or are explicitly
authorized to test. Unauthorized or intrusive scanning can be illegal and may
violate terms of service or trigger security defenses.

### Device version scan
The `device_version_scan` workflow gathers operating system, firmware, and
software versions from devices found in a full scan. It uses tools such as
`nmap` with service detection or vendor APIs (SNMP, HTTP, etc.) to query each
host and report version details. The information can reveal outdated or
vulnerable software running on the network.

#### Dependencies and setup
1. Install **nmap** so that the scan can perform service and version detection:
   ```bash
   sudo apt-get update && sudo apt-get install -y nmap
   ```
2. Ensure the `nmap` command is in your `PATH` and accessible to the app.
3. Configure any vendor-specific APIs or authentication if required.

**Caution:** Performing version scans can trigger security alerts and may be
illegal without permission. Always obtain authorization before scanning devices.

## Running the app
1. Install Flutter and fetch dependencies with `flutter pub get`.
2. Launch the app using `flutter run`.

## Running tests
Once tests are added under the `test/` directory, execute them with:

```bash
flutter test
```

For general Flutter setup instructions, see the [online documentation](https://docs.flutter.dev/).
