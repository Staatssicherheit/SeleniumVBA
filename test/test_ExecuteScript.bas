Attribute VB_Name = "test_ExecuteScript"
Option Explicit
Option Private Module
'@folder("SeleniumVBA.Testing")

Sub test_executeScript()
    Dim driver As SeleniumVBA.WebDriver
    Dim webElem As SeleniumVBA.WebElement
    Dim Url As String

    Set driver = SeleniumVBA.New_WebDriver

    driver.StartChrome
    driver.OpenBrowser

    Url = "http://demo.guru99.com/test/guru99home/"
    
    'Navigate to url
    'arguments are specified in ParamArray list where first parameter value is associated
    'with arguments[0], second parameter value is associated with arguments[1], etc
    driver.ExecuteScript "window.location=arguments[0]", Url
    
    driver.Wait 1000
    driver.ActiveWindow.Maximize
    driver.Wait
    
    'ExecuteScript returns a WebElement object if script results in a WebElement object
    Set webElem = driver.ExecuteScript("return document.getElementById('philadelphia-field-submit')")
    
    'arguments are specified in ParamArray list where first parameter value is associated
    'with arguments[0], second parameter value is associated with arguments[1], etc
    driver.ExecuteScript "arguments[0].scrollIntoView(arguments[1]);", webElem, True
    
    driver.Wait 1000
    
    'ExecuteScript returns a single WebElements object if script results in a collection of WebElement objects
    Dim divElems As SeleniumVBA.WebElements
    Set divElems = driver.ExecuteScript("return document.getElementsByTagName(arguments[0])", "div")
    Debug.Assert divElems.Count = 289
    
    driver.CloseBrowser
    driver.Shutdown
End Sub

Sub test_executeScriptAsync()
    'see https://www.lambdatest.com/blog/how-to-use-javascriptexecutor-in-selenium-webdriver/
    Dim driver As SeleniumVBA.WebDriver
    Dim webElem As SeleniumVBA.WebElement
    Dim Url As String, waitTime As Integer
    
    Set driver = SeleniumVBA.New_WebDriver
    
    'driver.CommandWindowStyle = vbNormalFocus
    
    driver.StartEdge
    driver.OpenBrowser
    
    Url = "https://www.wikipedia.org/"

    waitTime = 3000
    
    If waitTime > 30000 Then driver.ScriptTimeout = 2 * waitTime '30000 is the default, so this isn't needed unless waitTime > 30 secs is needed
    
    driver.NavigateTo Url
        
    'Driver.ExecuteScriptAsync "window.setTimeout(arguments[arguments.length - 1], arguments[0]);", waitTime
    'Driver.ExecuteScriptAsync "window.setTimeout(arguments[1], arguments[0]);", waitTime 'this is equivalent
    
    'here the callback sends an alert "wait is over!" after the desired waitTime
    driver.ExecuteScriptAsync "var callback = arguments[arguments.length - 1]; setTimeout(function(){callback(alert('WAIT IS OVER!'))}, arguments[0]);", waitTime
    driver.Wait 2000
    
    driver.SwitchToAlert.Accept
    driver.Wait 1000
        
    driver.CloseBrowser
    driver.Shutdown
End Sub

Sub test_call_embedded_HTML_script()
    Dim driver As SeleniumVBA.WebDriver
    Dim html As String
    
    Set driver = SeleniumVBA.New_WebDriver
    
    'driver.DefaultIOFolder = ThisWorkbook.path '(this is the default)
    
    driver.StartChrome
    driver.OpenBrowser
    
    'create an html with a script that changes an element's text
    html = "<!DOCTYPE html>" & _
    "<html>" & _
    "<body>" & _
    "<p id='text'>Hello World!</p>" & _
    "<script>" & _
    "function doIt(){document.getElementById('text').innerHTML = 'New text from Script!';}" & _
    "</script>" & _
    "</body>" & _
    "</html>"

    driver.SaveStringToFile html, ".\snippet.html"

    driver.NavigateToFile ".\snippet.html"
    driver.Wait 2000
    
    'run the embedded script
    driver.ExecuteScript "doIt();"
    
    driver.Wait 1000
    
    driver.CloseBrowser
    driver.Shutdown
End Sub

