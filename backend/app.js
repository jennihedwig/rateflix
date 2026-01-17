const express = require('express');
const cors = require('cors');
const app = express();
const bodyParser = require('body-parser');
const db_config = require('./config.json')
var mysql = require('mysql2');
const util = require('util');

//Headers
app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept, Authorization"
    );
    res.setHeader(
        "Access-Control-Allow-Methods",
        "GET, POST, PATCH, DELETE, OPTIONS"
    );
    next();
});
app.use(cors());
app.use(express.json());


//DB Connection 
var database = mysql.createConnection({
    host: db_config.host,
    user: db_config.user,
    password: db_config.password,
    port: db_config.port
})

//Initializin Async Functions for Routes 
database.beginTransactionAsync = util.promisify(database.beginTransaction);
database.queryAsync = util.promisify(database.query);
database.commitAsync = util.promisify(database.commit);
database.rollbackAsync = util.promisify(database.rollback);

database.connect(function (error) {
    if (error) {
        console.error('Database connection failed ', error);
        return;
    }
    console.log('Connected to Database')
})

database.query('USE rateflix;')

//Routes
const users = require('./routes/users')(database);
const tmdb = require('./routes/tmdb')(database);
const ratings = require('./routes/ratings')(database);

app.use('/api/user', users);
app.use('/api/media', tmdb);
app.use('/api/ratings', ratings);



module.exports = app;