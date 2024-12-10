let express = require('express');
let app = express();
let bodyParser = require('body-parser');
let mysql = require('mysql');

const port = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

let conn = mysql.createConnection({
    host : 'localhost',
    user: 'root',
    password: '',
    database: 'StudentManagementDB'
})

conn.connect();

app.get('/', (req, res) => {
    return res.json({
        error: false,
        message: 'Welcome to RESTfull api with node js.'
    });
})


app.post('/login', (req, res) => {
    let { userName, password } = req.body;


    if (!userName || !password) {
        return res.status(400).send({
            error: true,
            message: "Please provide both userName and password"
        });
    }

   
    conn.query('SELECT * FROM Users WHERE userName = ? AND password = ?', [userName, password], (error, results) => {
        if (error) {
            return res.status(500).send({
                error: true,
                message: "Database error"
            });
        }

        if (results.length === 0) {
            return res.status(401).send({
                error: true,
                message: "Invalid credentials"
            });
        }

        
        let user = results[0];
        let role = user.role;

        
        return res.json({
            error: false,
            message: "Login successful",
            data: {
                id: user.id,
                userName: user.userName,
                password: user.password,
                role: user.role
            }
        });

    });
});


app.listen(port, () => {
    console.log("Listening on port %d", port);
})

module.exports = app;
