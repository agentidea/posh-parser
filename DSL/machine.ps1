

[System.Reflection.Assembly]::LoadWithPartialName("System.Web") | out-null
function ConvertTo-UrlEncodedString([string]$dataToConvert)
{
    begin {
        function EncodeCore([string]$data) { return [System.Web.HttpUtility]::UrlEncode($data) }
    }
    process { if ($_ -as [string]) { EncodeCore($_) } }
    end { if ($dataToConvert) { EncodeCore($dataToConvert) } }
}
function ConvertFrom-UrlEncodedString([string]$dataToConvert)
{
    begin {
        function DecodeCore([string]$data) { return [System.Web.HttpUtility]::UrlDecode($data) }
    }
    process { if ($_ -as [string]) { DecodeCore($_) } }
    end { if ($dataToConvert) { DecodeCore($dataToConvert) } }
}
function ConvertTo-Base64EncodedString([string]$dataToConvert)
{
    begin {
        function EncodeCore([string]$data) { return [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($data)) }
    }
    process { if ($_ -as [string]) { EncodeCore($_) } }
    end { if ($dataToConvert) { EncodeCore($dataToConvert) } }
}
function ConvertFrom-Base64EncodedString([string]$dataToConvert)
{
    begin {
        function DecodeCore([string]$data) { return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($data)) }
    }
    process { if ($_ -as [string]) { DecodeCore($_) } }
    end { if ($dataToConvert) { DecodeCore($dataToConvert) } }
}


$STATE_ACCEPTING_NEW_NODES = "accepting_new_nodes"
$STATE_CALCULATING = "busy_calculating_graph"
$STATE_READY = "ready"
$STATE_DIRTY = "dirty"



Function Get-Protocol {

    return "http"
}
Function Get-Kreds {

    return "YWRtaW5fOGMzMTlmMjhkODFkMTUyN2E5NDI4ZTlhNWMyMTk1ZjU%3D"
}
Function Get-TreeHost ($commandName) {

    return "astro-dev.smartorg.com/rest?command=$commandName"
}

Function Get-FrontOfUrl ($commandName) {

    $_host = Get-TreeHost $commandName 
    $_protocol = Get-Protocol

    return   $_protocol + "://" + $_host
}


 
Function Add-TreeNode ($treeID,$nodeName,$children,$parent,$template,$tags) {

    $url = Get-FrontOfUrl "CreateNode"
    $url = $url + "&name=$nodeName"
    $url = $url + "&nodeID=$nodeName"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&parent=$parent"
    $url = $url + "&children=$children"
    $url = $url + "&tags=$tags"
    $url = $url + "&template=$template"
    $url = $url + "&nodeCollection=astro_test"

    $altWayToDoThis = @"

    &name=$nodeName
    &nodeID=$nodeName
    &treeID=$treeID
    &parent=$parent
    &children=$children
    &tags=$tags
    &template=$template
    &nodeCollection=astro_test
"@ 


    #Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow $url

    $resultCode = 0
    $message = ""

    $ret = Call-TreeEndpoint $url
    $ret.commands | % {
        $_.parameters | % {
           # Write-Host -BackgroundColor Red $_.name + " " + $_.value

            if($_.name -eq "message"){
                $message = $_.value
                #hack for missing resultCode
                if(([string] $_.value).Trim() -eq "node document saved")
                {
                    $resultCode = 1
                }
            }
            if($_.name -eq "resultCode"){
                $resultCode = $_.value
            }

        }

    }

    return New-Object PSObject -Property @{
       
        resultCode = $resultCode
        message = $message
    }
}



Function Call-TreeEndpoint ($url){
    $kreds = Get-Kreds
    $url = $url + "&kreds=" + $kreds
    #Write-Host " calling ...  ENDPOINT:: $url "
    return Invoke-RestMethod $url
}


Function Confirm-Tree ($treeID){

    Write-Host -BackgroundColor Gray -ForegroundColor DarkMagenta " setting state on tree $stateName "

    $url = Get-FrontOfUrl "Tree2Dag2"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&collection=astro_test"
    $ret = Call-TreeEndpoint $url
    $ret.commands | % {
        Write-Host $_.name
        $_.parameters | % {
            Write-Host $_.name + " " + $_.value
        }
     }
}

Function Set-TreeState ($treeID,$stateName){
    #Write-Host -BackgroundColor Gray -ForegroundColor DarkMagenta " setting state on tree $stateName "
    $resultCode = -1
    $message = ""
    $url = Get-FrontOfUrl "SetTreeState"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&stateName=$stateName"
    $url = $url + "&nodeCollection=astro_test"
    $ret = Call-TreeEndpoint $url
    $ret.commands | % {
        $_.parameters | % {
           
            if($_.name -eq "message"){
                $message = $_.value
            }
            if($_.name -eq "resultCode"){
                $resultCode = $_.value
            }
        }
    }

    return New-Object PSObject -Property @{
        resultCode = $resultCode
        message = $message
    }
}


Function Purge-Documents($nodeCollection) {
    $resultCode = 1
    $message = ""

    $url = Get-FrontOfUrl "PurgeTable"
    $url = $url + "&tableName=$nodeCollection"
    $ret = Call-TreeEndpoint $url

    $ret.commands | % {
        $_.parameters | % {
            #Write-Host -backgroundColor DarkGreen $_.name + " " + $_.value

            if( $_.name -eq "msg"){
                $x =  ConvertFrom-UrlEncodedString $_.value
                $message = ConvertFrom-Base64EncodedString $x
            }
        }
     }

      return New-Object PSObject -Property @{
        resultCode = $resultCode
        message = $message
        }



}


Function Call-TreeState ($treeID="babU") {
    $url = Get-FrontOfUrl "GetTreeState"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&nodeCollection=astro_test"
    Call-TreeEndpoint $url
}





# run tests to tree that may not exist ...
Function Get-TreeState ($treeName) {

    $stateName = ""
    $resultCode = -1
    $message = ""

    $state = Call-TreeState $treeName
    $state.commands | % {
       
        $_.parameters | % {
            if($_.name -eq "stateName"){
                $stateName = $_.value
            }
            if($_.name -eq "message"){
                $message = $_.value
            }
            if($_.name -eq "resultCode"){
                $resultCode = $_.value
            }
        
        }
    }

    return New-Object PSObject -Property @{

        stateName = $stateName
        resultCode = $resultCode
        message = $message

    }




}

Function Test-Calls {
    Get-TreeState "hope"
    Get-TreeState "babu"
    Set-TreeState "babu" "accepting_new_nodes"

    Add-TreeNode "babu" "A" "B,C,X" "null" "templateNamedFred" "tags,and,more,blah"
    Add-TreeNode "babu" "B" "D" "A" "templateNamedFred" "sausages"
    Add-TreeNode "babu" "C" "D" "A" "templateNamedFred" "jam,toast,beagles"
    Add-TreeNode "babu" "D" "null" "B,C" "templateNamedFred" "meerkat,emu"
    Add-TreeNode "babu" "X" "null" "A" "templateNamedFred" "yawl,canoe,wooden"

    Set-TreeState "babu" "ready_for_recalculation"
}

#Test-Calls
#Purge-Documents astro_test





