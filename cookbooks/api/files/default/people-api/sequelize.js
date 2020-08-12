const Sequelize = require('sequelize');
const personModel = require('./personModel');
const config = require('./db-conn.json');

const DB_HOST = config.db.host;
const DB_PORT = config.db.port;
const DB_USER = config.db.user;
const DB_PWD = config.db.pwd;
const DB_NAME = config.db.name;
const SCHEMA_NAME = config.db.schema;
const DB_DIALECT = config.db.dialect;
const DB_POOL_MIN = Number(config.db.pool.min);
const DB_POOL_MAX = Number(config.db.pool.max);

var options = {
    host: DB_HOST,
    dialect: DB_DIALECT,
    logging: () => {},
    pool: {
        max: DB_POOL_MAX,
        min: DB_POOL_MIN,
        acquire: 30000,
        idle: 10000
    },
    databaseVersion: '9.6.9'
}

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PWD, options);

sequelize.createSchema(SCHEMA_NAME)
.then(() => {
    console.log(`Schema created.`);

    personModel(SCHEMA_NAME, sequelize, Sequelize).sync({force: false})
    .then(() => {
        console.log(`Person model synchronized.`);
    })
    .catch((e) => {
        console.log(`Person model couldn't be synchronized: ${e.stack}`);
    });
}).catch(e => {
    console.log(`Schema couldn't be created: ${e.stack}`);
});

const person = personModel(SCHEMA_NAME, sequelize, Sequelize);

module.exports = person;