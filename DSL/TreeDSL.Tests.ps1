. .\TreeDSL.ps1

Describe "Test Tree DSL with One Node" {

    $oneNodeTree = Init {
                        NewTree "Tree" {
                            AddNode "Node1" "template"
                        }
                   }

    It "Should have a treename of Tree" {
        $oneNodeTree.TreeName.should.be("Tree")
    }

    It "Should have a ParentNode of root" {
        $oneNodeTree.ParentNode.should.be("root")
    }

    It "Should have a NodeName of Node1" {
        $oneNodeTree.NodeName.should.be("Node1")
    }

    It "Should have a Template of template" {
        $oneNodeTree.Template.should.be("template")
    }
}

Describe "Test Tree DSL with Two Nodes" {

    $twoNodeTree = Init {
                        NewTree "Tree" {
                            AddNode "Node1" "template"
                            AddNode "Node2" "template"
                        }
                   }

    It "Should have a 2 nodes" {
        $twoNodeTree.should.have_count_of(2)
    }

    It "First node should have a treename of Tree" {
        $twoNodeTree[0].TreeName.should.be("Tree")
    }

    It "First node should have a NodeName of Node1" {
        $twoNodeTree[0].NodeName.should.be("Node1")
    }

    It "Second node should have a treename of Tree" {
        $twoNodeTree[1].TreeName.should.be("Tree")
    }

    It "Second node should have a NodeName of Node2" {
        $twoNodeTree[1].NodeName.should.be("Node2")
    }
}

Describe "Test Tree DSL with Two Nodes, tags and shares" {

    $twoNodeTree = Init {
                        NewTree "Tree" {
                            AddNode "Node1" "template"
                            AddNode "Node2" "template"
                        }

                        addTags Node2 'a'
                        shareNode Node2 Node1
                   }

    It "Should have a 2 nodes"                       { $twoNodeTree.should.have_count_of(2) }
    It "First node should have a treename of Tree"   { $twoNodeTree[0].TreeName.should.be("Tree") }
    It "First node should have a NodeName of Node1"  { $twoNodeTree[0].NodeName.should.be("Node1") }
    It "Second node should have a treename of Tree"  { $twoNodeTree[1].TreeName.should.be("Tree") }
    It "Second node should have a NodeName of Node2" { $twoNodeTree[1].NodeName.should.be("Node2") }
    It "Second node should have 1 tag"               { $twoNodeTree[1].tags.should.have_count_of(1) }
    It "Second node should have 1 shared node"       { $twoNodeTree[1].SharedNode.should.have_count_of(1) }
    It "Second node should 1 shared node of Node1"   { $twoNodeTree[1].SharedNode[0].should.be("Node1") }
}