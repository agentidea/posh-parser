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


}



Function Call-TreeEndpoint ($url){
    $kreds = Get-Kreds
    $url = $url + "&kreds=" + $kreds

    Write-Host -BackgroundColor Gray -ForegroundColor DarkBlue " calling ...  ENDPOINT:: $url "


    return Invoke-RestMethod $url
        
}




Function Set-TreeState ($treeID,$stateName){

    Write-Host -BackgroundColor Gray -ForegroundColor DarkMagenta " setting state on tree $stateName "


}


Function Get-TreeState ($treeID="babU") {



    $url = Get-FrontOfUrl "GetTreeState"
    $url = $url + "&treeID=$treeID"

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

 Test-TreeState "charity"
 Test-TreeState "hope"