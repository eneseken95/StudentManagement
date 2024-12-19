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

const updateLesson = (userName, lesson, isMandatory, callback) => {
    const query = `
        UPDATE Students 
        SET isMandatory = ? 
        WHERE userName = ? AND lesson = ?
    `;

    conn.query(query, [isMandatory, userName, lesson], (error, results) => {
        callback(error, results);
    });
};

module.exports = {
    authenticateUser,
    getLessonsForRole,
    updateLesson
};
