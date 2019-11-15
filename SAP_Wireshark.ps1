###############  Functions  ##############
function install_requirements {
    Write-Host "Gathering install location information..."
    $installPath=Get-ChildItem -Path C:\ -Recurse -Include "SAP_Wireshark.ps1" -ErrorAction SilentlyContinue
    $installDirectory = $installPath.DirectoryName

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    (New-Object System.Net.WebClient).DownloadFile("https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=tools/msvc2015AdminDeployment.xml;hb=HEAD", "$installDirectory\config.xml")
    (New-Object System.Net.WebClient).DownloadFile("https://go.microsoft.com/fwlink/?LinkId=532606&clcid=0x409", "$installDirectory\vs.exe")
    (New-Object System.Net.WebClient).DownloadFile("http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe", "$installDirectory\qt.exe")

    Invoke-Expression "& `"$installDirectory\qt.exe`" --script '$installDirectory\qt-5_9.qs'"
    Invoke-Expression "& `"$installDirectory\vs.exe`" /adminfile $installDirectory\config.xml /quiet /norestart /passive | Out-Null"
    choco install -y winflexbison git cmake strawberryperl python3 asciidoctorj xsltproc docbook-bundle
    refreshenv

    Write-Host -NoNewLine 'Your computer needs to be restarted to continue this process. Please rerun this script when the computer resumes. Press any key to continue with reboot...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    Restart-Computer
}

function wireshark_code {
	Write-Host "Gathering install location information..."
    $installPath=Get-ChildItem -Path C:\ -Recurse -Include "SAP_Wireshark.ps1" -ErrorAction SilentlyContinue
    $installDirectory = $installPath.DirectoryName
	cd $installDirectory
    mkdir SAP_Wireshark
    cd SAP_Wireshark
    C:\"Program Files"\Git\cmd\git.exe clone https://code.wireshark.org/review/wireshark
    cd wireshark
    C:\"Program Files"\Git\cmd\git.exe checkout master-2.6
    C:\"Program Files"\Git\cmd\git.exe clone https://github.com/CoreSecurity/SAP-Dissection-plug-in-for-Wireshark/ plugins/epan/sap
    C:\"Program Files"\Git\cmd\git.exe apply plugins/epan/sap/wireshark-master-2.6.patch
}

function make_and_build_wireshark {
    Write-Host "Gathering install location information..."
    $installPath=Get-ChildItem -Path C:\ -Recurse -Include "SAP_Wireshark.ps1" -ErrorAction SilentlyContinue
    $installDirectory = $installPath.DirectoryName
    Invoke-Expression "& `"$installDirectory\VSCP.bat`""
}

############  Processing  #################

if(Test-Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2015') {
    wireshark_code
    make_and_build_wireshark
}
else {
    install_requirements
}