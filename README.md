# nwcd_c

This Flutter project contains a minimal home screen with a single **診断開始** button. Pressing the button briefly shows a progress indicator.

## Responsible Use

The included scanning functionality is intended for educational and authorized testing only. **Do not scan networks that you do not own or explicitly have permission to test.** Unauthorized scanning may be illegal and could violate terms of service. Always ensure that you have obtained proper authorization before performing any scans.

For general Flutter setup instructions, see the [online documentation](https://docs.flutter.dev/).

## Port Scan Usage

Launch the app on your device or emulator and tap **診断開始** (Start scan). A progress indicator appears while the scan is running. Once finished, the results page lists any open ports that were detected.

Danger ports are those commonly used for remote administration (for example, 22, 23, or 3389). If one of these is open, it may expose your device to risk. Such ports are highlighted in the results list.

### Privacy and security notes

* Only scan devices and networks that you have permission to test.
* Port scanning can reveal sensitive service information. Handle the results carefully and avoid sharing them publicly.

### Running tests

After installing Flutter, run:

```bash
flutter test
```

The provided tests use the `flutter_test` package to verify that the scan button shows a progress indicator.

### Platform considerations

The scan requires network access. Some operating systems may block scanning without administrative rights or a wired connection. If scanning fails, try running with elevated permissions or on a direct network link.
