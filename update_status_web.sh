#!/bin/bash
cd /tmp
pi-node status > pinode_status.txt 2>&1

# Vytvořit pěkné HTML
cat > status.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Pi Node Status</title>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="5">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="refresh" content="5">
    <style>
        body { font-family: monospace; background: #000; color: #0f0; padding: 20px; }
        pre { font-size: 14px; line-height: 1.2; }
    </style>
</head>
<body>
    <h1>🚀 Pi Node Status</h1>
    <p><strong>Aktualizace:</strong> $(date)</p>
    <hr>
    <pre>$(cat pinode_status.txt)</pre>
    <hr>
    <small>Auto-refresh každou minutu</small>

 <script>
  // Stránka se obnoví každých 5 sekund (5000 ms)
  setTimeout(function() {
    location.reload();
  }, 5000);
 </script>

</body>
</html>
EOF


