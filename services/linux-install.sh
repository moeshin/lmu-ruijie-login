#!/usr/bin/env bash

service='lmu-ruijie.service'
workdir="$(cd "$(dirname "$0")" && pwd)"
file="/usr/local/lib/systemd/system/$service"

echo "生成服务配置 $file"

echo "[Unit]
Description=黎明大学-锐捷自动登录
After=network.target

[Service]
Type=simple
User=root
ExecStart=\"$workdir/login\" ping

[Install]
WantedBy=multi-user.target" > "$file" || exit 1

echo 重载服务配置
systemctl daemon-reload || exit 1

echo "允许自启 $service"
systemctl enable "$service" || exit 1

echo "启动服务 $service"
systemctl start "$service" || exit 1
