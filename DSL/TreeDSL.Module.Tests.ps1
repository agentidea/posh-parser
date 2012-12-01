Import-Module .\TreeDSL.psm1 -Force

Describe "Test Tree module" {
    
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