#!/bin/bash -f

# Author           : Jakub Wyka
# Created On       : 23.05.17
# Last Modified By : Jakub Wyka
# Last Modified On : 24.05.17
# Version          : 1.0
#
# Description      :
# Simple script to add some information to your wallpaper.
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details1
# or contact # the Free Software Foundation for a copy)

function check_CZCIONKA
{
	REGEX='^[0-9][0-9]$'
	if [[ $CZCIONKA =~ $REGEX ]] ; then
		GOODA="1"
	else
		GOODA="0"
		CZCIONKA="zle dane"
		zenity --info \
		--text="Zle dane. Mozliwa czcionka 0-99."
	fi
}

function check_WSPOLRZEDNE
{
	REGEX='^[0-9]+,[0-9]+$'
	if [[ $WSPOLRZEDNE =~ $REGEX ]] ; then
		GOOD="1"
	else
		GOOD="0"
		WSPOLRZEDNE="zle dane"
		zenity --info \
		--text="Format: x,y"
	fi
}

ZMIENNA=0
ZM=0
FIND="find"
P=/home/kuba/Pobrane
while getopts dcvh OPT 2>/dev/null
do
 case $OPT in
	h)
		zenity --info \
		--text="Options: default ( -d ) , custom ( -c ), info (-v)"
		exit;;
	v)
		zenity --info \
		--text="Version 1.0. Author: Jakub Wyka"
		exit;;
	d) #default - wp.conf
		sleep 20s
		source /home/kuba/Pobrane/wp.config	
		`wget http://www.kalendarzswiat.pl/cytat_dnia`
		 CYTAT=`grep -A 3 "quote-of-the-day" cytat_dnia| cut -d ";" -f2| cut -d "&" -f1| sed -n 2p | tr -s " "`
		`rm cytat_dnia`
		`convert -font Liberation-Sans-Bold -pointsize $CZCIONKA -fill $KOLOR -draw "text $WSPOLRZEDNE '$CYTAT'" "$P/tapety/$SCIEZKA" "$P/tapety/$SCIEZKA-a"`
		`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$P/tapety/$SCIEZKA-a"`
   		exit;;
	c) #custom 
		while [ $ZMIENNA -ne 5 ]; do
			ZMIENNA=0 
			ZM=0
			menu=("1.Cytat" "2.Imieniny " "3.Oba " "4.Quit")
			odp=`zenity --list --column=Menu "${menu[@]}" --height 400 2>/dev/null`
			case $odp in
				1*)
				`wget http://www.kalendarzswiat.pl/cytat_dnia`
		 		CYTAT=`grep -A 3 "quote-of-the-day" cytat_dnia| cut -d ";" -f2| cut -d "&" -f1| sed -n 2p | tr -s " "`
				`rm cytat_dnia`
				while [ $ZM -ne 4 ]; do 
					men=("1.Czcionka rozmiar: $CZCIONKA" "2.Kolor: $KOLOR" "3.Wspolrzedne: $WSPOLRZEDNE" "4.Nazwa obrazu: $SCIEZKA" "5.Wykonaj" "6.Quit")
					zm=`zenity --list --column=Menu "${men[@]}" --height 400`
					case $zm in
					1*)CZCIONKA=$(zenity --entry --title "Podaj nazwe czcionki." --text "Czcionka:")
					check_CZCIONKA;;
					2*)
					KOLOR=$(zenity  --list  --text "Wybierz kolor" --radiolist  --column "Wybor" --column "KOLOR" TRUE red FALSE yellow FALSE blue FALSE pink);;
					3*)WSPOLRZEDNE=$(zenity --entry --title "Podaj wspolrzedne." --text "Wspolrzedne x,y :")
					check_WSPOLRZEDNE;;
					4*)SCIEZKA=$(zenity --file-selection --title="Select a File");;		
					5*)
					if [[ "$GOOD" -ne "0" && "$GOODA" -ne "0" ]] ; then			
					`convert -font Liberation-Sans-Bold -pointsize $CZCIONKA -fill $KOLOR -draw "text $WSPOLRZEDNE '$CYTAT'" "$SCIEZKA" "$SCIEZKA-a"`
					`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$SCIEZKA-a"`
					else
						zenity --info \
						--text="Nie wszystkie dane są prawidłowe"
					fi;;
					5*)ZM=4;;
					*)ZM=4;;
					esac
				done;;			
				2*)
				`wget http://www.kalendarzswiat.pl/cytat_dnia`
		 		CYTAT=`grep -A 3 " <li>Imieniny: <em>" cytat_dnia| cut -d ">" -f3| cut -d "<" -f1| sed -n 1p | tr -s " "`
				CYTAT="Imieniny: $CYTAT"
				`rm cytat_dnia`
				while [ $ZM -ne 4 ]; do 
					men=("1.Czcionka rozmiar: $CZCIONKA" "2.Kolor: $KOLOR" "3.Wspolrzedne: $WSPOLRZEDNE" "4.Nazwa obrazu: $SCIEZKA" "5.Wykonaj" "6.Quit")
					zm=`zenity --list --column=Menu "${men[@]}" --height 400`
					case $zm in
					1*)CZCIONKA=$(zenity --entry --title "Podaj nazwe czcionki." --text "Czcionka:")
					check_CZCIONKA;;
					2*)KOLOR=$(zenity  --list  --text "Wybierz kolor" --radiolist  --column "Wybor" --column "KOLOR" TRUE red FALSE yellow FALSE blue FALSE pink);;
					3*)WSPOLRZEDNE=$(zenity --entry --title "Podaj wspolrzedne." --text "Wspolrzedne x,y :")
					check_WSPOLRZEDNE;;
					4*)SCIEZKA=$(zenity --file-selection --title="Select a File");;		
					5*)
					if [[ "$GOOD" -ne "0" && "$GOODA" -ne "0" ]] ; then					
					`convert -font Liberation-Sans-Bold -pointsize $CZCIONKA -fill $KOLOR -draw "text $WSPOLRZEDNE '$CYTAT'" "$SCIEZKA" "$SCIEZKA-a"`
					`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$SCIEZKA-a"`
					else
						zenity --info \
						--text="Nie wszystkie dane są prawidłowe"
					fi;;
					5*)ZM=4;;
					*)ZM=4;;
					esac
				done;;			
				3*)
				`wget http://www.kalendarzswiat.pl/cytat_dnia`
		 		CYTATA=`grep -A 3 " <li>Imieniny: <em>" cytat_dnia| cut -d ">" -f3| cut -d "<" -f1| sed -n 1p | tr -s " "`
				CYTATA="Imieniny: $CYTATA"
				CYTATB=`grep -A 3 "quote-of-the-day" cytat_dnia| cut -d ";" -f2| cut -d "&" -f1| sed -n 2p | tr -s " "`
				`rm cytat_dnia`
				while [ $ZM -ne 4 ]; do 
					men=("1.Czcionka rozmiar: $CZCIONKA" "2.Kolor: $KOLOR" "3.Wspolrzedne cytat: $WSPOLRZEDNEA" "4.Wspolrzedne imienin: $WSPOLRZEDNEB" "5.Nazwa obrazu: $SCIEZKA" "6.Wykonaj" "7.Quit")
					zm=`zenity --list --column=Menu "${men[@]}" --height 400 --width 300`
					case $zm in
					1*)CZCIONKA=$(zenity --entry --title "Podaj nazwe czcionki." --text "Czcionka:")
					check_CZCIONKA;;
					2*)KOLOR=$(zenity  --list  --text "Wybierz kolor" --radiolist  --column "Wybor" --column "KOLOR" TRUE red FALSE yellow FALSE blue FALSE pink);;
					3*)WSPOLRZEDNEA=$(zenity --entry --title "Podaj wspolrzedne." --text "Wspolrzedne x,y :")
					REGEX='^[0-9]+,[0-9]+$'
					if [[ $WSPOLRZEDNEA =~ $REGEX ]] ; then
						GOOD="1"
					else
						GOOD="0"
						WSPOLRZEDNEA="zle dane"
						zenity --info \
						--text="Format: x,y"
					fi;;
					4*)WSPOLRZEDNEB=$(zenity --entry --title "Podaj wspolrzedne." --text "Wspolrzedne x,y :")
					REGEX='^[0-9]+,[0-9]+$'
					if [[ $WSPOLRZEDNEB =~ $REGEX ]] ; then
						GOOD2="1"
					else
						GOOD2="0"
						WSPOLRZEDNEB="zle dane"
						zenity --info \
						--text="Format: x,y"
					fi;;
					5*)SCIEZKA=$(zenity --file-selection --title="Select a File");;	
					6*)
					if [[ "$GOOD" -ne "0" && "$GOODA" -ne "0" && "$GOOD2" -ne "0" ]] ; then
					`convert -font Liberation-Sans-Bold -pointsize $CZCIONKA -fill $KOLOR -draw "text $WSPOLRZEDNEB '$CYTATA'" "$SCIEZKA" "$SCIEZKA-a"`
					`convert -font Liberation-Sans-Bold -pointsize $CZCIONKA -fill $KOLOR -draw "text $WSPOLRZEDNEA '$CYTATB'" "$SCIEZKA-a" "$SCIEZKA-a"`					
					`xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$SCIEZKA-a"`
					else
						zenity --info \
						--text="Nie wszystkie dane są prawidłowe"
					fi;;
					7*)ZM=4;;
					*)ZM=4;;
					esac
				done;;			
				4*)ZMIENNA=5 ;;
				*)ZMIENNA=5;;
	
			esac
		done
		exit;;
	?) 
	zenity --info \
	--text="Wrong option detected. Options: default ( -d ) , custom ( -c )"
	exit;;
 esac
done
zenity --info \
--text="No option detected. Options: default ( -d ) , custom ( -c ), info (-v), help (-h)"
exit


