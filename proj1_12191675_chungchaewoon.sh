#! /bin/bash
echo "-------------------------------------"
echo "User Name:CHUNG CHAE WOON"
echo "Student Number: 12191675"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific
'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IDMb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "-------------------------------------"

while :
do
	read -p "Enter your choice [ 1-9 ] " reply
	case $reply in
		1) read -p "Please enter 'movie id'(1~1682): " movieid
			echo $(awk -v num=$movieid -F\| '$1==num {print $0}' ./u.item) ;; 
		2) read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" agree
			if [ $agree = "y" ];
			then
				temp=$(awk -v num=1 -F\| '$7==num {printf("%s %s\n",$1,$2)}' ./u.item |head);
				echo ""
    				echo -e "$temp\n"
			fi 
			;;
		3) read -p "Please enter the 'movie id' (1~1682): " movieid
			echo $(awk -v num=$movieid -F'\t' '$2==num {
			rate += $3 
			n++}
			END {if (n > 0){
			average = rate / n
			printf("average rating of %s: %.5f\n",num,average)}
		else{}}'  ./u.data);;
		4) read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" agree
			if [ $agree = "y" ];
			then
				echo -e "$(awk -F\| '{print $0}' ./u.item|sed 's/http[^)]*)//'|head)\n"
				echo " "
			fi;;
		5) read -p "Do you want to get the data about users from 'u.user'?(y/n):" agree
			if [ $agree = "y" ];
			then
				echo -e  "$(awk -F\| '{printf("user %s is %s years old %s %s\n",$1,$2,$3,$4)}' ./u.user| sed -E 's/M/male/'| sed -E 's/F/female/' |head)\n"
			fi;;
		6) read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" agree
			if [ $agree = "y" ];
			then
				echo -e "$(awk -F\| '{print $0}' ./u.item |sed 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/;'|sed 's/\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9][0-9][0-9]\)/\3\2\1/'|tail)\n"
			fi;;
		7) read -p "Please enter the 'user id'(1~943):" userid
			temp=$(awk -v num=$userid -F'\t' '$1==num{printf(" %s |\n",$2)}' ./u.data|sort -n);
			echo $temp
			echo ""
			temp=$(awk -v num=$userid -F'\t' '$1==num{printf(" %s \n",$2)}' ./u.data|sort -n|head);
			for var in $temp
			do
				echo $(awk -v movie=$var -F\| '$1==movie{printf("%s |%s \n",$1,$2)}' ./u.item);
			done
			;;
		8) read -p "Do you want to get the average 'rating of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" agree
			if [ $agree = "y" ];
			then 
				temp=$(awk -v rpro="programmer" -F\| '$2>=20 && $2<=29 && $4==rpro {print $1}' ./u.user);
				> ./tempo
				for var in $temp
				do 
					awk -v userid=$var -F'\t' '$1==userid{print $0}' ./u.data >> ./tempo
				done

				for var in $(seq 1 1682)
				do
					echo $(awk -v num=$var -F'\t' '{if ($2 !=num) {next;}
					rate += $3 
					n++}
					END {if (n > 0){
					average = rate / n
					printf("%s %.5f",num,average)}
					}' ./tempo)
				done
			fi
			;;
		9) echo "Bye!";
			exit 0;;
	esac
done

