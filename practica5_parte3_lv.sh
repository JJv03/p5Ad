#!/bin/bash
#845097, Valle Morenilla, Juan, T, 1, A
#839757, Ye, Ming Tao, T, 1, A

while IFS=',' read nombreGrupoVolumen nombreVolumenLogico tamanyo tipoSistemaFicheros directorioMontaje
do
    #-C indica que los datos generados por el comando lvdisplay salgan en forma de tabla (Columnas)
    #-o especifica que solo se muestren los datos de la columna "lv_path"
    logVolDir = $(lvdisplay "$nombreGrupoVolumen/$nombreVolumenLogico" -Co "lv_path" | 
    #Filtramos para que solo se vean los que hagan referencia a ese LV en concreto
    grep "$nombreGrupoVolumen/$nombreVolumenLogico" | 
    #Utilizamos el comando tr con -d para eliminar aquellos caracteres iguales a un espacio (" ")
    tr -d '[[:space:]]') &> /dev/null #Evitamos mostrar salidas o errores
    #La dirección existe, es no nula, es decir, ya existe
    if [ -n "&logVolDir" ]; then
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
            logVolDir = $(lvdisplay "$nombreGrupoVolumen/$nombreVolumenLogico" -Co "lv_path" | 
            grep "$nombreGrupoVolumen/$nombreVolumenLogico" | 
            tr -d '[[:space:]]')
            #Añadimos el LVal fichero /etc/fstab
            echo -e "$logVolDir\t$directorioMontaje\t$tipoSistemaFicheros\tdefaults 0 0" >> /etc/fstab
            #Formateamos el LV
            mkfs.$tipoSistemaFicheros $logVolDir
            #Montamos de nuevo el LV
            mount $logVolDir $directorioMontaje
        fi
    fi
    break #No lo tengo tan claro...
done