#!/bin/bash
#If the program is in command-line mode and there is an invalid argument, the program should print an error message and display the help message.

if [ ! -d "./todo" ]; then
	mkdir -p "todo"
	chmod 700 todo
fi

if [ ! -d "./completed" ]; then
	mkdir -p "completed"
	chmod 700 completed
fi


number='^[0-9]+$'

function listall (){
filename=./todo/$@
 if [ ! -f $filename ]; then
 echo "invalid item"
 else
 cat $filename
 fi
}

function list(){
	count=0;
for file in ./todo/*.txt; do
	if [ -f $file ]; then
 title=$(head -n 1 $file)
 let count=count+1
 echo  "$count"
 echo "$title"
 echo ""
else
	echo "nothing on your to do list!"
	fi
done
}

function listCompletedItems (){

		echo "Completed items:"
		
			for i in ./completed/*.txt; do

			
			
			cat $i
		
		echo ""	
			done
		echo "end completed items"
		echo " "
}
function addAnItem (){
		echo -n "please enter title for the item you want to add: "	
		todoNum=$(cd ./todo/ && ls|wc -l)
		let todoNum=todoNum+1

		let count=count+1
		read newItem
		touch ./todo/${todoNum}.txt 
		echo ${newItem} >> ./todo/${todoNum}.txt
		chmod 700 ./todo/${todoNum}.txt
		echo -n "please enter description: "
		read description
		
		echo "__________________" >> ./todo/${todoNum}.txt
		echo $description >> ./todo/${todoNum}.txt
}

function completeAnItem() {
	echo  "which item would you like to mark complete? "
	
	read completed
	count="1"
	for i in ./todo/*.txt; do
	[ -f "$i" ]|| break
	

	
	if [ "$completed" -eq "$count" ]
	then
	mv $i ./completed/
	break
else 
	echo "no such file!"

		let count=count+1


	fi	
	done
}	


valid="0"
counter="0"

while [ "$#" -gt "0" ]
do
  


if [[ "$1" == "list" && -z "$2" ]]; then
howmany=$(cd ./todo/ && ls|wc -l)
	if [ "$howmany" -gt "0" ]; then
		 list
		exit 
		else
			echo "nothing to do!"
	
		exit
	fi
elif [ "$1" == "help" ]; then
		
	echo "--HELP: list, complete [item], list completed, add [item]"
		exit
	
elif [[ "$1" == "list" && "$2" == "completed" || "$1" == "list completed" ]]; then
	if [ -z "$(ls -A ./completed)" ]; then
	echo "no items are completed yet"
exit	
else
		listCompletedItems
			exit
	fi
elif [[ "$1" == "add" &&  "$2" ]]; then

		todoNum=$(cd ./todo/ && ls|wc -l)
		let todoNum=todoNum+1
		
		let count=count+1
		#	echo "$filenumber"
		touch ./todo/${todoNum}.txt 
		echo $2 >> ./todo/${todoNum}.txt
		echo "_______________________" >> ./todo/${todoNum}.txt
	if  [ -p /dev/stdin ]; then
			read pipe
		#	echo "$pipe"
	#	echo $2 >> ./todo/${todoNum}.txt
		echo  $pipe >> ./todo/${todoNum}.txt
	fi
chmod 700 ./todo/${todoNum}.txt
exit



	

	#	echo $pipe >>./todo/${todoNum}.txt 
#		chmod 700 ./todo/${todoNum}.txt
			
	



elif [[ "$1" == "complete" && "$2" ]]; then


 
		if [ -f   ./todo/${2}.txt ]; then
			echo "true"
			mv ./todo/${2}.txt ./completed/
			exit
		else
	echo "no such task"
	exit
		fi



else 
	echo "invalid input"	
	echo "--HELP: list, complete [item], list completed, add [item]"
			exit	
fi
		done


echo  "Welcome to to-do list manager! "

#home
while [ $counter -lt 1 ]; do



#(cd ./todo/ && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)//sequential file naming 
#(cd ./completed/ && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

echo " to do: "
echo ""
count="1"
list

echo "A) Mark an item as completed"
echo "B) Add a new item"
echo "C) See completed items"
echo""
echo "Q) Quit"


	echo -n "Enter Choice: "
	read choice


if [ $choice ==  "A" ]; then
	if [ -z "$(ls -A ./todo)" ]; then
  echo "no items to do"
else	
completeAnItem
	fi

elif [ $choice ==  "B" ]; then
addAnItem

elif [ $choice ==  "C" ]; then

	if [ -z "$(ls -A ./completed)" ]; then
  echo "no completed items"
else
listCompletedItems
	fi
elif [[ $choice =~ $number ]];then
		count="1"
	for i in ./todo/*.txt; do
	[ -f "$i" ]|| break

	if [ "$choice" -eq  "$count" ];then
	cat $i
fi
	let count=count+1


	done

		elif [ $choice ==  "Q" ]; then
			let counter=counter+1;
		else echo "please enter a valid command!"
	fi
done
