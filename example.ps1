start {

   #create a new tree
   newTree "Consumer Products" {

      #add Nodes
      addNode "household" "newProductExtension.xls" {
   		addNode "cleaners" "newProductExtension.xls"
   	}
   	
      addNode "workshop" "newProduct.xls"

   	addNode "garden" "newProduct.xls" {
   		addNode "shed" "newProduct.xls" 
   	}
   }

   

   #DAG created by  share node command
   shareNode "shed" "household"   

   #tag a node
   addTags "cleaners" ['non-toxic','fragrant','blue']   
}

#--------------
#documentation 
#--------------

#newTree <<tree name>>
#addNode <<node name>> <<template name>>
#shareNode <<target node name>> <<node name>>
#addTags <<node name>> <<[list of tags]>>