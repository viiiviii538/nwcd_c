#!/bin/bash
set -e

echo "🌱 Flutterをインストール中..."
if [ ! -d /usr/local/flutter ]; then
  git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
else
  echo "✅ Flutterは既に入ってるよ"
fi

export PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"

echo "🔧 バージョン確認中..."
flutter --version

echo "📦 依存取得中..."
flutter pub get

