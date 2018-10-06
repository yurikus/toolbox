#define MyAppName "Docker Toolbox"
#define MyAppPublisher "Docker"
#define MyAppURL "https://docker.com"
#define MyAppContact "https://docker.com"

#define dockerCli "..\bundle\docker.exe"
#define dockerMachineCli "..\bundle\docker-machine.exe"
#define dockerComposeCli "..\bundle\docker-compose.exe"
#define vmwareWsDriver "..\bundle\docker-machine-driver-vmwareworkstation.exe"

[Setup]
AppCopyright={#MyAppPublisher}
AppId={{FC4417F0-D7F3-48DB-BCE1-F5ED5BAFFD91}
AppContact={#MyAppContact}
AppComments={#MyAppURL}
AppName={#MyAppName} {#MyAppVersion} (vmWare {#vmWareWsDriverVersion})
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName=Docker
DisableProgramGroupPage=yes
DisableWelcomePage=yes
OutputBaseFilename=DockerToolbox
Compression=lzma
SolidCompression=yes
WizardImageFile=windows-installer-side.bmp
WizardSmallImageFile=windows-installer-logo.bmp
WizardImageStretch=yes
UninstallDisplayIcon={app}\unins000.exe
SetupIconFile=toolbox.ico
ChangesEnvironment=true

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Full installation"

[Run]
Filename: "{app}\create-vm.cmd"; Parameters: ""; Flags: postinstall; Description: "Create docker VM"

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"
Name: modifypath; Description: "Add docker binaries to &PATH"

[Components]
Name: "Docker"; Description: "Docker Client for Windows" ; Types: full; Flags: fixed
Name: "DockerMachine"; Description: "Docker Machine for Windows" ; Types: full; Flags: fixed
Name: "DockerCompose"; Description: "Docker Compose for Windows" ; Types: full; Flags: fixed
Name: "vmWareDriver"; Description: "Docker vmWare Driver" ; Types: full; Flags: fixed

[Files]
Source: ".\docker-quickstart-terminal.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#dockerCli}"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\create-vm.cmd"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\create-vm.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\start.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: "{#dockerMachineCli}"; DestDir: "{app}"; Flags: ignoreversion; Components: "DockerMachine"
Source: "{#dockerComposeCli}"; DestDir: "{app}"; Flags: ignoreversion; Components: "DockerCompose"
Source: "{#vmwareWsDriver}"; DestDir: "{app}"; Flags: ignoreversion; Components: "vmWareDriver"

[Icons]
Name: "{userprograms}\Docker\Docker Quickstart Terminal"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start.sh"""; IconFilename: "{app}/docker-quickstart-terminal.ico"; Components: "Docker"
Name: "{commondesktop}\Docker Quickstart Terminal"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start.sh"""; IconFilename: "{app}/docker-quickstart-terminal.ico"; Tasks: desktopicon; Components: "Docker"

[UninstallRun]
Filename: "{app}\docker-machine.exe"; Parameters: "rm -f default"
Filename: "{sys}\reg.exe"; Parameters: "delete HKCU\Environment /F /V DOCKER_CERT_PATH"; WorkingDir: "{sys}"
Filename: "{sys}\reg.exe"; Parameters: "delete HKCU\Environment /F /V DOCKER_HOST"; WorkingDir: "{sys}"
Filename: "{sys}\reg.exe"; Parameters: "delete HKCU\Environment /F /V DOCKER_MACHINE_NAME"; WorkingDir: "{sys}"
Filename: "{sys}\reg.exe"; Parameters: "delete HKCU\Environment /F /V DOCKER_TLS_VERIFY"; WorkingDir: "{sys}"
Filename: "{sys}\reg.exe"; Parameters: "delete HKCU\Environment /F /V NO_PROXY"; WorkingDir: "{sys}"

[UninstallDelete]

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"DOCKER_TOOLBOX_INSTALL_PATH"; ValueData:"{app}" ; Flags: preservestringtype uninsdeletevalue;
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"

[Code]

procedure TrackEvent(name: String);
begin
end;

procedure InitializeWizard;
begin
end;

function InitializeSetup(): boolean;
begin
  TrackEvent('Installer Started');
  Result := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True
end;

const
  ModPathName = 'modifypath';
  ModPathType = 'user';

function ModPathDir(): TArrayOfString;
begin
  setArrayLength(Result, 1);
  Result[0] := ExpandConstant('{app}');
end;

#include "modpath.iss"

procedure CurStepChanged(CurStep: TSetupStep);
var
  Success: Boolean;
begin
  Success := True;
  if CurStep = ssPostInstall then
  begin
    trackEvent('Installing Files Succeeded');
    if IsTaskSelected(ModPathName) then
      ModPath();
    if Success then
      trackEvent('Installer Finished');
  end;
end;
