const date = new Date()
const options = {weekday: "long", year: "numeric", month: "long", day: "2-digit"};

const heure = date.getHours()
const min = date.getMinutes()
const sec = date.getSeconds()

const horloge = heure+min+sec 
const dateDuJour = date.toLocaleDateString("fr-FR", options)

const format = (nb) => {
    if (nb < 10) return `0${nb}`
    else return nb
}

// listeFR = { jours : [ "Dimanche","Lundi","Mardi","Mercredi ","Jeudi","Vendredi","Samedi"],
//             mois : [ "Decembre","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Janvier"]},

