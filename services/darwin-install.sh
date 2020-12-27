#!/usr/bin/env bash

package='com.moeshin.lmu.ruijie'
workdir="$(cd "$(dirname "$0")" && pwd)"
plist="/Library/LaunchDaemons/$package.plist"

echo "生成服务配置 $plist"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>$package</string>
    <key>ProgramArguments</key>
    <array>
        <string>$workdir/login</string>
        <string>ping</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>$workdir</string>
    <key>StandardErrorPath</key>
    <string>$workdir/log.txt</string>
</dict>
</plist>" > "$plist"

echo "加载服务配置 $plist"
launchctl load "$plist" || exit 1

echo "启动服务 $package"
launchctl start "$package" || exit 1

echo "稍后可以在 \"$workdir/log.txt\" 查看日志"
