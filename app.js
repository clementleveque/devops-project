const express = require('express');

const app = express();
const PORT = 3000;

app.get('/health', (req, res) => {
    res.send('OK');
});

app.get('/version', (req, res) => {
    res.send('DevOps Lab 2 - Version 2');
});

if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`Server running on port ${PORT}`);
    });
}

module.exports = app;