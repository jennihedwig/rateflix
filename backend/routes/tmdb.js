const express = require('express');
const router = express.Router();
const axios = require('axios');
const dotenv = require('dotenv');

dotenv.config();


const TMDB_BASE_URL = "https://api.themoviedb.org/3";
const TMDB_API_KEY = 'ddf03471716af8b132877ce562b4ac17';

module.exports = (database) => {

    // Beispiel: Suche nach Filmen
    router.get("/search/:query", async (req, res) => {
        try {
            const { query } = req.params;
            console.log("query: ", query);
            const response = await axios.get(`${TMDB_BASE_URL}/search/multi`, {
                params: {
                    api_key: TMDB_API_KEY,
                    query: query,
                    language: "de-DE", // optional, Deutsch
                },
            });

            res.json(response.data);
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: "Fehler bei der TMDb-Abfrage" });
        }
    });

    // Beispiel: Details zu einem Film
    router.get("/movie/:id", async (req, res) => {
        try {
            const { id } = req.params;
            const response = await axios.get(`${TMDB_BASE_URL}/movie/${id}`, {
                params: {
                    api_key: process.env.TMDB_API_KEY,
                    language: "de-DE",
                },
            });

            res.json(response.data);
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: "Fehler beim Laden der Filmdetails" });
        }
    });


    return router;
};
