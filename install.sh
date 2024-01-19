#!/bin/bash

# Instalar Cockpit
echo "Instalando Cockpit..."
sudo apt-get update
sudo apt-get install -y cockpit

# Preguntar por el valor del servidor
read -p "Introduce el valor X para el servidor (vm-diverso-lab.us.es/admin/X): " server_value

# Crear o modificar el archivo cockpit.conf
cockpit_conf="/etc/cockpit/cockpit.conf"
echo "Configurando $cockpit_conf..."

# Usar 'tee' para redirigir la salida al archivo de configuración
sudo tee "$cockpit_conf" > /dev/null << EOF
[WebService]
AllowUnencrypted=true
UrlRoot=/admin/$server_value/
ProtocolHeader = X-Forwarded-Proto
ForwardedForHeader = X-Forwarded-For

[Log]
Fatal = /var/log/cockpit.log
EOF

echo "Configuración de Cockpit actualizada."

# Reiniciar Cockpit para aplicar los cambios
sudo systemctl restart cockpit

echo "Instalación y configuración completadas."
