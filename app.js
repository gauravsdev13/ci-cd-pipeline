const express = require('express')
const client = require('prom-client')
const app = express()
const PORT = process.env.PORT_NODE_APP || 8000

const { createLogger, transports } = require("winston");
const LokiTransport = require("winston-loki");
const options = {
  transports: [
    new LokiTransport({
      host: "http://127.0.0.1:3100",
      labels: { app: "node-app" },
    })
  ]
};
const logger = createLogger(options);

client.collectDefaultMetrics({register: client.register})

app.get('/',  (req, res) =>{
  logger.info('Request on /root')
  res.send('Hello World!')})

app.get('/data', async (req, res) => {
    const delay = Math.floor(Math.random() * 1000);

    await new Promise(resolve => setTimeout(resolve, delay));
  
    const chance = Math.random();
  
    if (chance < 0.1) {
      logger.error('Internal Server Error')
      return res.status(500).json({ error: 'Internal Server Error' });
    } else if (chance < 0.2) {
      logger.error('Bad Request')
      return res.status(400).json({ error: 'Bad Request' });
    }
    logger.info('Request on /data')
    res.json({
      message: 'Fetched user data successfully!',
      timestamp: new Date(),
      responseTime: `${delay}ms`
    });
  });

app.get('/metrics', async (req, res)=> {
  res.setHeader('Content-Type', client.register.contentType)
  const metrics = await client.register.metrics()
  res.send(metrics)
})

app.listen(PORT,  ()=> console.log(`App listening on port ${PORT}`))


