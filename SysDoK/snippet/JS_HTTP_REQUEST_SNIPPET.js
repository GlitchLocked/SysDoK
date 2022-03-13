// POST JSON 

const fetchMe = (jsObject) => {
	const URL = 'http://API'
    const params = (requestType, jsObject) => {
        let data
        if (!!jsObject) {
          data = new FormData()
          data.append( "json", JSON.stringify(jsObject))   
        }

        const setting = { method: requestType,
                        headers: { "Content-type": "application/json" ,
                                    'Accept': "application/json",
                                    "Access-Control-Request-Method" : requestType,
                                    "Access-Control-Request-Headers" : "Authorization, X-Requested-With, Content-Type, Accept" },
                        body: data,
                        // mode: 'cors',
                        cache: 'default' }

        return setting
    }

    return fetch(URL, params('POST', jsObject))
        .then(res => res.json())
        .then( res => return res)
}

// POST XML

const getXDomainRequest = () => {
    let xdr = null

    if (window.XDomainRequest) {
      xdr = new XDomainRequest() 
    } else if (window.XMLHttpRequest) {
      xdr = new XMLHttpRequest() 
    } else {
      alert("Votre navigateur web ne permet pas d'effectuer la communication avec Mercure, merci de le mettre à jour ou d'utiliser un navigateur alternatif")
    }
    
    return xdr        
}

const postToMercure = (clientObject) => {

    const url = "http://LurlSurLaquelOnRequete.com/route"

    function promesse (Data) {
      return new Promise(resolve => {
        let xdr = getXDomainRequest()
        xdr.contentType = "application/xml"

        xdr.open("POST", url )

        xdr.onreadystatechange = (event) => {  
          if (xdr.readyState === 4) {  
              if (xdr.status != 200) {  
                alert('Une erreur est survenue')  
              }  
          }  
        }

        // ENVOIE XML INFORMATION
        xdr.send(Data)

        // GESTION RETOUR XML PARSING
        xdr.onload = () => {
          const reponseXML = xdr.responseText

          if (window.DOMParser)
          {
              parser = new DOMParser()
              xmlDoc = parser.parseFromString(reponseXML, "text/xml")
          }
          else // Internet Explorer
          {
              xmlDoc = new ActiveXObject("Microsoft.XMLDOM")
              xmlDoc.async = false
              xmlDoc.loadXML(reponseXML)
          }

          const reponseParsed = xmlDoc.getElementsByTagName("return")[0].childNodes[0].nodeValue
          console.log('%c reponseParsed :','background:orange;color:white;', reponseParsed)

          resolve(reponseParsed) 
        }
      })
    }

    return promesse(clientObject)
}

