
Import-Module .\TreeDSL.psm1

Init {
    newTree "Tree Name" {
        addNode "test"  "testTemplateTest.xls" { addNode "testA" }
        addNode "test2" "testTemplateTest2.xls"
	    addNode "test3" "testTemplateTest3.xls" { addNode "test3A"}
    }

    #idea above, works for hierarchies, not sure how to handle the DAG tho?
    #we have the share node idea
    shareNode "test3A" "test2"    #target, destination

    #tag tree
    addTags "test3A" @('baboon','emu','meerkat')   #node name, list tags
} | Format-Table -AutoSize