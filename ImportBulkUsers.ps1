# Import active directory module 
Import-Module activedirectory
  
#Import the data from InputU.csv 
$ADUsers = Import-csv C:\temp\InputU.csv

foreach ($User in $ADUsers)
{
			
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
	$OU 		= $User.ou 
        
	#Verify if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user exists, give a warning
		 Write-Warning "User account with username $Username already exists in Active Directory."
	}
	else
	{
		#Accounts will be created in the mentioned OU
		New-ADUser -SamAccountName $Username -UserPrincipalName "$Username@NTECH.COM" -Name "$Firstname $Lastname" `
            -GivenName $Firstname -Surname $Lastname -Enabled $True -DisplayName "$Firstname, $Lastname" -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False          
	}
}