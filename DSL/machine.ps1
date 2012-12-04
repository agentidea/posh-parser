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

    Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow $url


    $ret = Call-TreeEndpoint $url
    $ret.commands | % {
        Write-Host $_.name
        $_.parameters | % {
            Write-Host -BackgroundColor Red $_.name + " " + $_.value
        }

    }

}



Function Call-TreeEndpoint ($url){
    $kreds = Get-Kreds
    $url = $url + "&kreds=" + $kreds

    Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue " calling ...  ENDPOINT:: $url "


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

    Write-Host -BackgroundColor Gray -ForegroundColor DarkMagenta " setting state on tree $stateName "

    $url = Get-FrontOfUrl "SetTreeState"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&stateName=$stateName"
    $url = $url + "&nodeCollection=astro_test"
    Call-TreeEndpoint $url
}


Function Get-TreeState ($treeID="babU") {
    $url = Get-FrontOfUrl "GetTreeState"
    $url = $url + "&treeID=$treeID"
    $url = $url + "&nodeCollection=astro_test"
    Call-TreeEndpoint $url
}



# run tests to tree that may not exist ...
Function Test-TreeState ($treeName) {

    $state = Get-TreeState $treeName
    $state.commands | % {


        Write-Host $_.name
        $_.parameters | % {

            Write-Host -BackgroundColor DarkGreen $_.name + " " + $_.value
        }

    }
}

Function Other-Calls {


    Test-TreeState "hope"
    Test-TreeState "babu"
    Set-TreeState "babu" "accepting_new_nodes"

    Add-TreeNode "babu" "A" "B,C,X" "null" "templateNamedFred" "tags,and,more,blah"
    Add-TreeNode "babu" "B" "D" "A" "templateNamedFred" "sausages"
    Add-TreeNode "babu" "C" "D" "A" "templateNamedFred" "jam,toast,beagles"
    Add-TreeNode "babu" "D" "null" "B,C" "templateNamedFred" "meerkat,emu"
    Add-TreeNode "babu" "X" "null" "A" "templateNamedFred" "yawl,canoe,wooden"

    Set-TreeState "babu" "ready_for_recalculation"


}



Other-Calls

 #Confirm-Tree "babu"