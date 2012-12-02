function Init {
    param([scriptblock]$sb)
     
    $Script:nodeList = @()

    $stack = new-object system.collections.stack 
    $stack.Push($null)

    & $sb
 
    $Script:nodeList
}

function newTree {

    param($Script:TreeName, [scriptblock]$sb)

    & $sb        
}

function addNode {
        
    param(            
        [string]
        $NodeName, 
        [string]
        $Template, 
        [ScriptBlock]
        $AddNodeScriptBlock
    )

    $Parent = $stack.Peek()
    $newNode = New-Node `
        -NodeName   $NodeName `
        -Children   $Children `
        -Parent     $Parent `
        -TreeName   $TreeName `
        -SharedNode $SharedNode `
        -Template   $Template `
        -Tags       $Tags

    # Add this node as a child to the Parent
    if($Parent) {
        ($Script:nodeList | Where NodeName -eq $Parent).Children += $NodeName
    }

    $found = ($Script:nodeList | Where NodeName -eq $NodeName)
    if($found) {
        # Update
        $found.Parent += $Parent
    } else {
        # Create
        $Script:nodeList += $newNode
    }

    #$Script:nodeList += $newNode

    $stack.Push($NodeName) | Out-Null

    if($AddNodeScriptBlock) {
        & $AddNodeScriptBlock
    }
                
    $stack.Pop() | Out-Null
}

function shareNode {

    param($SourceNode, $DestinationNode)

    ($Script:nodeList | where NodeName -eq $SourceNode).SharedNode += $DestinationNode
}

function addTags {
        
    param($NodeName, $Tags)
                
    ($Script:nodeList | where NodeName -eq $NodeName).Tags += $Tags
}

function New-Node {
    param(
        $NodeName,
        $Children,
        $Parent,
        $TreeName,
        $SharedNode,
        $Template,
        $Tags
    )

    $newNode = [PSCustomObject] @{
        NodeName   = ""
        Children   = @()
        Parent     = @()
        TreeName   = ""
        SharedNode = @()
        Template   = ""
        Tags       = @()
    }
    
    $newNode.NodeName = $NodeName
    $newNode.TreeName = $TreeName
    $newNode.Template = $Template

    if($Children)   { $newNode.Children   += $Children}
    if($Parent)     { $newNode.Parent     += $Parent}
    if($SharedNode) { $newNode.SharedNode += $SharedNode}
    if($Tags)       { $newNode.Tags       += $Tags}

    return $newNode

}