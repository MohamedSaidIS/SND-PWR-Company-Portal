#!/bin/bash
set -e

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
UNPACK_DIR="apk_unpacked"

echo "📂 Checking .so files inside $APK_PATH ..."

# تنظيف أي نسخة سابقة
rm -rf $UNPACK_DIR
mkdir -p $UNPACK_DIR

# فك الـ APK
unzip -oq "$APK_PATH" -d "$UNPACK_DIR"

# تأكد إن readelf موجود
if ! command -v readelf &> /dev/null
then
    echo "❌ readelf command not found. Please install binutils."
    exit 1
fi

# فحص كل مكتبة .so
find "$UNPACK_DIR/lib" -type f -name "*.so" | while read sofile; do
  ALIGN_HEX=$(readelf -l "$sofile" | grep 'LOAD' | awk '{print $NF}' | head -1)

  # لو مش لاقي قيمة ALIGN
  if [ -z "$ALIGN_HEX" ]; then
    echo "➡️ $sofile  (ALIGN=Unknown)"
    continue
  fi

  # حول من hex لـ decimal
  ALIGN_DEC=$((ALIGN_HEX))

  echo "➡️ $sofile  (ALIGN=$ALIGN_HEX / $ALIGN_DEC)"

  if [ "$ALIGN_DEC" -ge 16384 ]; then
    echo "   ✅ Compliant with 16KB page size"
  else
    echo "   ⚠️  Not compliant with 16KB page size"
  fi
done
