#!/bin/bash
#845097, Valle Morenilla, Juan, T, 1, A
#839757, Ye, Ming Tao, T, 1, A

if [ $# -ne 1 ]; then
    echo "Número de parámetros insuficiente"
    echo "Sintaxis: ./practica5_parte2.sh <IP>"
    exit 1
fi

#sfdisk -s = discos duros disponibles y sus tamaños en bloques
#sfdisk -l = particiones y sus tamaños
#df -hT = información de montaje de sistemas de ficheros
#grep -v = filtra y muestro todos aquellos que no sigan el patrón
ssh -n as@$1
if [ $? -eq 0 ]; then
    ssh as@"$1" "sudo sfdisk -s && sudo sfdisk -l && sudo df -hT | grep -v 'tmpfs'" #Con grep filtramos para que no salgan tmpfs
else
    echo "No se puede acceder a la ip $1."
    exit 1
fi