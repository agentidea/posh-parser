start {
   newTree "Consumer Products" {
      addNode "household" "newProductExtension.xls" {
   		addNode "cleaners" "newProductExtension.xls"
   	}
   	
      addNode "workshop" "newProduct.xls"

   	addNode "garden" "newProduct.xls" {
   		addNode "shed" "newProduct.xls" 
   	}
   }

   #newTree <<tree name>>
   #addNode <<node name>> <<template name>>

   #idea above, works for hierarchies, not sure how to handle the DAG tho?
   #we have the share node idea
   shareNode "shed" "household"    #target, destination

   #tag tree
   addTags "cleaners" ['non-toxic','fragrant','blue']   #node name, list tags
}