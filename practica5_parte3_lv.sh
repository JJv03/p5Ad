#!/bin/bash
#845097, Valle Morenilla, Juan, T, 1, A
#839757, Ye, Ming Tao, T, 1, A

while IFS=',' read nombreGrupoVolumen nombreVolumenLogico tamanyo tipoSistemaFicheros directorioMontaje
do
    logVolDir=$(echo "/dev/$nombreGrupoVolumen/$nombreVolumenLogico")
    lvdisplay | grep ""$logVolDir"" &> /dev/null
    #La dirección existe, es no nula, es decir, ya existe
    if [ $? -eq 0 ]; then
        echo "El volumen lógico que ha introducido ya existe, procedemos a ampliarlo."
        #-L indica el tamaño que se quiere asignar al LV
        lvextend -L $tamanyo $logVolDir
        #Redimensionamos el sistema de archivos 
        resize2fs $logVolDir
    #La dirección aún no existe
    else
        echo "Se va a crear el volumen que ha introducido."
        #Creamos el nuevo volumen
        lvcreate -L $tamanyo -n $nombreVolumenLogico $nombreGrupoVolumen
        if [ $? -eq 0]; then
            #Comprobamos que existe el directorio de montaje indicado, sino lo creamos
            if [ ! -d $directorioMontaje ]; then
                #-p indica que cree cualquier directorio padre necesario para generar la ruta proporcionada
                mkdir -p $directorioMontaje
            fi
            echo -e "$logVolDir\t$directorioMontaje\t$tipoSistemaFicheros\tdefaults 0 0" >> /etc/fstab#Formateamos el LV
            mkfs -t $tipoSistemaFicheros $logVolDir
            #Montamos de nuevo el LV
            mount -t $tipoSistemaFicheros $logVolDir $directorioMontaje
        fi
    fi
done < $1
