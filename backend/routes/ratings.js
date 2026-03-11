const express = require('express');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const router = express.Router();


module.exports = (database) => {

    router.post('/save-rating', (req, res, next) => {
        const data = req.body;
        console.log('Request body:', data);

        const mediaID = data.mediaID;
        const userID = data.userID;
        const name = data.name;
        const rating = data.rating;
        const comment = "kommt noch";
        const type = data.type;
        const category = data.category;
        const ranking = data.ranking; // Muss vom Frontend kommen
        const imagePath = data.imagePath;

        if (!ranking || !category || !userID) {
            return res.status(400).json({ message: "Ranking, Kategorie oder User fehlt" });
        }

        // 1️⃣ Alle Rankings ab dem gewünschten Platz um 1 nach hinten verschieben
        const updateSql = `
            UPDATE ratings
            SET ranking = ranking + 1
            WHERE userID = ? AND category = ? AND ranking >= ?
        `;
        database.query(updateSql, [userID, category, ranking], (updateErr, updateResult) => {
            if (updateErr) {
                console.error('SQL Error beim Verschieben der Rankings:', updateErr);
                return res.status(500).json({ message: 'Database error', error: updateErr });
            }

            // 2️⃣ Neues Rating einfügen
            const insertSql = `
                INSERT INTO ratings (mediaID, userID, name, rating, comment, type, category, ranking, imagePath)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;
            const values = [mediaID, userID, name, rating, comment, type, category, ranking, imagePath];

            database.query(insertSql, values, (insertErr, insertResult) => {
                if (insertErr) {
                    console.error('SQL Error beim Einfügen des Ratings:', insertErr);
                    return res.status(500).json({ message: 'Database error', error: insertErr });
                }

                console.log('Rating successfully inserted:', insertResult);
                res.status(201).json({ message: 'Rating added successfully', ratingID: insertResult.insertId });
            });
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

        const sql = `SELECT * FROM ratings WHERE userID = ? ORDER BY ranking ASC`;

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