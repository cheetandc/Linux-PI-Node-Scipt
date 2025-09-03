#!/bin/bash

# Cesta ke skriptu v domovském adresáři uživatele
SCRIPT_PATH="$HOME/refresh_status.sh"

# Vytvoření skriptu refresh_status.sh s jednoduchým obsahem (ukázkový)
cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

REFRESH_INTERVAL=${1:-60}

cd /tmp
pi-node status > pinode_status.txt 2>&1

cat > status.html << HTML_EOF
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
HTML_EOF
EOF

# Nastavení spustitelných práv
chmod +x "$SCRIPT_PATH"
echo "Skript \"$SCRIPT_PATH\" byl vytvořen a nastaven jako spustitelný."

# Zeptat se uživatele na přidání do cronu
read -p "Chcete přidat skript do automatického spouštění v cronu každou minutu? (a/n) " answer

if [[ "$answer" =~ ^[aA]$ ]]; then
    # Přidat cron job, pokud ještě není přidaný
    CRON_JOB="* * * * * /bin/bash $SCRIPT_PATH 60 >> /tmp/refresh_status.log 2>&1"
    crontab -l 2>/dev/null | grep -F "$SCRIPT_PATH" >/dev/null
    if [ $? -eq 0 ]; then
        echo "Cron úloha již existuje."
    else
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "Cron úloha přidána: $CRON_JOB"
    fi
else
    echo "Cron úloha nebyla přidána."
fi
