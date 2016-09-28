Function mySpringBoard()
    port = CreateObject("roMessagePort")
    springBoard = CreateObject("roSpringboardScreen")
    springBoard.SetBreadcrumbText("[location 1]", "[location2]")
    springBoard.SetMessagePort(port)
    o = CreateObject("roAssociativeArray")
    o.ContentType = "episode"
    o.Title = "[Title]"
    o.ShortDescriptionLine1 = "[ShortDescriptionLine1]"
    o.ShortDescriptionLine2 = "[ShortDescriptionLine2]"
    o.Description = ""
    For i = 1 To 15
        o.Description = o.Description + "[Description] "
    End For
    o.SDPosterUrl = ""
    o.HDPosterUrl = ""
    o.Rating = "NR"
    o.StarRating = "75"
    o.ReleaseDate = "[mm/dd/yyyy]"
    o.Length = 5400
    o.Categories = CreateObject("roArray", 10, true)
    o.Categories.Push("[Category1]")
    o.Categories.Push("[Category2]")
    o.Categories.Push("[Category3]")
    o.Actors = CreateObject("roArray", 10, true)
    o.Actors.Push("[Actor1]")
    o.Actors.Push("[Actor2]")
    o.Actors.Push("[Actor3]")
    o.Director = "[Director]"
    springBoard.SetContent(o)
    springBoard.Show()
    mp = mpart("this screen")
    While True
        msg = wait(0, port)
        mp.peekMsg(msg) 'could put the screen here, I guess?
        
        If msg.isScreenClosed() Then
            Return -1
        Else if msg.isButtonPressed()
            print "msg: "; msg.GetMessage(); "idx: "; msg.GetIndex()
        Endif
    End While
End Function