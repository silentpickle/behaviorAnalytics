'If this is your first time into brightscript, functions need to be declared
'in a global scope, and then inserted within an associative array as 
'function pointers to establish 'ownership'

function _printBehavior_windowActivity(identifier as string, messageFired as object) as void
    print "window activity" + identifier
end function

function _printBehavior_windowClosed(identifier as string, messageFired as object) as void
    print "screen closed " + identifier
end function

function _printBehavior_windowOpen(identifier as string) as void
    print "window opened " + identifer
end function 

function _printBehavior_programOpen() as void
    print "program opened "
end function

function _printBehavior_programClosed() as void
    print "program closed "
end function

function printBehaviorPlugin(moreInformation as object) as object
    plugin = CreateObject("roAssociativeArray")
    plugin.moreInformation = moreInformation

    'These functions are public-facing, so we need to have
    'methods associated with them.
    plugin.windowActivity = _printBehavior_windowActivity
    plugin.windowClosed = _printBehavior_windowClosed
    plugin.programStart = _printBehavior_programOpen
    plugin.programEnd = _printBehavior_programClosed
    plugin.windowOpen = _printBehavior_windowOpen
    
    return plugin
end function