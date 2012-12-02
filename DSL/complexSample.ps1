Import-Module .\TreeDSL.psm1 -Force

function ql {$args}

$node = ql Plane Train Automobile Bike Ship Skateboard

Init {

    NewTree "Test Spike" {
        addNode "Vehicle" -AddNodeScriptBlock {
            $node | % { addNode $_ "TestTemplate.xls"}
            $node | % { addTags $_ "Vehicle" }
        }
    }

    shareNode Plane Train
    shareNode Ship Train

} | ft -a