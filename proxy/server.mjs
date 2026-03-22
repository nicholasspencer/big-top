#!/usr/bin/env node
/**
 * Minimal CORS proxy for GitHub OAuth device flow.
 * Proxies two endpoints that GitHub doesn't set CORS headers on.
 *
 * Usage: node proxy/server.mjs [--port 8787]
 */

import { createServer } from 'node:http';

const PORT = parseInt(process.argv.find((_, i, a) => a[i - 1] === '--port') ?? '8787', 10);

const ALLOWED_ORIGINS = new Set([
  'http://localhost:8080',
  'http://localhost:3000',
  'https://nicholasspencer.github.io',
  'https://auth.nefarious.actor',
]);

const ROUTES = {
  '/github/device/code': 'https://github.com/login/device/code',
  '/github/oauth/token': 'https://github.com/login/oauth/access_token',
};

function corsHeaders(origin) {
  const allowed = ALLOWED_ORIGINS.has(origin) ? origin : '';
  return {
    'Access-Control-Allow-Origin': allowed,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Accept',
  };
}

const server = createServer(async (req, res) => {
  const origin = req.headers.origin ?? '';
  const cors = corsHeaders(origin);

  // Preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(204, cors);
    return res.end();
  }

  // Health check
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain', ...cors });
    return res.end('ok');
  }

  const target = ROUTES[req.url];
  if (!target || req.method !== 'POST') {
    res.writeHead(404, cors);
    return res.end('Not found');
  }

  // Read body
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  const body = Buffer.concat(chunks);

  try {
    const upstream = await fetch(target, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': req.headers['content-type'] ?? 'application/x-www-form-urlencoded',
      },
      body,
    });

    const responseBody = await upstream.text();
    res.writeHead(upstream.status, {
      'Content-Type': upstream.headers.get('content-type') ?? 'application/json',
      ...cors,
    });
    res.end(responseBody);
  } catch (err) {
    res.writeHead(502, cors);
    res.end(JSON.stringify({ error: err.message }));
  }
});

server.listen(PORT, () => {
  console.log(`GitHub OAuth proxy listening on :${PORT}`);
  console.log(`Routes: ${Object.keys(ROUTES).join(', ')}`);
});
