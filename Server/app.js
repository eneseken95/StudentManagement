const express = require('express');
const bodyParser = require('body-parser');
const authController = require('./authController');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
    return res.json({
        error: false,
        message: 'Welcome to RESTful API with Node.js.'
    });
});

app.post('/login', authController.login);
app.get('/login/teachers', authController.getTeacherLessons);
app.get('/login/students', authController.getStudentLessons);
app.post('/login/students/elective/lessons', authController.updateElectiveLesson);

app.listen(port, () => {
    console.log("Listening on port %d", port);
});

module.exports = app;
