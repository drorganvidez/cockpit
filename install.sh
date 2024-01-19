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

# Reiniciar Cockpit para aplicar los cambios
echo "Reiniciando Cockpit..."
sudo systemctl restart cockpit
echo "Configuración de Cockpit actualizada."

# Crear un archivo de configuración para NetworkManager para corregir el bug
echo "Creando archivo de configuración de NetworkManager..."
sudo tee /etc/NetworkManager/conf.d/10-globally-managed-devices.conf > /dev/null << EOF
[keyfile]
unmanaged-devices=none
EOF

# Configurar una interfaz de red dummy
echo "Configurando interfaz de red dummy..."
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

echo "Se realizará un reinicio del sistema para aplicar todos los cambios."
read -p "Presiona Enter para continuar con el reinicio..."

# Reiniciar el sistema
sudo reboot
