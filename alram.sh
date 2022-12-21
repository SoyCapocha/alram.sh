#!/bin/bash

if [ "$1" == "h" ]; then
		echo "==Alram.sh by SoyCapocha=="
		echo ""
		echo "- arguments:"
		echo "   e: edit ~/.notis"
		echo "   h: get help"
		echo ""
		echo "- format for notifications on ~/.notis:"
		echo "   DD MM YY hh mm ss \"title\" \"desc\" \"img\" \"snd\""
		exit
fi

if [ "$1" == "e" ]; then
		if [ ! -f ~/.notis ]; then
				echo "# Comments" > ~/.notis
				echo "# format:" >> ~/.notis
				echo "# DD MM YY hh mm ss \"title\" \"desc\" \"img\" \"snd\"" >> ~/.notis
				$EDITOR ~/.notis
				exit
		else
				$EDITOR ~/.notis
				exit
		fi
fi

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
								init="${noti[$i]%???}"
								echo $init
								./alarm.sh $init &
								sleep 1
						else
								echo "no está activado"
								activa=$(echo "${noti[$i]} []")
								sed -i "${i}c ${activa}" ~/.notis
								init="${noti[$i]}"
								echo $init
								./alarm.sh $init &
								sleep 1
						fi
				fi
		done
		sleep 60
done
