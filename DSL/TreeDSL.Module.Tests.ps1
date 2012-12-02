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
    $actual = Init {
                newTree "Tree" {
                    addNode A templateA.xls {
                        addNode B templateB.xls { addNode D templateD.xls }
                        addNode C templateC.xls { addNode D templateD.xls }
                    }
                }

                addTags -NodeName A -Tags TagA
                addTags -NodeName B -Tags TagB
                addTags -NodeName C -Tags TagC
                addTags -NodeName D -Tags TagD
              }

    $NodeA = $actual | where NodeName -eq "A"
    $NodeB = $actual | where NodeName -eq "B"
    $NodeC = $actual | where NodeName -eq "C"
    $NodeD = $actual | where NodeName -eq "D"

    It "Should have 4 entries" { $actual.should.have_count_of(4) }
    
    It "Should be NodeA" {$NodeA.NodeName.should.be("A")}
    It "Should be NodeB" {$NodeB.NodeName.should.be("B")}
    It "Should be NodeC" {$NodeC.NodeName.should.be("C")}
    It "Should be NodeD" {$NodeD.NodeName.should.be("D")}

    # Test Templates
    ForEach($node in ($NodeA, $NodeB, $NodeC, $NodeD)) {
        $templateName = "template$($node.NodeName).xls"
        It "Template should be $($templateName)" { $node.Template.should.be($templateName) }
    }

    # Test Children nodes
    It "NodeA should have 2 children" { $NodeA.Children.should.have_count_of(2) }
    It "NodeA verify child NodeName" { 
        $NodeA.Children[0].should.be("B")
        $NodeA.Children[1].should.be("C")
    }
    
    It "NodeB should have 1 child"    { $NodeB.Children.should.have_count_of(1) }
    It "NodeB verify child NodeName"  { $NodeB.Children[0].should.be("D") }    

    It "NodeC should have 1 child"    { $NodeC.Children.should.have_count_of(1) }
    It "NodeC verify child NodeName"  { $NodeC.Children[0].should.be("D") }    
    
    It "NodeD should have 0 children" { $NodeD.Children.should.have_count_of(0) }

    # Test Parent nodes
    It "NodeA should have 0 parents"  { $NodeA.Parent.should.have_count_of(0) }
    
    It "NodeB should have 1 parent"   { $NodeB.Parent.should.have_count_of(1) }
    It "NodeB should have A as parent" { $NodeB.Parent[0].should.be("A") }

    It "NodeC should have 1 parent"   { $NodeC.Parent.should.have_count_of(1) }
    It "NodeC should have A as parent" { $NodeC.Parent[0].should.be("A") }

    It "NodeD should have 2 parents"  { $NodeD.Parent.should.have_count_of(2) }
    It "NodeD should have B, C as parent" { 
        $NodeD.Parent[0].should.be("B") 
        $NodeD.Parent[1].should.be("C") 
    }

    # Test Tags
    ForEach($node in ($NodeA, $NodeB, $NodeC, $NodeD)) {
        
        $tagName = "Tag$($node.NodeName)"        
        It "Node $($node.NodeName) should have 1 tag" { $node.Tags.should.have_count_of(1) }
        It "Node $($node.NodeName) should have tag $($tagName)" { $node.Tags[0].should.be($tagName) }        
    }

}