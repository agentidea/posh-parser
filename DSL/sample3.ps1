cls
Import-Module .\TreeDSL.psm1
$graph = Init {
    newTree "Tree" {
        addNode A templateA {
            addNode B templateB { addNode D templateD }
            addNode C templateC { addNode D templateD }
        }
    }

    addTags  A @('baboon','emu','meerkat')
    addTags  B TagB
    addTags  C TagC
    addTags  D TagD

}

$graph | ft -a

#prepare a lookup
$hsh = @{}
$graph | % {
    $hsh.add($_.NodeName,$_.NodeID)
}

#substitute node names with id
#issue with repeat node names???
$graph | % {
    $array = $_.Children
    for ($i=0; $i -lt $array.length; $i++) {
	    $array[$i] = $hsh[$array[$i]]
    }
    $array = $_.Parent
    for ($i=0; $i -lt $array.length; $i++) {
	    $array[$i] = $hsh[$array[$i]]
    }
}

$graph | ft -a