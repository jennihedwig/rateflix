const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const router = express.Router();


module.exports = (database) => {

    router.post('/sign-up', (req, res, next) => {
        const data = req.body;
        console.log('Request body:', data);

        bcrypt.hash(data.password, 10).then(hash => {
            const username = data.username;
            const email = data.email;
            const dateOfBirth = data.dateOfBirth;
            const password = hash;

            const sql = `INSERT INTO users (username, email, dateOfBirth, password) VALUES ('${username}', '${email}', '${dateOfBirth}', '${password}')`;

            database.query(sql, (error, result) => {
                if (error) {
                    console.error('SQL Error:', error);
                    return res.status(500).json({ message: 'Database error', error });
                }
                console.log('User successfully inserted:', result);
                res.status(201).json({ message: 'User added successfully', userID: result.insertId });
            });
        }).catch(err => {
            console.error('Hashing error:', err);
            res.status(500).json({ message: 'Error hashing password' });
        });
    });



    router.post('/login', (req, res, next) => {
        const inputs = req.body;
        const email = inputs.email;
        const password = inputs.password;

        console.log('LOGIN : ', inputs)

        const sql = 'SELECT * FROM users WHERE email = ?';
        const values = [email];

        database.query(sql, values, function (error, result) {
            if (error) {
                return res.status(500).json({ message: 'Database error', error: error });
            }
            console.log('result: ', result)

            if (result.length > 0) {
                // User found
                const user = result[0];
                console.log('user: ', user)

                // Compare password
                bcrypt.compare(password, user.password, function (error, passwordMatch) {
                    if (error) {
                        return res.status(500).json({ message: 'Error decypting', error: error });
                    }

                    if (passwordMatch) {

                        const userID = user.id
                        //Create JWT 
                        const token = jwt.sign({ email: user.email, userID: userID }, 'secret_for_development', { expiresIn: '1h' });
                        console.log('tokenas :', token)


                        // Passwords match
                        res.status(200).json({
                            message: 'User authenticated',
                            token: token,
                        });

                    } else {
                        // Passwords don't match
                        return res.status(500).json({ message: 'Auth failed:', error: error });
                    }
                });
            } else {

                return res.status(500).json({ message: 'Database error', error: error });

            }
        });

    });

    router.get('/get-user', (req, res, next) => {
        const userID = req.query.userID;
        console.log('userID @get-user: ', userID);

        // Bei live passowrt nicht übergeben
        database.query('SELECT * FROM users WHERE id = ?', [userID], function (error, response, fields) {
            if (error) {
                return res.status(500).json({ message: 'Database error', error: error });
            }

            const result = response;
            console.log('result: ', result);

            res.status(200).json({
                message: 'Got user with ID :' + userID,
                result: result
            });
        });
    });


    return router;
};