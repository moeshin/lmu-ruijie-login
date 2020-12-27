#!/usr/bin/env bash

service='lmu-ruijie.service'
workdir="$(cd "$(dirname "$0")" && pwd)"

echo "[Unit]
Description=黎明大学-锐捷自动登录
After=network.target

[Service]
Type=simple
User=root
ExecStart=\"$workdir/login\" ping

[Install]
WantedBy=multi-user.target" > "/usr/local/lib/systemd/system/$service"

echo 加载配置
systemctl daemon-reload || exit 1

echo "允许自启 $service"
systemctl enable "$service" || exit 1

echo "启动服务 $service"
systemctl start "$service" || exit 1
