Write-Host "After connecting enter:"
Write-Host "-----------------------"
Write-Host "Echo:"
Write-Host "1) cd api"
Write-Host "2) cd echo"
Write-Host "3) post --content 3"
Write-Host "4) post --content 5"
Write-Host '5) post --content "Hello"'
Write-Host '6) post --content "{"msg": "Successful"}"'
Write-Host "enter exit to exit"
Write-Host
Write-Host "Get Setting Info:"
Write-Host "1) cd api"
Write-Host "2) cd getsettinginfo"
Write-Host "3) get"
Write-Host "enter exit to exit"
Write-Host
httprepl http://localhost:7071

