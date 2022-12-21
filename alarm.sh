#!/bin/bash

diapc=$(date +%-d)
mespc=$(date +%-m)
aniopc=$(date +%-y)
horapc=$(date +%-H)
minpc=$(date +%-M)
secpc=$(date +%-S)

disdia=$(( $1 - $diapc ))
dismes=$(( $2 - $mespc ))
disanio=$(( $3 - $aniopc ))
dishora=$(( $4 - $horapc ))
dismin=$(( $5 - $minpc ))
dissec=$(( $6 - $secpc ))


tit=$(echo $@ | cut -d '"' -f2)
desc=$(echo $@ | cut -d '"' -f4)
img=$(echo $@ | cut -d '"' -f6)
snd=$(echo $@ | cut -d '"' -f8)

if [ $disanio -gt 0 ]; then
		for (( l=0 ; l < $disanio ; l++ )); do
				dismes=$(( 12 - $mespc + $2 ))
		done
fi

if [ $dismes -gt 1 ]; then
		for (( i=0 ; i <= $dismes ; i++ )); do
				m1t=$(date -d "`date +%Y%m01` +$(( 1 + $i )) month -1 day" +%d) # obtiene todos los días del mes
				dm1=$(( $dm1 + $m1t ))
		done
		dt=$(( $1 + $dm1))
elif [ $dismes -gt 0 ]; then
		m1t=$(date -d "`date +%Y%m01` +1 month -1 day" +%d) # obtiene todos los días del mes
		dm1=$(( $m1t - $diapc )) #total de días restantes del mes
		dt=$(( $1 + $dm1))
else
		dt=$(($disdia)) #total de días restantes del mes
fi

if [ $dt -eq 0 ];then
		if [ $dishora -ge 0 ]; then
				while [ $dishora -gt 0 ];do
						horapc=$(date +%-H)
						dishora=$(( $4 - $horapc))
						sleep 1800
				done
		else
				echo "Hora pasada"
				j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
				for (( i=1; i <= $j; i++ )); do
						noti[$i]=$(head -n $i ~/.notis | tail -1)
						active=$(echo "${noti[$i]}" | cut -c 1-17)							# obtiene los valores de las notificaciones de ~/.notis
						if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then				# analiza si es un comentario del script
								if [ "$active" == "$(echo $1 $2 $3 $4 $5 $6)" ]; then		# si es la misma línea, entonces borra la activación
										sed -i "${i}c ${noti[$i]%???} {}" ~/.notis
									echo "notificación terminada"
								fi
						fi
				done
				exit
		fi

		if [ $dismin -ge 0 ]; then
				while [ $dismin -ge 2 ]; do

						while [ $dismin -gt 20 ];do
								minpc=$(date +%-M)
								dismin=$(( $5 - $minpc))
								sleep 480
						done
		
						while [ $dismin -gt 5 ];do
								minpc=$(date +%-M)
								dismin=$(( $5 - $minpc))
								sleep 60
						done
								sleep 20
								minpc=$(date +%-M)
								dismin=$(( $5 - $minpc))
				done

				while [ $dissec -ne 0 ];do
						secpc=$(date +%-S)
						minpc=$(date +%-M)
						dismin=$(( $5 - $minpc ))
						dissec=$(( $6 - $secpc + 60*$dismin))
						echo $dissec
						sleep 1
				done
		else
				echo "Minuto/segundo pasado"
				j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
				for (( i=1; i <= $j; i++ )); do
						noti[$i]=$(head -n $i ~/.notis | tail -1)
						active=$(echo "${noti[$i]}" | cut -c 1-17)							# obtiene los valores de las notificaciones de ~/.notis
						if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then				# analiza si es un comentario del script
								if [ "$active" == "$(echo $1 $2 $3 $4 $5 $6)" ]; then		# si es la misma línea, entonces borra la activación
										sed -i "${i}c ${noti[$i]%???} {}" ~/.notis
									echo "notificación terminada"
								fi
						fi
				done
				exit
		fi

		# llama a terminar la notificación
				j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
				for (( i=1; i <= $j; i++ )); do
						noti[$i]=$(head -n $i ~/.notis | tail -1)
						active=$(echo "${noti[$i]}" | cut -c 1-17)							# obtiene los valores de las notificaciones de ~/.notis
						if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then				# analiza si es un comentario del script
								if [ "$active" == "$(echo $1 $2 $3 $4 $5 $6)" ]; then		# si es la misma línea, entonces borra la activación
										sed -i "${i}c ${noti[$i]%???} {}" ~/.notis
									echo "notificación terminada"
								fi
						fi
				done

		# envía la notificación
		if [ "$img" == "" ]; then
				notify-send -i "./alram.png" "$tit" "$desc"
		else
				notify-send -i "$img" "$tit" "$desc"
		fi
		if [ "$snd" != "" ];then
				play "$snd"
		fi
elif [ $dt -eq -1 ];then
		echo "fecha pasada"
		j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
		for (( i=1; i <= $j; i++ )); do
				noti[$i]=$(head -n $i ~/.notis | tail -1)
				active=$(echo "${noti[$i]}" | cut -c 1-17)							# obtiene los valores de las notificaciones de ~/.notis
				if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then				# analiza si es un comentario del script
						if [ "$active" == "$(echo $1 $2 $3 $4 $5 $6)" ]; then		# si es la misma línea, entonces borra la activación
							echo "notificación terminada"
								sed -i "${i}c ${noti[$i]%???} {}" ~/.notis
						fi
				fi
		done
elif [ $dt -lt -1 ];then
		echo "fecha pasadasa"
		j=$(echo $(wc -l ~/.notis) > /tmp/wcnoti; awk '{print $1}' /tmp/wcnoti)
		for (( i=1; i <= $j; i++ )); do
				noti[$i]=$(head -n $i ~/.notis | tail -1)
				active=$(echo "${noti[$i]}" | cut -c 1-17)							# obtiene los valores de las notificaciones de ~/.notis
				if [ $(awk "NR==$i {print \$1}" ~/.notis) != "#" ];then				# analiza si es un comentario del script
						if [ "$active" == "$(echo $1 $2 $3 $4 $5 $6)" ]; then		# si es la misma línea que la noti activada, entonces borra la línea
								sed -i "${i} d" ~/.notis
							echo "línea borrada"
						fi
				fi
		done
fi

echo $dt
