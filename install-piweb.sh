#!/bin/bash

# Vytvoření refresh_status.sh v ~
cat << 'EOF' > ~/refresh_status.sh
#!/bin/bash
echo "Aktualizace statusu: $(date)" >> ~/status.log
EOF

chmod +x ~/refresh_status.sh
echo "Soubor refresh_status.sh byl vytvořen a nastaven jako spustitelný."

# Zeptat se na automatické spouštění (crontab)
read -p "Chcete přidat refresh_status.sh do automatického spouštění (crontab)? [A/n]: " autostart
if [[ "$autostart" =~ ^([aA]|[aA][nN][yY])$ || "$autostart" == "" ]]; then
    (crontab -l 2>/dev/null; echo "*/10 * * * * $HOME/refresh_status.sh") | crontab -
    echo "Přidáno do crontabu (každých 10 minut)."
else
    echo "Automatické spouštění nepřidáno."
fi

# Vytvoření skriptu pro Python HTTP server (port 8080)
cat << 'EOF' > ~/pyhttp_server.sh
#!/bin/bash
nohup python3 -m http.server 8080 --bind 127.0.0.1 > ~/pyhttp_server.log 2>&1 &
EOF

chmod +x ~/pyhttp_server.sh
echo "Soubor pyhttp_server.sh byl vytvořen a nastaven jako spustitelný."

# Test binary nohup, instalace fallsback
if command -v nohup &> /dev/null ; then
    echo "nohup je nainstalovaný."
else
    echo "nohup není nainstalovaný. Provádím instalaci..."
    sudo apt update && sudo apt install coreutils -y
fi

# Spustit python server rovnou
~/pyhttp_server.sh
echo "Python HTTP server byl spuštěn na pozadí (port 8080, log ~/pyhttp_server.log)."

# Přidat spouštění python serveru do cronu po restartu
(crontab -l 2>/dev/null; echo "@reboot $HOME/pyhttp_server.sh") | crontab -
echo "Python HTTP server bude spuštěn po restartu systému automaticky."
