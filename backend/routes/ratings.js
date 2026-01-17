const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const router = express.Router();


module.exports = (database) => {

    router.post('/save-rating', (req, res, next) => {
        const data = req.body;
        console.log('Request body:', data);
        let mediaID = data.mediaID;
        let userID = data.userID;
        let name = "not needed?";
        let rating = data.rating;
        let comment = "kommt noch";
        let type = data.type;
        let category = data.category;
        let ranking = "not needed?";



        const sql = `INSERT INTO ratings (mediaID, userID, name, rating, comment, type, category, ranking) VALUES ('${mediaID}', '${userID}', '${name}', '${rating}', '${comment}', '${type}', '${category}', '${ranking}')`;

        database.query(sql, (error, result) => {
            if (error) {
                console.error('SQL Error:', error);
                return res.status(500).json({ message: 'Database error', error });
            }
            console.log('Rating successfully inserted:', result);
            res.status(201).json({ message: 'Rating added successfully', userID: result.insertId });
        });

    });

    router.get('/get-ratings', (req, res) => {
        const userID = req.query.userID;

        console.log('get-ratings for userID:', userID);

        if (!userID) {
            return res.status(400).json({
                message: 'userID is required'
            });
        }

        const sql = `SELECT * FROM ratings WHERE userID = ? `;

        database.query(sql, [userID], (error, results) => {
            if (error) {
                console.error('SQL Error:', error);
                return res.status(500).json({
                    message: 'Database error',
                    error
                });
            }

            console.log(`Found ${results.length} ratings`);

            res.status(200).json({
                message: 'Ratings loaded successfully',
                ratings: results
            });
        });
    });





    return router;
};