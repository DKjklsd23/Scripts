####################################################################
# File Name: backup_tar.sh
# Author: Anqiao
# Mail: ayang@jaumebalmes.net
# Created Time: mar 10 ene 2017 15:51:05 CET
#===================================================================
#!/bin/bash

clear
menu(){
	echo "[1] Backup"	
	echo "[2] Restory"	
	echo "[3] Exit"	
	read -t 30 -p "Escollir una opció: " cho	
}
menu_backup(){
	echo "[1] Backup Total"	
	echo "[2] Backup Diferencia"	
	echo "[3] exit"	
	read -t 30 -p "Escollir una opció: " cho1
}
pregunta_dir(){
	echo  "Es pot fer Backup de diverssos directori separat amb espai"
	read -t 30 -p "Introduir el directori origen (on volem fer backup): " ruta_o
	read -t 30 -p "Introduir el directori destí (on guardar backup): " ruta_d
# Control de existencia de directori d'origens i el de desti.
	nums_dir_to_backup=`echo $ruta_o | wc -w`
	if [ $nums_dir_to_backup -gt 1 ];then
		name_directoris=""
		trobat="true"
		for i in `echo $ruta_o`
			do
			if [ ! -d $i ];then
				echo "No existeix el directori $i"
				trobat="false"
			else
				nom_directori="$nom_directori"`basename $i`_
			fi	
		done
		if [ $trobat == "false" ];then
			pregunta_dir
		fi
	fi

	if [ ! -d $ruta_d ];then
		echo "Directori destí no existeix"
		pregunta_dir
	fi
}

while true
do
	menu
# Menu principal
	case "$cho" in
		"1")
# Menu Backup
			menu_backup
			case "$cho1" in
				"1")
					pregunta_dir
# aquí temps amb format de hora_minuts-dia-mes-any
					cd $ruta_d && tar -zcf total_${nom_directori}`date +%H_%M-%d-%m-%y`.tar.gz $ruta_o &> /dev/null && cd -
					echo "Ha fet correctament Backup"
				;;
				"2")
# Pedent backup incremental					
				pregunta_dir
#	read -t 30 -p ""
				cd $ruta_d && tar -zcf diferencial_${nom_directori}`date +%H_%M-%d-%m-%y`.tar.gz $ruta_o -N  &> /dev/null && cd -
				echo "Ha fet correctament Backup"
				;;
				"3")
					echo "Has sortit correctament del menu actual!"
				;;
				*)
					echo "opció invàlida"
				;;
			esac
		;;
		"2")
			read -t 30 -p "Indicar el fitxer de Backup: " file_backup
			read -t 30 -p "Indicar on volem restaurar la copia " des_backup
			tar -zxf $file_backup -C $des_backup
			echo "Ha restaurat correctament!!!"
		;;
		"3")
			exit 0
		;;
		*)
			echo "opció invàlida"
		;;
	esac
done
