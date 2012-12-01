function Init {
    param([scriptblock]$sb)
     
    $Script:hash = @()

    $stack = new-object system.collections.stack 
    $stack.Push("root")

    & $sb
 
    $Script:hash
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
        $TemplateName, 
        [ScriptBlock]
        $AddNodeScriptBlock
    )

    $Script:hash += [PSCustomObject] @{
        TreeName   = $TreeName
        ParentNode = $stack.Peek()
        NodeName   = $NodeName
        Template   = $TemplateName
        SharedNode = @()
        Tags       = @()
    }
                                
    $stack.Push($NodeName) | Out-Null

    if($AddNodeScriptBlock) {
        & $AddNodeScriptBlock
    }
                
    $stack.Pop() | Out-Null
}

function shareNode {

    param($SourceNode, $DestinationNode)

    ($Script:hash | where NodeName -eq $SourceNode).SharedNode += $DestinationNode
}

function addTags {
        
    param($NodeName, $Tags)
                
    ($Script:hash | where NodeName -eq $NodeName).Tags = $Tags
}
