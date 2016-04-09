#!/bin/bash
#
#-----------------------------------------------------------------------
# Este script respalda las carpetas especificadas al conectar disco usb
# este es llamado por lo parametros en udev
#-----------------------------------------------------------------------

# log de inicio del backup
/usr/bin/logger Inicio respaldo : `date`
echo "Iniciado respaldo" |  /usr/bin/mail -s "Inicio respaldo: $(date)" correo@usuarios.com
# si se necesita crea el mountpoint
if [ ! -d /mnt/backup ] ; then mkdir /mnt/backup ; fi

# si el disco esta en algun formato nativo de Linux usa este comando
/bin/mount -t auto /dev/$1 /mnt/backup
# si usas fat32, exfat u ntfs este otro
#/bin/mount -t vfat -o shortname=mixed,iocharset=utf8 /dev/$1 /mnt/backup

# respaldamos
/usr/bin/logger Respaldando - archivos importantes 1
/usr/bin/rsync -rtv --del --modify-window=2 /path/to/archivos_importantes_1 /mnt/backup
# --modify-window=2 indica a RSync considerar 2s para el timestap de los archivos, necesario solo en FAT32

# Agrega cuanto rsync necesites
#/usr/bin/logger Respaldando - archivos importantes 2
#/usr/bin/rsync -rtv --del --modify-window=2 /path/to/archivos_importantes_2 /mnt/backup

# focezar sync de archivos antes de desmontar
/bin/sync

# desmontar disco
/bin/umount /mnt/backup

# log de fin de backup
echo "Finlizado respaldo" |  /usr/bin/mail -s "Finalizado respaldo: $(date)" correo@usuarios.com
/usr/bin/logger Finalizado respaldo: `date`