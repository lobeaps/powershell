function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}
 
$password = Get-RandomCharacters -length 4 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 2 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 4 -characters '1234567890'
$password += Get-RandomCharacters -length 2 -characters '!"§$%&/()=?}][{@#*+'
$password = Scramble-String $password
$SecurePassword = ConvertTo-SecureString $password –asplaintext –force

Write-Host "Indtast brugernavn: "
$User = Read-Host 
New-LocalUser $User -Password $SecurePassword -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
Add-LocalGroupMember -Group "Users" -Member $User
Add-LocalGroupMember -Group "Remote Desktop Users" -Member $User

Write-Host "Brugernavn:"
Write-Host $User

Write-Host "Kodeord:"
Write-Host $password

Write-Host " "
