#!/usr/bin/env bash

package='com.moeshin.lmu.ruijie'
plist="/Library/LaunchDaemons/$package.plist"

echo "停止服务 $package"
launchctl start "$package" || exit 1

echo "卸载服务 $plist"
launchctl load "$plist" || exit 1

echo "删除服务配置 $plist"
rm "$plist" || exit 1
