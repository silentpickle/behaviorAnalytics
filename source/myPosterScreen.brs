Function showPosterScreen()
     mp = mpart("that screen") 'in hindsight, there's really no reason this couldn't be declared globally...   
     port = CreateObject("roMessagePort")
     poster = CreateObject("roPosterScreen")
     poster.SetBreadcrumbText("[location1]", "[location2]")
     poster.SetMessagePort(port)
    'This would normally be set-up somewhere else... just sort of pressed for time.
     list = CreateObject("roArray", 10, true)
     For i = 0 To 10
         o = CreateObject("roAssociativeArray")
         o.ContentType = "episode"
         o.Title = "[Title]"
         o.ShortDescriptionLine1 = "[ShortDescriptionLine1]"
         o.ShortDescriptionLine2 = "[ShortDescriptionLine2]"
         o.Description = ""
         o.Description = "[Description] "
         o.Rating = "NR"
         o.StarRating = "75"
         o.ReleaseDate = "[<mm/dd/yyyy]"
         o.Length = 5400
         o.Categories = []
         o.Categories.Push("[Category1]")
         o.Categories.Push("[Category2]")
         o.Categories.Push("[Category3]")
         o.Actors = []
         o.Actors.Push("[Actor1]")
         o.Actors.Push("[Actor2]")
         o.Actors.Push("[Actor3]")
         o.Director = "[Director]"
         
         list.Push(o)
     End For
     poster.SetContentList(list)
     poster.Show() 
 
 
     While True
         msg = wait(0, port)
         mp.peekMsg(msg)
         If msg.isScreenClosed() Then
             return -1
         Else If msg.isListItemSelected()
             mySpringboard(o[msg.getIndex()])
         End If
     End While
 End Function