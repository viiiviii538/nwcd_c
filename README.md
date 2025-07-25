# nwcd_c

This Flutter project contains a minimal home screen with four tabs:
**リアルタイム診断** for a quick real-time scan, **フルスキャン** for a full
network scan, **ネットワーク図** for displaying a network diagram, and
**リスクまとめ** for a brief overview of common security risks.
Pressing either scan button shows a short progress indicator. Once the
actual scanning logic is implemented, each workflow will navigate to a results
page summarizing the findings.

## Setup

This project targets **Flutter 3.29.2** with **Dart 3.7.2**. After installing
Flutter, fetch dependencies with:

```bash
flutter pub get
```

The project depends on the `charts_flutter` package for displaying charts in
the risk summary demo.

See [CONTRIBUTING.md](CONTRIBUTING.md) for additional details.

## Required command-line tools

The app relies on several external utilities when available:

- **nmap** for port and version scanning.
- **ip**/ **ifconfig** and **arp** (or their Windows equivalents) for network discovery.

If these tools are missing, the scanner falls back to limited functionality.

### Installing the tools

On Debian/Ubuntu:

```bash
sudo apt-get install nmap iproute2 net-tools
```

On macOS with Homebrew:

```bash
brew install nmap iproute2mac
```

On Windows (using Chocolatey):

```powershell
choco install nmap
```

## Workflows

### Real-time scan
1. Tap **リアルタイム** on the home screen.
2. The app performs a quick scan and displays a progress indicator.
3. When finished, it navigates to the results page.

### Full scan
1. Tap **フルスキャン** on the home screen.
2. A more thorough scan is executed and a progress indicator is shown.
3. After completion, the app navigates to the results page.

### Network diagram
1. Tap **ネットワーク図** on the home screen.
2. A placeholder diagram is displayed showing where network visuals will appear.

### リスクまとめ
1. Tap **リスクまとめ** on the home screen.
2. A single page lists common network security risks for quick reference and
   includes a demo table and pie chart summarizing recent connections by
   destination country.
   - 無許可のネットワークスキャンは違法となる可能性があります。
   - 不要な開放ポートは攻撃の入口となります。
   - OSやソフトウェアの未更新は既知の脆弱性(CVE)悪用に繋がります。
   - デバイス/ソフトウェアのバージョンを把握し、脆弱性情報と照合することが重要です。
   - デフォルト/弱いパスワードの利用
   - 安全でないプロトコル (HTTP/Telnet) の使用
   - 管理インターフェースの外部公開
   - ネットワーク分割や監視体制の不足
   - 危険なポートが開いている機器のリスト表示
   - 通信量が異常な機器のランキング表示

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
