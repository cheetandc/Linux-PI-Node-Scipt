# Vytvoření refresh_status.sh v ~
cat << 'EOF' > ~/refresh_status.sh
#!/bin/bash
echo "Aktualizace statusu: $(date)" >> ~/status.log
EOF

chmod +x ~/refresh_status.sh
echo "Soubor refresh_status.sh byl vytvořen a nastaven jako spustitelný."

# Zeptání na automatické spouštění
read -p "Chcete přidat refresh_status.sh do automatického spouštění (crontab)? [A/n]: " autostart
if [[ "$autostart" =~ ^([aA]|[aA][nN][yY])$ || "$autostart" == "" ]]; then
    CRON_REFRESH="*/10 * * * * $HOME/refresh_status.sh"
    crontab -l 2>/dev/null | grep -F "$CRON_REFRESH" > /dev/null
    if [ $? -ne 0 ]; then
        (crontab -l 2>/dev/null; echo "$CRON_REFRESH") | crontab -
        echo "refresh_status.sh bylo přidáno do crontabu."
    else
        echo "refresh_status.sh už v crontabu je."
    fi
else
    echo "Automatické spouštění nepřidáno."
fi

# Vytvoření skriptu pro Python HTTP server
cat << 'EOF' > ~/pyhttp_server.sh
#!/bin/bash
nohup python3 -m http.server 8080 --bind 0.0.0.0 > ~/pyhttp_server.log 2>&1 &
EOF

chmod +x ~/pyhttp_server.sh
echo "Soubor pyhttp_server.sh byl vytvořen a nastaven jako spustitelný."

if command -v nohup &> /dev/null ; then
    echo "nohup je nainstalovaný."
else
    echo "nohup není nainstalovaný. Provádím instalaci..."
    sudo apt update && sudo apt install coreutils -y
fi

~/pyhttp_server.sh
echo "Python HTTP server byl spuštěn na pozadí (port 8080, log ~/pyhttp_server.log)."

# Přidání spouštění pyhttp_server.sh po rebootu jen pokud tam není
CRON_HTTP="@reboot $HOME/pyhttp_server.sh"
crontab -l 2>/dev/null | grep -F "$CRON_HTTP" > /dev/null
if [ $? -ne 0 ]; then
    (crontab -l 2>/dev/null; echo "$CRON_HTTP") | crontab -
    echo "pyhttp_server.sh bylo přidáno do crontabu (po restartu)."
else
    echo "pyhttp_server.sh už v crontabu je."
fi
