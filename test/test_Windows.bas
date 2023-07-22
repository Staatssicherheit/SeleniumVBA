Attribute VB_Name = "test_Windows"
Option Explicit
Option Private Module
'@folder("SeleniumVBA.Testing")

Sub test_windows1()
    Dim driver As SeleniumVBA.WebDriver
    Dim caps As SeleniumVBA.WebCapabilities
    Dim hnd1 As String, hnd2 As String, i As Integer
    
    Set driver = SeleniumVBA.New_WebDriver
    
    driver.StartChrome
    Set caps = driver.CreateCapabilities(initializeFromSettingsFile:=False)
    driver.OpenBrowser caps

    driver.NavigateTo "https://www.wikipedia.org/"
    driver.Wait 1000
    
    hnd1 = driver.GetCurrentWindowHandle
    hnd2 = driver.SwitchToNewWindow(svbaTab) 'this will create a new browser tab
    'hnd2 = Driver.SwitchToNewWindow(svbaWindow) 'this will create a new browser window
    
    driver.NavigateTo "https://en.wikipedia.org/wiki/Main_Page"
    driver.Wait 1000
    
    Debug.Print hnd2 & " is same as " & driver.GetCurrentWindowHandle
    
    driver.SwitchToWindow hnd1
    driver.Wait 1000
    driver.SwitchToWindow hnd2
    driver.Wait 1000
    
    Debug.Print "first window handle: " & driver.GetWindowHandles()(1)
    Debug.Print "second window handle: " & driver.GetWindowHandles()(2)
    
    'can switch based on index too
    For i = 1 To 5
        driver.SwitchToWindow 1
        driver.Wait 500
        driver.SwitchToWindow 2
        driver.Wait 500
    Next i
    
    driver.CloseWindow
    driver.Wait 1000

    driver.CloseBrowser
    driver.Shutdown
End Sub

Sub test_windows2()
    Dim driver As SeleniumVBA.WebDriver
    Dim caps As SeleniumVBA.WebCapabilities
    Dim mainHnd As String
    Dim allHnds() As String
    Dim i As Integer
    
    Set driver = SeleniumVBA.New_WebDriver
    
    driver.StartEdge
    Set caps = driver.CreateCapabilities(initializeFromSettingsFile:=False)
    driver.OpenBrowser caps
    
    driver.NavigateTo "http://demo.guru99.com/popup.php"
    
    driver.MaximizeWindow
    
    driver.Wait 2000
    
    driver.FindElement(By.XPath, "//*[contains(@href,'popup.php')]").Click
    
    mainHnd = driver.GetCurrentWindowHandle
    allHnds = driver.GetWindowHandles
    
    For i = 1 To UBound(allHnds)
        If allHnds(i) <> mainHnd Then
            driver.SwitchToWindow allHnds(i)
            driver.Wait
            driver.FindElement(By.Name, "emailid").SendKeys "gaurav.3n@gmail.com"
            driver.Wait 2000
            driver.FindElement(By.Name, "btnLogin").Click
            driver.Wait 2000
            driver.CloseWindow
            Exit For
        End If
    Next i
    
    ' Switching to Parent window i.e Main Window.
    driver.SwitchToWindow mainHnd
    
    driver.Wait 2000
    
    driver.CloseBrowser
    driver.Shutdown
End Sub

