$EchoURL='https://funclogicmarcelaz204.azurewebsites.net/api/echo?code=HJPMEx0YxVIp84uoj1kKfDZKTMx2UFZfCiIOmQn/uDCEn2Hoj9dcTg=='
$InfoUrl='https://funclogicmarcelaz204.azurewebsites.net/api/getsettinginfo?code=xFCxi76YTRhPr9nZmGnfBvcC0Pw02fwQaONZEvuVFI0Ju9cwAcLmvA=='

Invoke-RestMethod -Method post -Body "3" -Uri $EchoURL
Invoke-RestMethod -Method post -Body "5" -Uri $EchoURL
Invoke-RestMethod -Method post -Body '"Hello"' -Uri $EchoURL
Invoke-RestMethod -Method post -Body '"{"msg": "Successful"}"' -Uri $EchoURL

Invoke-RestMethod -Uri $InfoURL