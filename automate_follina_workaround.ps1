# Script to check for the existence of the MSDT Protocol URL registry key and disable it
# Official Microsoft guidance here: https://msrc-blog.microsoft.com/2022/05/30/guidance-for-cve-2022-30190-microsoft-support-diagnostic-tool-vulnerability/
# It backs up the MSDT registry key and deletes the key
# Documentation for the script: https://www.virtualizationhowto.com/2022/06/automate-follina-vulnerability-workaround-with-powershell/
# Brandon Lee www.virtualizationhowto.com - v1.0

try { 
         
    Write-Host "Checking the system to see if the MSDT URL Protocol is still enabled" -ForegroundColor Yellow
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT 
    $regkeypath = 'HKCR:\ms-msdt'
    $check = (Get-ItemProperty $regkeypath)
         
    if ($check -ne $null) { 
        try { 
             
            Write-Warning "Your machine is vulnerable to the Follina vunerability CVE-2022-30190. Would you like to disable MSDT URL Protocol and backup the registry key?" -WarningAction Inquire 

            $filepath = Read-Host -Prompt "Enter your file path where you want to backup the registry key. If you don't enter anything, it will default to backing up to your desktop"
            if ([string]::IsNullOrWhiteSpace($filepath))
            {

                $filepath = "$($env:UserProfile)\Desktop\msdturlprotocol.reg"

            }

            reg export HKEY_CLASSES_ROOT\ms-msdt $filepath
            reg delete HKEY_CLASSES_ROOT\ms-msdt /f

                       
            Write-Host "The MSDT URL Protocol registry key has been backed up and has now been disabled" -ForegroundColor Green 

        } 
        catch { 
            Write-Host "You chose not to implement the MSDT URL Protocol workaround" -ForegroundColor Red 
        } 
    }     
    else { 

        Write-Host "Your workstation already has the MSDT URL Protocol workaround" -ForegroundColor Green

       


    }        
    
     
} 
         
catch { 
    Write-Host "Error running the script" -ForegroundColor Red 
}