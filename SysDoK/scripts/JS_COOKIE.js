// CONFECTION DU COOKIE

const = setCookie = (name,value,days) => {
    const expire=new Date()
    expire.setDate(expire.getDate()+days)
    document.cookie=name+'='+escape(value)+'expires='+expire.toGMTString()
    return true
}

// DEGUSTAGE DU COOKIE

const getCookie = (name) => {
    if(document.cookie.length>0)
    {
        let start=document.cookie.indexOf(name+"=")
        let pos = start + name.length + 1
        if (start!=0)
        {
            start=document.cookie.indexOf(" "+name+"=")
            pos = start+name.length+3
        }
        if (start!=-1)
        { 
            start=pos
            end=document.cookie.indexOf("",start)
            if(end==-1)
            {
                end=document.cookie.length
            }
            return unescape(document.cookie.substring(start,end))
        } 
    }
    return ''
}

// COOKIE PERIME
// ReCuisine le cookie avec une date d'expiration a -1