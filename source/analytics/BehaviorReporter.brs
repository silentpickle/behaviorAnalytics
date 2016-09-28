function _behaviorReporter_reportMessage(message as object, identifier as string) as boolean
    if(message.isScreenClosed() = true)
        m.plugin.windowClosed(identifier)
    endif

    'No line continuations....
    if( (message.isScreenClosed() = false) AND ( (type(message) = "roVideoScreenEvent") OR (type(message) = "roSpringboardScreenEvent") OR (type(message) = "roCodeRegistrationScreenEvent") OR (type(message) = "roGridScreenEvent") OR (type(message) = "roKeyboardScreenEvent") OR (type(message) = "roListScreenEvent") OR (type(message) = "roMessageDialogEvent") OR (type(message) = "roOneLineDialogEvent") OR (type(message) = "roParagraphScreenEvent") OR (type(message) = "roSearchScreenEvent") OR (type(message) = "roSlideShowEvent") OR (type(message) = "roSpringBoardScreenEvent") OR (type(message) = "roTextScreenEvent")) OR ( type(message) = "roVideoScreenEvent" ))
        m.plugin.windowActivity(identifier, message)
    endif

end function

function behaviorReporterInit(plugin as object, pluginInitializations) as object
    br = CreateObject("roAssociativeArray")
    br.plugin = plugin(pluginInitializations)
    br.reportMessage = _behaviorReporter_reportMessage
    br.reportStart = br.plugin.programStart
    br.reportEnd = br.plugin.programEnd
    br.reportBack = br.plugin.reportBack
    br.reportInfoButton = br.plugin.reportInfo
    
    return br
end function


