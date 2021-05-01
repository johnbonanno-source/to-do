import mysql.connector





try:
    cnx = mysql.connector.connect(
        user='token_2a45',
        host='127.0.0.1',
        database='jab0629_todo',
        password = 'FUyhsk7DV9adpJpV'
    )

    cursor = cnx.cursor()
    response = 1

    while (response > 0):
        print ("Welcome to todo List manager")
        print ("to do items:")
        query = f"""SELECT id, name, description
                    FROM todo"""    
        cursor.execute(query)
       

        for (id, name, description) in cursor:
            print(f'{id} - {name} : {description}')
        

        print ("Main Menu:")
        print ("Press 1 to complete an item")
        print ("Press 2 to add a new item")
        print ("Press 3 to delete an item")
        print ("Press 4 to show completed items")
        #query from completed table
        print ("Press 5 to show statistics")
        print ("Press 0 to exit")

        reset = f"""ALTER TABLE todo AUTO_INCREMENT = 1
            """    
        cursor.execute(reset)

        completedItemNumber = 0 ###updates with each completion

        num = int(input("Please select an option  :"))
        

        if num==1:
            #completedItemNumber = completedItemNumber+1      
            completeItem = input("Please enter a todo item number to complete: ")                     
            cursor.execute("""INSERT INTO completed (id, name, description, ts)
                        SELECT todo.id,todo.name, todo.description, todo.time_created
                        FROM todo
                        WHERE todo.id = %s""", (completeItem,))

            cursor.execute("""UPDATE completed SET timeToComplete = (
                        SELECT SEC_TO_TIME(TIMESTAMPDIFF(SECOND,ts,tf))
                        FROM completed
                        WHERE completed.id = %s)""", (completeItem,))

            cursor.execute("""DELETE
                        FROM todo
                        WHERE id = %s""", (completeItem,))
            print("congratulations!")

        elif num==2:

            itemName = input("Please enter a name for your to-do item: ")
            itemDesc = input("please enter a description for the item that you'd like to add: ")
            cursor.execute("""INSERT INTO todo (name, description) 
                            VALUES (%s, %s)""", (itemName, itemDesc))
                            
        elif num==3:
            print ("choice 3")
            completeItem = input("Please enter a item number to delete ")

            cursor.execute("""DELETE
                        FROM todo
                        WHERE id = %s""", (completeItem,))
        elif num==4:
            print ("completed items")
            completeList = f"""SELECT name, description
                    FROM completed
                    WHERE id > 0
                    ORDER BY ts DESC
            """    
            cursor.execute(completeList)
            
            #SELECT name,description
             #   FROM completed
              #  ORDER BY completed.tf DESC


            for (name, description) in cursor:
                print(f'{name} - {description}')

        elif num==5:

            print ("completed items: ")

            todoList = f"""SELECT count(id) as counted
                    FROM completed
                    
            """    
            cursor.execute(todoList)

            for (counted) in cursor:
                print(f'{counted}')

            print ("average time to complete items: ")

            sumL = f"""SELECT AVG(timeToComplete) as tcomp
                    FROM completed
            """    

            cursor.execute(sumL)

            for (tcomp) in cursor:
                print(f'{tcomp}')


            print("number of items left to complete")
            countTodo = f"""SELECT count(id) as num
                    FROM todo
            """    
            cursor.execute(countTodo)

            for (num) in cursor:
                print(f'{num}')
        
        elif num==0:
            response=0
        else:
            print ("no such menu option")



    #break
except mysql.connector.Error as err:
    print(err)
else:   
    # Invoked if no exception was thrown
    cnx.close()
