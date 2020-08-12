const http = require('http');
const app = require('./app');

const port = 3010;

app.set(port);

const server = http.createServer(app);
server.listen(port);

console.log(`Application started at port ${port}`);