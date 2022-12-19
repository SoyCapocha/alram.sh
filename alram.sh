#!/bin/bash
#
# Programa que administra cuantas instancias de alarm.sh tienen
# que estar abiertas según un archivo de notificaciones en el
# home. La cantidad de instancias que se abren va a ser
# dependiendo la cantidad de renglones que tenga el archivo .notis
# Si una instancia está abierta, entonces no iniciar otra.
# 
# Usa: * arrays para guardar los datos de la info del archivo de notis.
#      * un archivo que guarda cual renglón del archivo .notis está abierto.
#
# Si en la línea n tiene un [] marcado, entonces existe una instancia abierta
# del programa, por ende, no tiene que lanzarlo de nuevo

# obtiene cuantas notificaciones hay que analizar para poner en cada array


# En el caso que se reinicie la computadora y se ejecute el script, el programa
# borra todas las notificaciones de ejecución en el próximo lanzamiento para
# luego evaluar si ejecutarlos o no dependiendo la fecha del día.

notify-send -i ~/alram/alram.png "alram.sh iniciado" "nada, eso"
		j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
		for (( i=1; i <= $j; i++ )); do
				noti[$i]=$(head -n $i ~/.notis | tail -1)
				active=$(echo "${noti[$i]}" | grep -o '..$')				# obtiene el valor si está activado o no el script
				if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then		# analiza si es un comentario del script
						if [ "$active" == "[]" ]; then						# si está activado el script, entonces no hacer nada
							sed -i "${i}c ${noti[$i]%???}" ~/.notis
							echo "activación borrada"
						fi
				fi
		done
		sleep 2

while [ true ]; do
		j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)

		for (( i=1; i <= $j; i++ )); do
				noti[$i]=$(head -n $i ~/.notis | tail -1)
				active=$(echo "${noti[$i]}" | grep -o '..$')				# obtiene el valor si está activado o no el script
				if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then		# analiza si es un comentario del script
						if [ "$active" == "[]" ]; then						# si está activado el script, entonces no hacer nada
								echo "está activado"
								sleep 1
						elif [ "$active" == "{}" ]; then
								echo "ha terminado"
								sed -i "$i d" ~/.notis
								sleep 1
						else
								echo "no está activado"
								activa=$(echo "${noti[$i]} []")
								sed -i "${i}c ${activa}" ~/.notis
								init="${noti[$i]} \"$i\""
								echo $init
								./alarm.sh $init &
								sleep 1
						fi
				fi
		done
		sleep 60
done
