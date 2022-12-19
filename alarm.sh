# Programa que cuantifica distancias y en el caso que la distancia sea
# menor que 1 día, empezar a contar hasta que sea exactamente la
# hora programada para enviar la notificación.
#
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

# echo $1 $2 $3 $4 $5 $6

tit=$(echo $@ | cut -d '"' -f2)
desc=$(echo $@ | cut -d '"' -f4)
img=$(echo $@ | cut -d '"' -f6)
snd=$(echo $@ | cut -d '"' -f8)
# period=$(echo $@ | cut -d '"' -f10)
#line=$(echo $@ | cut -d '"' -f12)
line=$(echo $@ | cut -d '"' -f10)

# echo $tit $desc $img $snd $line

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

if [ $dt == 0 ];then
		while [ $dishora -gt 0 ];do
				horapc=$(date +%-H)
				dishora=$(( $4 - $horapc))
				sleep 1800
		done

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
				dissec=$(( $secpc + 60*$dismin - $6))
				sleep 1
		done

		# eliminar la línea de la notificación del PC
		# agregar un if else para evaluar si es una actividad periódica o no.
		# Si es periódica, entonces no eliminarla.
		# if [ "$period" != "y" ]; then	# si no está el marcador de periodicidad, entonces borrar la línea.
				# salida=$(echo "$1 $2 $3 $4 $5 $6 $tit $desc $img $snd $period ][")
				# sed -i "${line} c {}" ~/.notis
		# else
				# salida=$(echo "$1 $2 $3 $4 $5 $6 \"$tit\" \"$desc\" \"$img\" \"$snd\" \"$period\"")
				# sed -i "${line} c ${salida}" ~/.notis
		# fi

		sed -i "${line} c {}" ~/.notis # elimina la info de la notificación así alram.sh borra la línea de ~/.notis.

		# envía la notificación
		if [ "$img" == "" ]; then
				notify-send -i "./alram.png" "$tit" "$desc"
		else
				notify-send -i "$img" "$tit" "$desc"
		fi
		if [ "$snd" != "" ];then
				play "$snd"
		fi
fi

echo $dt
