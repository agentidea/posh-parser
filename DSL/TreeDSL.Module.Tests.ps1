Import-Module .\TreeDSL.psm1 -Force

Describe "Test Simple Tree module" {
    $actualTree = Init {
                        newTree "Tree" { 
                            addNode A templateA.xls
                        }

                        addTags A "tagA"
                   }
    
    It "Should have a tree name"      { $actualTree.TreeName.should.be("Tree") }
    It "Should have a node name"      { $actualTree.NodeName.should.be("A") }
    It "Should have a template name"  { $actualTree.Template.should.be("templateA.xls") }
    It "Should have a tag count of 1" { $actualTree.Tags.should.have_count_of(1) }    
    It "Should have a tag name"       { $actualTree.Tags[0].should.be("tagA") }    
}

Describe "Test A->B nodes" {
    $actualTree = Init {
                        newTree "Tree" { 
                            addNode A templateA.xls {
                                addNode B templateB.xls
                            }
                        }
                   }

    $NodeA = $actualTree[0]
    $NodeB = $actualTree[1]

    It "Should have two entries"         { $actualTree.should.have_count_of(2) }
    It "NodeA should have a tree name"   { $NodeA.TreeName.should.be("Tree") }
    It "NodeB should have a tree name"   { $NodeB.TreeName.should.be("Tree") }
    It "NodeA should have a template"    { $NodeA.Template.should.be("templateA.xls") }
    It "NodeB should have a template"    { $NodeB.Template.should.be("templateB.xls") }

    It "NodeA should have 0 parents"     { $NodeA.Parent.should.have_count_of(0) }
    It "NodeB should have 1 parent"      { $NodeB.Parent.should.have_count_of(1) }
    
    It "NodeA should have 1 child"       { $NodeA.Children.should.have_count_of(1) }
    It "NodeA should have a NodeB Child" { $NodeA.Children[0].should.be("B") }    
    It "NodeB should have 0 children"    { $NodeB.Children.should.have_count_of(0) }

}

Describe "Test A->B-D A->C->D nodes" {
    $actualTree = Init {
                        newTree "Tree" { 
                            addNode A templateA.xls {
                                addNode B templateB.xls { addNode D }
                                addNode C templateB.xls { addNode D }
                            }
                        }
                   }

    $NodeA = $actualTree | where NodeName -eq "A"
    $NodeB = $actualTree | where NodeName -eq "B"
    $NodeC = $actualTree | where NodeName -eq "C"
    $NodeD = $actualTree | where NodeName -eq "D"

    It "Should have 4 entries" { $actualTree.should.have_count_of(4) }
    
    It "Should be NodeA" {$NodeA.NodeName.should.be("A")}
    It "Should be NodeB" {$NodeB.NodeName.should.be("B")}
    It "Should be NodeC" {$NodeC.NodeName.should.be("C")}
    It "Should be NodeD" {$NodeD.NodeName.should.be("D")}

#    It "NodeA should have a tree name"   { $NodeA.TreeName.should.be("Tree") }
#    It "NodeB should have a tree name"   { $NodeB.TreeName.should.be("Tree") }
#    It "NodeA should have a template"    { $NodeA.Template.should.be("templateA.xls") }
#    It "NodeB should have a template"    { $NodeB.Template.should.be("templateB.xls") }
#    It "NodeA should have 0 parents"     { $NodeA.Parent.should.have_count_of(0) }
#    It "NodeB should have 1 parent"      { $NodeB.Parent.should.have_count_of(1) }
#    
#    It "NodeA should have 1 child"       { $NodeA.Children.should.have_count_of(1) }
#    It "NodeA should have a NodeB Child" { $NodeA.Children[0].should.be("B") }    
#    It "NodeB should have 0 children"    { $NodeB.Children.should.have_count_of(0) }

}