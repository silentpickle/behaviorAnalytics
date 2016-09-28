'Google analytics plugin version 0.0.1.  Apologies, it's a little rough right now.

function _googleAnalytics_windowActivity(identifier as string, messageFired as object) as void
    m._trackEvent("Generic Event", "", "", "Window keepalive")
end function

function _googleAnalytics_windowClosed(identifier as string, messageFired as object) as void
    m._trackEvent("Generic Event", "", "", "Window closed")
end function

function _googleAnalytics_windowOpen(identifier as string) as void
    m._trackPageview(identifier)
end function 

function _googleAnalytics_programOpen() as void
    m._trackEvent("Generic Event", "", "", "Window closed")
end function

function _googleAnalytics_programClosed() as void
    print "program closed "
end function

function _googleAnalytics_navigateBack() as void
    print "navigate back"
end function

function _googleAnalytics_navigateHome() as void
    print "navigate home"
end function

'Kind of an architectural choice here, we put the member
'information in 'this' as a sub.  
'ASLO, This borrows very heavily from 
'https://github.com/thyngster/roku-universal-analytics/blob/master/src/analytics.brs
function googleAnalyticsPlugin(moreInformation as object) as object
    plugin = CreateObject("roAssociativeArray")
    di = CreateObject("roDeviceInfo") 
    plugin.UATracker = CreateObject("roAssociativeArray")
    plugin.UATracker.debugMode = false
    plugin.UATracker.userID = di.GetDeviceUniqueId()
    plugin.UATracker.AccountID = moreInformation.AccountID

    plugin.UATracker.model = di.GetModel()
    plugin.UATracker.version = di.GetVersion()
    
    'TODO: fix this up.
    dimensions = di.GetDisplaySize()
    'm.UATracker.display = ToIntdimensions.w + "x" + dimensions.h
    plugin.uatracker.display = "1280x720" 
    'end TODO

    plugin.UATracker.appName = moreInformation.appName
    plugin.UATracker.appVersion = moreInformation.appVersion

    plugin.UATracker.ratio = di.GetDisplayAspectRatio()
    plugin.UATracker.endpoint = "http://www.google-analytics.com/collect?"

    plugin.moreInformation = moreInformation
    
    'in assigning these functions to the object, 'm' becomes the object
    plugin._makeRequest = _googleAnalytics_makeRequest
    plugin._trackEvent = _googleAnalytics_trackEvent
    plugin._trackPageview = _googleAnalytics_trackPageview

    'public functions
    plugin.windowActivity = _googleAnalytics_windowActivity
    plugin.windowClosed = _googleAnalytics_windowClosed
    plugin.programStart = _googleAnalytics_programOpen
    plugin.programEnd = _googleAnalytics_programClosed
    plugin.windowOpen = _googleAnalytics_windowOpen
    
    return plugin
end function

Function _googleAnalytics_trackPageview(Pageview as String) as Void

    payload = "z="+GetRandomInt(10)
    payload = payload + "&v=1"
    payload = payload + "&cid=" + m.UATracker.userID
    payload = payload + "&tid=" + m.UATracker.AccountID   
    payload = payload + "&dimension1=" + m.UATracker.model
    payload = payload + "&dimension2=" + m.UATracker.version
    payload = payload + "&sr=" + m.UATracker.display     
    payload = payload + "&sd=" + m.UATracker.ratio
    payload = payload + "&an=" + m.UATracker.appName
    payload = payload + "&av=" + m.UATracker.appVersion    
    payload = payload + "&t=pageview" 

    If Len(Pageview) > 0
    payload = payload + "&dp=" + Pageview
    end if

    _googleAnalytics_makeRequest(payload)
End Function

Function _googleAnalytics_makeRequest(payload as String) as Void
    port = CreateObject("roMessagePort")
    xfer = CreateObject("roURLTransfer")
    'xfer.SetURL(m.UATracker.endpoint+"?"+payload)
    xfer.SetURL(m.UATracker.endpoint)
    xfer.SetMessagePort(port)

    outstanding = xfer.AsyncPostFromString(payload)
    
    'This is critical, because if the scope drops, your
    'request drops, too.
    'So we have to have something that at least
    'persists long enough until the next request.

    m.UATracker.pendingRequest = xfer
    
    'This should probably go to a land far, far away.
    if( (outstanding) AND (m.UATracker.debugMode = true) )
            print "Making data request analytics " + payload
    
            msg = wait(50000, port)

            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                
                if (code = 200)
                    print "Got string! " +  msg.GetString()
                else
                    print "Code is " + stri(code) + " with string " + msg.GetString()
                endif
            else if (type(msg) = invalid)
                print "Something very bad happened with the request"
                xfer.AsyncCancel()
            endif
    endif
    response = xfer.GetToString()    
End Function

Function _googleAnalytics_trackEvent(EventCat as String , EventAct as String , EventLab as String , EventVal as String) as Void

    payload = "z="+Stri(Rnd(4200000000))
    payload = payload + "&v=1"
    payload = payload + "&cid=" + m.UATracker.userID
    payload = payload + "&tid=" + m.UATracker.AccountID   
    payload = payload + "&sr=" + m.UATracker.display     
    payload = payload + "&sd=" + m.UATracker.ratio
    payload = payload + "&an=" + m.UATracker.appName
    payload = payload + "&av=" + m.UATracker.appVersion    

    payload = payload + "&t=event" 
    If Len(EventCat) > 0
    payload = payload + "&ec=" + EventCat
    end if
    If Len(EventAct) > 0
    payload = payload + "&ea=" + EventAct
    end if
    If Len(EventLab) > 0
    payload = payload + "&el=" + EventLab
    end if
    If Len(EventVal) > 0
    payload = payload + "&ev=" + EventVal
    end if

    _googleAnalytics_makeRequest(payload)
End Function

Function _googleAnalytics_trackPageview(Pageview as String) as Void

    payload = "z="+Stri(Rnd(4200000000))
    payload = payload + "&v=1"
    payload = payload + "&cid=" + m.UATracker.userID
    payload = payload + "&tid=" + m.UATracker.AccountID   
    payload = payload + "&sr=" + m.UATracker.display     
    payload = payload + "&sd=" + m.UATracker.ratio
    payload = payload + "&an=" + m.UATracker.appName
    payload = payload + "&av=" + m.UATracker.appVersion    
    payload = payload + "&t=pageview" 

    If Len(Pageview) > 0
    payload = payload + "&dp=" + Pageview
    end if

    _googleAnalytics_makeRequest(payload)
End Function


