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

## Network Scanner

The `scripts/network_scanner` directory contains a Python-based security scanner.
Before running it, install its dependencies:

```bash
pip install -r scripts/network_scanner/requirements.txt
```

You can then execute the scanner by providing target hosts:

```bash
python scripts/network_scanner/scanner.py 192.168.1.1
```
