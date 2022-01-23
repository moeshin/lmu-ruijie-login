#!/usr/bin/env bash

service='lmu-ruijie-login.service'

echo "停止服务 $service"
systemctl start "$service" || exit 1

echo "禁用自启 $service"
systemctl disable "$service" || exit 1

file="/usr/local/lib/systemd/system/$service"
echo "删除服务配置 $file"
rm "$file" || exit 1

echo 重载服务配置
systemctl daemon-reload || exit 1
