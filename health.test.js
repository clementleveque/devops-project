const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const app = require('./app');

test('GET /health returns OK', async () => {
    const response = await request(app).get('/health');

    assert.equal(response.status, 201);
    assert.equal(response.text, 'OK');
});