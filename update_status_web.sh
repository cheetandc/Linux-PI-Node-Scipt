#!/bin/bash

# Nastavení intervalu (default 60 sekund)
REFRESH_INTERVAL=${1:-60}

cd /tmp
pi-node status > pinode_status.txt 2>&1

# Vytvořit pěkné HTML s jednou metodou auto-refresh (meta tag)
cat > status.html << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pi Node Status</title>
    <meta http-equiv="refresh" content="${REFRESH_INTERVAL}">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <style>
        body { font-family: monospace; background: #000; color: #0f0; padding: 20px; }
        pre { font-size: 14px; line-height: 1.2; white-space: pre-wrap; }
    </style>
</head>
<body>
    <h1>🚀 Pi Node Status</h1>
    <p><strong>Aktualizace:</strong> $(date)</p>
    <hr>
    <pre>$(cat pinode_status.txt)</pre>
    <hr>
    <small>Auto-refresh každých ${REFRESH_INTERVAL} sekund</small>
</body>
</html>
EOF
