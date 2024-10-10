echo "Deleting the old profile then linking to this one"
rm $profile
cmd /c mklink $profile "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"

echo ""
echo "Deleting the old nvim dir then linking to this one"
$nvimDir = "$env:USERPROFILE\AppData\Local\nvim\"
echo $nvimDir
rm $nvimDir -ErrorAction SilentlyContinue
cmd /c mklink /d $nvimDir "$PSScriptRoot\..\nvim"

