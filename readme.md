# 🐧 Linux: Comandos Esenciales de Bash  

Esta guía cubre los comandos básicos para gestionar unidades USB y conectarse a Internet en Linux.  

---

## 🔍 Listar dispositivos USB  

### 1. Ver todos los dispositivos conectados por USB  

```bash
lsusb -t
```  

Este comando muestra la jerarquía de dispositivos USB conectados al sistema.  

### 2. Listar dispositivos de almacenamiento y sus particiones  

```bash
sudo fdisk -l
```  

Este comando muestra una lista de discos y particiones detectadas en el sistema.  
Los dispositivos USB generalmente aparecen como `/dev/sdb`, `/dev/sdc`, etc.  

---

## 📂 Montar una unidad USB  

Antes de montar la unidad, se recomienda crear un directorio específico para el punto de montaje:  

```bash
sudo mkdir -p /mnt/usb-drive
```  

Luego, monta la unidad con:  

```bash
sudo mount /dev/sdb1 /mnt/usb-drive
```  

📌 **Nota:** Asegúrate de reemplazar `/dev/sdb1` con la partición correcta de tu USB, verificándola con `sudo fdisk -l`.  

---

## ❌ Desmontar una unidad USB  

Para desmontar la unidad USB de forma segura, usa:  

```bash
sudo umount /mnt/usb-drive
```  

Si la unidad está en uso y no puede desmontarse, puedes forzar el desmontaje con:  

```bash
sudo umount -l /mnt/usb-drive
```  

---

## 💾 Formatear una unidad USB  

⚠️ **Advertencia:** Este proceso eliminará todos los datos de la unidad. Asegúrate de seleccionar el dispositivo correcto antes de continuar.  

### 1. Identificar la unidad USB  

```bash
sudo fdisk -l
```  

Ubica el nombre del dispositivo (ejemplo: `/dev/sdb`).  

### 2. Desmontar la unidad (si está montada)  

```bash
sudo umount /dev/sdb1
```  

### 3. Formatear en distintos sistemas de archivos  

#### 🟢 **FAT32** (compatible con la mayoría de los sistemas operativos)  

```bash
sudo mkfs.vfat -F32 /dev/sdb1
```  

#### 🔵 **exFAT** (ideal para archivos grandes y compatibilidad moderna)  

```bash
sudo mkfs.exfat /dev/sdb1
```  

#### 🔴 **EXT4** (para uso exclusivo en Linux)  

```bash
sudo mkfs.ext4 /dev/sdb1
```  

### 4. Verificar el formateo  

Después de formatear, puedes comprobar la estructura del sistema de archivos con:  

```bash
sudo lsblk -f
```  

Para asignar una etiqueta a la unidad:  

```bash
sudo e2label /dev/sdb1 MiUSB  # Para EXT4  
sudo fatlabel /dev/sdb1 MiUSB  # Para FAT32  
sudo exfatlabel /dev/sdb1 MiUSB  # Para exFAT  
```  

---

## 🌐 Conectarse a Internet  

### 1. Verificar la conexión a Internet  

Para comprobar si tienes conexión a Internet, ejecuta:  

```bash
ping -c 4 google.com
```  

Si no hay respuesta, revisa la conexión de red con:  

```bash
ip a
```  

### 2. Conectarse a una red Wi-Fi (usando `nmcli`)  

Para listar las redes Wi-Fi disponibles:  

```bash
nmcli device wifi list
```  

Para conectarte a una red Wi-Fi:  

```bash
nmcli device wifi connect "SSID" password "CONTRASEÑA"
```  

(Reemplaza `"SSID"` con el nombre de la red y `"CONTRASEÑA"` con la clave de acceso.)  

Para verificar la conexión:  

```bash
nmcli connection show --active
```  

### 3. Conectarse a Internet por cable (Ethernet)  

Normalmente, Linux detecta y usa automáticamente la conexión por cable.  
Si necesitas activarla manualmente, usa:  

```bash
sudo dhclient eth0
```  

Para verificar la configuración de red:  

```bash
ip r
```  

### 4. Reiniciar la red en caso de problemas  

Si la conexión no funciona correctamente, puedes reiniciar el servicio de red:  

```bash
sudo systemctl restart NetworkManager
```  
---

## 🔧 Hacer un dispositivo booteable con `dd`

1. Crear un dispositivo booteable con una imagen ISO

Para crear un dispositivo booteable (por ejemplo, para una instalación de Linux) con una imagen .iso en una unidad USB, usa el comando dd. Asegúrate de reemplazar /dev/sdX con el dispositivo correcto (por ejemplo, /dev/sdb) y path/to/image.iso con la ubicación de tu archivo ISO.

```bash
dd bs=4M if=path/to/image.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress
```

> 📌 Nota: El comando dd sobrescribirá todo en el dispositivo de destino, así que asegúrate de que estás eligiendo la unidad correcta.

2. Verificar que el dispositivo sea booteable

Después de crear el dispositivo booteable, puedes verificar que esté listo para arrancar revisando la tabla de particiones con:

```bash
sudo fdisk -l /dev/sdX
```

--

## 🧹 Limpiar una tarjeta SD con `dd`

Si deseas limpiar completamente una tarjeta SD o una unidad USB (es decir, sobrescribir todos sus datos), puedes usar dd para llenar el dispositivo con ceros. Este proceso eliminará permanentemente todos los datos en la unidad.

```bash
sudo dd if=/dev/zero of=/dev/sdX bs=4M status=progress && sync
```

--

## ⚙️ Gestionar procesos en Linux

### 1. 👀 Ver procesos en ejecución

Para ver los procesos en ejecución en tu sistema, puedes usar el comando `ps`. Para una lista más detallada de los procesos, puedes usar:

```bash
ps aux
```

Este comando muestra una lista completa de todos los procesos que se están ejecutando en el sistema, junto con información como el usuario que ejecuta el proceso, el uso de CPU y memoria, y el comando que inició el proceso.

### 2. 🔄 Ver procesos en tiempo real

Si deseas ver los procesos en tiempo real y cómo cambian en el sistema, puedes usar el comando `top`:

```bash
top
```

Este comando muestra los procesos más intensivos en recursos de CPU y memoria. Puedes actualizar la información en tiempo real presionando `q` para salir del comando.

### 3. 🔍 Buscar un proceso específico

Si necesitas buscar un proceso en específico, puedes usar `grep` con el comando `ps`. Por ejemplo, para buscar todos los procesos relacionados con "firefox", usa:

```bash
ps aux | grep firefox
```

### 4. ❌ Matar un proceso

Si necesitas terminar un proceso que está funcionando de manera incorrecta o que ya no necesitas, puedes usar el comando `kill`. Para matar un proceso, primero debes conocer su PID (ID del proceso), que puedes obtener con:

```bash
ps aux | grep nombre_del_proceso
```

Luego, usa el siguiente comando para matar el proceso:

```bash
kill PID
```

Si el proceso no se detiene, puedes forzar el cierre usando:

```bash
kill -9 PID
```

> 📌 **Nota:** Ten cuidado al matar procesos, ya que podrías terminar procesos del sistema que afecten la estabilidad.

### 5. ⚙️ Priorizar procesos (cambiar la prioridad de un proceso)

Puedes cambiar la prioridad de un proceso en ejecución con el comando `renice`. Por ejemplo, si deseas cambiar la prioridad de un proceso con PID `1234` a `10`, usa:

```bash
sudo renice 10 -p 1234
```

> 📌 **Nota:** Los valores de prioridad van de -20 (máxima prioridad) a 19 (baja prioridad). Los usuarios con privilegios de root pueden asignar prioridades más altas a los procesos.

### 6. 📊 Ver el uso de recursos por proceso

Para ver un resumen del uso de recursos del sistema, incluyendo la CPU y la memoria, puedes usar el comando `htop` (si está instalado). `htop` proporciona una interfaz más amigable que `top` y te permite interactuar con los procesos (matar, reniciar, etc.).

```bash
htop
```

> 📌 **Nota:** Si no tienes `htop` instalado, puedes instalarlo con:

```bash
sudo apt install htop  # Para distribuciones basadas en Debian/Ubuntu
```

### 7. 🔌 Matar un proceso por su número de puerto

Si deseas matar un proceso que está utilizando un puerto específico, puedes seguir estos pasos:

#### 1. Encontrar el proceso que usa el puerto

Primero, usa el comando `netstat` para encontrar el PID del proceso que está usando un puerto específico. Por ejemplo, si quieres buscar el proceso que usa el puerto `8080`, puedes usar:

```bash
sudo netstat -tulpn | grep :8080
```

Este comando te mostrará una línea con información sobre el puerto y el PID del proceso que lo está utilizando. La salida será algo similar a:

```
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      1234/python
```

En este ejemplo, el PID del proceso es `1234`.

#### 2. Matar el proceso usando el PID

Una vez que hayas obtenido el PID del proceso, puedes usar el comando `kill` para detenerlo. Si el PID de tu proceso es, por ejemplo, `1234`, puedes usar:

```bash
sudo kill 1234
```

Si el proceso no se detiene, puedes forzar el cierre utilizando la señal `-9`:

```bash
sudo kill -9 1234
```

#### 3. Verificar que el puerto esté libre

Después de matar el proceso, puedes verificar si el puerto ya está libre ejecutando nuevamente el comando `netstat`:

```bash
sudo netstat -tulpn | grep :8080
```

Si no hay salida, significa que el puerto ya está libre.

> 📌 **Nota:** Asegúrate de tener cuidado al matar procesos, especialmente si son procesos del sistema, ya que podrías afectar la estabilidad del sistema.


---

## 👤 Gestión de usuarios y permisos de archivos

En Linux, cada archivo y directorio tiene un propietario y un grupo asignado, así como permisos que determinan quién puede leerlo, escribirlo o ejecutarlo.

---

### 1. 📌 Ver propietario y permisos de un archivo

```bash
ls -l archivo.txt
```

Salida de ejemplo:

```
-rw-r--r-- 1 usuario grupo 1234 ago 13 16:00 archivo.txt
```

* `usuario` → propietario del archivo
* `grupo` → grupo al que pertenece el archivo
* `rw-` → permisos para el propietario
* `r--` → permisos para el grupo
* `r--` → permisos para otros usuarios

---

### 2. 🔄 Cambiar el propietario de un archivo o carpeta (`chown`)

#### Cambiar propietario:

```bash
sudo chown nuevo_usuario archivo.txt
```

#### Cambiar propietario y grupo al mismo tiempo:

```bash
sudo chown nuevo_usuario:nuevo_grupo archivo.txt
```

#### Cambiar de forma recursiva (carpetas y contenido):

```bash
sudo chown -R nuevo_usuario:nuevo_grupo /ruta/a/carpeta
```

---

### 3. 🛡 Cambiar permisos de un archivo o carpeta (`chmod`)

Los permisos se representan con letras o números:

* `r` → lectura (4)
* `w` → escritura (2)
* `x` → ejecución (1)

#### Usando letras:

```bash
chmod u+x script.sh     # Agregar permiso de ejecución al propietario
chmod g-w archivo.txt   # Quitar permiso de escritura al grupo
chmod o-r archivo.txt   # Quitar permiso de lectura a otros usuarios
```

#### Usando números:

```bash
chmod 755 script.sh
```

> 📌 Ejemplo: `755` significa:
>
> * Propietario: lectura + escritura + ejecución (7)
> * Grupo: lectura + ejecución (5)
> * Otros: lectura + ejecución (5)

---

### 4. 👥 Gestionar usuarios (`useradd`, `usermod`, `passwd`)

#### Crear un nuevo usuario:

```bash
sudo useradd -m nuevo_usuario
```

#### Asignar una contraseña al usuario:

```bash
sudo passwd nuevo_usuario
```

#### Agregar usuario a un grupo:

```bash
sudo usermod -aG grupo nuevo_usuario
```

#### Ver a qué grupos pertenece un usuario:

```bash
groups usuario
```

---

### 5. 🗑 Eliminar un usuario

```bash
sudo userdel usuario
```

Si quieres eliminar también su carpeta personal:

```bash
sudo userdel -r usuario
```

---

📌 **Consejo de seguridad:**

* Usa `chown` y `chmod` con cuidado para no dar permisos excesivos.
* No elimines usuarios del sistema sin confirmar que no son necesarios para servicios críticos.

---

## 💽 Ver y gestionar el almacenamiento en Linux

Linux ofrece varios comandos para comprobar el uso de disco, inodos y las particiones disponibles en el sistema.

---

### 1. 📊 Ver uso de disco con `df`

```bash
df -h
```

* `-h` → muestra los tamaños en formato legible (KB, MB, GB).
* Muestra cuánto espacio está usado, disponible y el porcentaje de uso de cada partición.

Ejemplo de salida:

```
Filesystem     Size  Used Avail Use% Mounted on
/dev/sda2      234G  136G   86G  62% /
/dev/sda1      511M   50M  462M  10% /boot
tmpfs           12G   12K   12G   1% /dev/shm
```

---

### 2. 📂 Ver el tamaño de un directorio con `du`

```bash
du -sh /ruta
```

* `-s` → solo muestra el total.
* `-h` → formato legible.

Ejemplo:

```bash
du -sh /home
```

👉 Te muestra cuánto espacio ocupa la carpeta `/home` en total.

---

### 3. 🔢 Ver inodos disponibles con `df -i`

Los inodos representan **el número máximo de archivos que puede almacenar una partición** (independientemente de su tamaño).

```bash
df -i
```

Esto es útil si no puedes crear más archivos a pesar de tener espacio en disco libre.

---

### 4. 📋 Ver discos y particiones con `lsblk`

```bash
lsblk
```

Este comando muestra un árbol con los discos conectados, sus particiones y puntos de montaje. Muy útil para identificar unidades antes de formatear o montar.

Ejemplo:

```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   238G  0 disk 
├─sda1   8:1    0   512M  0 part /boot
└─sda2   8:2    0 237.5G  0 part /
```

---

## 📂 Directorios y sistemas de archivos importantes

En los resultados de `df -h` o `lsblk`, verás puntos de montaje clave:

### 1. `/` (root o raíz)

* Es el directorio principal de Linux.
* Contiene todo el sistema operativo: `/etc`, `/home`, `/usr`, `/var`, etc.
* Si se llena, el sistema puede dejar de funcionar correctamente.

---

### 2. `/boot`

* Partición donde se almacenan los kernels de Linux y archivos necesarios para arrancar el sistema.
* Suele ser pequeña (200–600 MB).
* Si se llena, no podrás instalar nuevos kernels → el sistema podría fallar al actualizar.

---

### 3. `tmpfs` (memoria temporal)

* Es un sistema de archivos en memoria RAM.
* Se monta en lugares como `/dev/shm`, `/run`, `/tmp`.
* Aunque aparece con un tamaño grande (ejemplo: 12 GB), **solo ocupa lo que se use en ese momento**.
* Se vacía automáticamente al reiniciar el sistema.

---

### 4. `/root`

* Es la carpeta personal del usuario **root** (administrador).
* Diferente de `/` (la raíz del sistema).
* Normalmente solo la usa el superusuario para tareas de mantenimiento.

