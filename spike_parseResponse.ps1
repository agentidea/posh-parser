$tree = @"
 {"commands":[{"name":"SetKontext","paramCount":"1","parameters":[{"name":"node_id","value":"36816171d61ae29e2a8aef9b79550ae5"}]},{"name":"SetKontext", "paramCount":"1","parameters":[{"name":"message","value":"success"}]}],"context":{}}
"@ | ConvertFrom-Json

$tree.commands | % {
    $_.parameters
} | Format-Table -AutoSize