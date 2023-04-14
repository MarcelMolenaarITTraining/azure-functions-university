$EchoURL='https://funclogicmarcelaz204.azurewebsites.net/api/echo?code=HJPMEx0YxVIp84uoj1kKfDZKTMx2UFZfCiIOmQn/uDCEn2Hoj9dcTg=='
$InfoUrl='https://funclogicmarcelaz204.azurewebsites.net/api/getsettinginfo?code=xFCxi76YTRhPr9nZmGnfBvcC0Pw02fwQaONZEvuVFI0Ju9cwAcLmvA=='


az rest --method post --body '3' --url $EchoURL 
az rest --method post --body '5' --url $EchoURL
az rest --method post --body '"Hello"' --url $EchoURL
az rest --method post --body '"{"msg": "Successful"}"' --url $EchoURL
az rest --method get --url $InfoURL

# az rest --method get --url 'https://securefuncmarcelaz204.azurewebsites.net/api/fileparser?code=4O0MyAgwSYwCDT/5Q4PMrQugKhLE3178ssNlUKy9CybMUMli4YTMtg=='
Start-Process $InfoURL