const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const app = express()

// Middleware
app.use(bodyParser.urlencoded({ extended: true })) 
app.use(cors())


app.get('/', (req, res) => {

      console.log("Ping")
      res.send('Pong' )
      
})

app.post('/post', (req, res) => {

  const DATA = req.body.data
  res.send(`${DATA} DAFTPUNK HUGO BANKSY`)
  console.log('Data recus :', DATA)
          
})


app.get('/dataurl/:data', (req, res) => {

  const DATA = req.params.data
  res.send(`Sp4Wn JOK3R Ven0m`)
  console.log('Data recus :', DATA)

})

app.listen(8080, () => console.log('serveur sur le port 8080'))