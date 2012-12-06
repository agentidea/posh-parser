Import-Module .\TreeDSL.psm1 -Force

. .\machine.ps1

$treeID = "test-tree"
$nodeCollection = "astro_test"

Describe "setting tree state" {
    
    $expectedState = $STATE_ACCEPTING_NEW_NODES
    $ret = Set-TreeState $treeID $expectedState

    It "Should have received a resultCode of 1" {$ret.resultCode.should.be(1)}

    $actualState = Get-TreeState $treeID
    It "Should have the new state recorded" {$actualState.stateName.should.be($expectedState)}

    Purge-Documents $nodeCollection


}

Describe "adding a node" {

    $nodeID = "test-tree-A"
    $ret = Add-TreeNode $treeID $nodeID "null" "null" "templateX" "lion, cheetah, antelope"

    It "Should have a resultCode of 1" { $ret.resultCode.should.be(1) }

    Purge-Documents $nodeCollection


}