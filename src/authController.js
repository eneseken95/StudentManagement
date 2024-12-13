const userService = require('./userService');

const login = (req, res) => {
    const { userName, password } = req.body;

    if (!userName || !password) {
        return res.status(400).send({
            error: true,
            message: "Please provide both userName and password"
        });
    }

    userService.authenticateUser(userName, password, (error, results) => {
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

        const user = results[0];
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
};

const getLessons = (req, res, role) => {
    const { userName } = req.query;

    if (!userName) {
        return res.status(400).send({
            error: true,
            message: "userName is required"
        });
    }

    const table = role === 'teacher' ? 'Teachers' : 'Students';

    userService.getLessonsForRole(userName, table, (error, results) => {
        if (error) {
            return res.status(500).send({
                error: true,
                message: "Error fetching lessons"
            });
        }

        if (results.length === 0) {
            return res.status(404).send({
                error: true,
                message: "No lessons found"
            });
        }

        const lessons = results.map(row => ({
            lesson: row.lesson,
            isMandatory: row.isMandatory
        }));

        return res.json({
            error: false,
            message: "Lessons fetched successfully",
            data: lessons
        });
    });
};

const getTeacherLessons = (req, res) => {
    getLessons(req, res, 'teacher');
};

const getStudentLessons = (req, res) => {
    getLessons(req, res, 'student');
};

module.exports = {
    login,
    getTeacherLessons,
    getStudentLessons
};
