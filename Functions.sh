#! /bin/bash

function colors
{
	bg="\e[48;2;$1;$2;$3m$4\e[0m"
	fg="\e[38;2;$1;$2;$3m$4\e[0m"
}

function comb_colors
{
	text="\e[48;2;$1;$2;$3m\e[38;2;$4;$5;$6m$7\e[0m"
}
function flag
{
	comb_colors 255 153 51 255 153 51 "indiaflag"
	echo -e "$text"
	comb_colors 255 255 255 255 255 255 "indi"
	echo -e -n "$text"
	comb_colors 255 255 255 0 0 136 "*"
	echo -e -n "$text"
	comb_colors 255 255 255 255 255 255 "flag"
	echo -e "$text"
	comb_colors 18 136 7 18 136 7 "indiaflag"
	echo -e "$text"
}	
function rand_date
{
	#local _i=0
	#local _a=0
	#while [ $_i -lt 6 ]
	#do 
	#	_a[$_i]=`expr $RANDOM % 255`
	#	_i=`expr $_i + 1` 
	#done 
	#comb_colors ${_a[0]} ${_a[1]} ${_a[2]} ${_a[3]} ${_a[4]} ${_a[5]} "$(date +%T)"
	#echo -e -n $text
	rand_color_text -n "$(date +%T)"
}

function rand_color_text
{
	local _i=0
	local _a=0
	local input
	while [ $_i -lt 3 ]
	do
		_a[$_i]=`expr $RANDOM % 255`
		_i=`expr $_i + 1`
	done
	if [ "$1" = "-n" ]
	then
		input=$2
		opts="-n"
	else
		input=$1
		opts=
	fi
	comb_colors ${_a[0]} ${_a[1]} ${_a[2]} `expr ${_a[0]} / 2` `expr ${_a[1]} / 2` `expr ${_a[2]} / 2` "$input"
	
	echo -e $opts "$text"
}

function printfree
{
	GREEN="0 255 0 255 0 0"
	RED="255 0 0 255 255 255"
	YELLOW="255 255 0 255 0 0"
	free -m | xargs | cut -d " " -f 8,13 > ~/.dum
	read -a ram < ~/.dum
	local free=$(echo "scale=4;${ram[1]}/${ram[0]}*100" | bc)
	free=$(printf "%.2f" $free)
	if [ $(echo "$free>50"|bc -l) -eq 1 ]
	then
		color=$GREEN
	elif [ $(echo "$free>20 && $free<=50"|bc -l) -eq 1 ]
	then
		color=$YELLOW
	else
		color=$RED
	fi
	comb_colors $color "Free:$free%" 
	echo -e -n "$text"
}

function vdownload
{
	exit=0
	case $1 in 
		48k)
			FORMAT=139
			;;
		128k)
			FORMAT=140
			;;

		144p)
			FORMAT=17
			;;
		180p)
			FORMAT=36
			;;
		360p) 
			FORMAT=18
			;;
		720p)
			FORMAT=22
			;;
		v1080p)
			FORMAT=137
			;;
		v720p)
			FORMAT=136
			;;
		v480p)
			FORMAT=135
			;;
		v360p)
			FORMAT=134
			;;
		v240p)
			FORMAT=133
			;;
		v144p)
			FORMAT=160
			;;
		*)
			colors 255 0 0 "Format must be anything within 48k|128k|144p|180p|360p|v144p|v240p|v360p|v720p|v1080p"
			echo -e $fg
			exit=1
	esac
	if [ $exit -ne 1 ]
	then
		filename=$(youtube-dl --get-filename -f $FORMAT -o '%(title)s.%(ext)s' $2)
		colors 0 255 0 "Downloading $filename"
		echo -e "$fg"
		youtube-dl -f $FORMAT -o '%(title)s.%(ext)s' $2
	fi
}

function adownload
{
	exit=0
	AUDIO="0"
	AD="Best Audio"
	if [ $# -gt 1 ]
	then
		if [ $2 = "S" ]
		then
			AUDIO="128k"
			AD="128k"
		elif [ $2 = "B" ]
		then
			AUDIO=0
			AD="Best Audio"
		else
			colors 255 0 0 "Audio quality not yet supported"
			echo -e $fg
			exit=1
		fi
	elif [ $# -gt 2 ]
	then
		exit=1
	elif [ $1 = "-h" ]
	then
		exit=1
	fi
	if [ $exit -ne 1 ]
	then
		colors 0 255 255 "Using Audio quality $AD"
		echo -e $fg
		youtube-dl -f bestaudio -x --audio-format mp3 --audio-quality $AUDIO  -o '%(title)s.%(ext)s' $1
	else
		colors 255 255 0 "Usage : adownload link <<audio-quality>> \n link : Should not include Playlist links .. Only video links \n audio-quality : \n\t S- Standard \n\t B- Best Quality \n\t Default : Best Quality"
		echo -e $fg

	fi
}
