# nwcd_c

This Flutter project contains a minimal home screen with two buttons:
**リアルタイム** for a quick real-time scan and **フルスキャン** for a full
network scan. Pressing either button shows a short progress indicator. Once the
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
3. After completion, the app navigates to the results page.

**Note:** Only run network scans against systems you are authorized to test.
Unauthorized scanning can be illegal or violate terms of service.

## Running the app
1. Install Flutter and fetch dependencies with `flutter pub get`.
2. Launch the app using `flutter run`.

## Running tests
Once tests are added under the `test/` directory, execute them with:

```bash
flutter test
```

For general Flutter setup instructions, see the [online documentation](https://docs.flutter.dev/).
