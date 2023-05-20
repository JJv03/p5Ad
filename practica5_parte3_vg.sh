#!/bin/bash
#845097, Valle Morenilla, Juan, T, 1, A
#839757, Ye, Ming Tao, T, 1, A

if [ $# -lt 2 ]; then
    echo -e "Número de parámetros insuficiente\nDebe incluir el VG y uno o mas nombres de particiones que quiera añadir."
    exit 1
fi

if [ $EUID -ne 0 ]; then
    echo "No tenemos privilegios de administrador"
    exit 1
fi

grupo = $1  #Guardamos el primer parámetro
shift       #Quitamos el parámetro inicial que define el grupo para que solo quede una lista del resto de parámetros

vgextend $grupo $@  #Utilizamos vgextend pansándole un grupo y las particiones a añadir (no es necesario un bucle)