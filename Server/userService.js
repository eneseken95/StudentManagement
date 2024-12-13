const conn = require('./db');

const authenticateUser = (userName, password, callback) => {
    const query = 'SELECT * FROM Users WHERE userName = ? AND password = ?';
    conn.query(query, [userName, password], (error, results) => {
        callback(error, results);
    });
};

const getLessonsForRole = (userName, table, callback) => {
    const query = `SELECT lesson, isMandatory FROM ${table} WHERE userName = ?`;
    conn.query(query, [userName], (error, results) => {
        callback(error, results);
    });
};

module.exports = {
    authenticateUser,
    getLessonsForRole
};
