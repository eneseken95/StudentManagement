const mysql = require('mysql');

const conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'StudentManagementDB'
});

conn.connect((err) => {
    if (err) {
        console.error("Error connecting to database:", err.stack);
        return;
    }
    console.log("Connected to database");
});

module.exports = conn;
