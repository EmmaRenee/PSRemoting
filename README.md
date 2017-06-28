# PSRemoting
Remotely configre PowerShell Remoting.

winrm.ps1 runs the winrm quickconfig command silently via PsExec. This command will configure WinRM, WSMan, and enable the required Windows Fireweall rule. This works great for new systems that haven't previously had remoting configured. I have however found that it is a bit hit or miss for systems on which remoting has stopped working, either due to a software update, or some other fault withing WinRM or WSMan. 

wsman-fix.ps1 attempts to register the PowerShell plugins in WSMan. I have found that sometimes after installing a new version of the WMF the plugins go missing in WSMan, causing remoting to fail. Re-registering these plugins resolves the issue. 
