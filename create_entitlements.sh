#!/bin/bash

# Скрипт для создания entitlements файла для TrollStore
echo "Создание entitlements файла..."

mkdir -p iSponsorBlockTV

cat > iSponsorBlockTV/TrollStore.entitlements << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>platform-application</key>
    <true/>
    <key>com.apple.private.security.no-container</key>
    <true/>
    <key>com.apple.security.app-sandbox</key>
    <false/>
    <key>com.apple.security.get-task-allow</key>
    <true/>
</dict>
</plist>
EOF

echo "Entitlements файл создан успешно!" 