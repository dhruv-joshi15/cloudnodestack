const request = require('supertest');
const express = require('express');
const routes = require('../routes');

const app = express();
app.use('/', routes);

describe('GET /health', () => {
  it('should return status OK', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toEqual(200);
    expect(res.body.status).toBe('OK');
  });
});
