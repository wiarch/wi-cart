import cors from 'cors';
import express from 'express';
import fs from 'fs';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import { randomUUID, createHash } from 'crypto';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dataDir = path.join(__dirname, 'data');
const uploadDir = path.join(dataDir, 'uploads');
const storePath = path.join(dataDir, 'store.json');
fs.mkdirSync(uploadDir, { recursive: true });

const ENTITIES = [
  'categories',
  'units',
  'products',
  'shopping_lists',
  'list_items',
  'purchase_histories',
  'purchase_history_items',
];

function hashPassword(pw) {
  return createHash('sha256').update(`wicart:${pw}`).digest('hex');
}

function load() {
  if (!fs.existsSync(storePath)) {
    return { users: [], tokens: {}, entities: {} };
  }
  return JSON.parse(fs.readFileSync(storePath, 'utf8'));
}

function save(store) {
  fs.writeFileSync(storePath, JSON.stringify(store, null, 2));
}

let store = load();
for (const e of ENTITIES) {
  store.entities[e] ??= {};
}
if (!store.users.find((u) => u.email === 'demo@wicart.local')) {
  store.users.push({
    id: randomUUID(),
    name: 'Demo',
    email: 'demo@wicart.local',
    password_hash: hashPassword('password123'),
    created_at: new Date().toISOString(),
  });
  save(store);
  console.log('Seeded demo@wicart.local / password123');
}

const app = express();
app.use(cors());
app.use(express.json({ limit: '5mb' }));
app.use('/storage', express.static(uploadDir));
const upload = multer({ dest: uploadDir });

function auth(req, res, next) {
  const h = req.headers.authorization || '';
  const token = h.startsWith('Bearer ') ? h.slice(7) : null;
  const userId = token ? store.tokens[token] : null;
  const user = store.users.find((u) => u.id === userId);
  if (!user) return res.status(401).json({ message: 'Unauthenticated' });
  req.user = user;
  next();
}

function publicUser(u) {
  return { id: u.id, name: u.name, email: u.email };
}

app.get('/', (_req, res) => res.json({ app: 'wicart-dev-api', status: 'ok' }));

app.post('/api/register', (req, res) => {
  const { name, email, password } = req.body || {};
  if (!name || !email || !password || String(password).length < 8) {
    return res.status(422).json({ message: 'Invalid payload' });
  }
  if (store.users.find((u) => u.email === email)) {
    return res.status(422).json({ message: 'Email taken' });
  }
  const user = {
    id: randomUUID(),
    name,
    email,
    password_hash: hashPassword(password),
    created_at: new Date().toISOString(),
  };
  store.users.push(user);
  const token = randomUUID();
  store.tokens[token] = user.id;
  save(store);
  res.status(201).json({ user: publicUser(user), token });
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body || {};
  const u = store.users.find((x) => x.email === email);
  if (!u || u.password_hash !== hashPassword(password || '')) {
    return res.status(422).json({
      message: 'Credenciales inválidas.',
      errors: { email: ['Credenciales inválidas.'] },
    });
  }
  const token = randomUUID();
  store.tokens[token] = u.id;
  save(store);
  res.json({ user: publicUser(u), token });
});

app.post('/api/logout', auth, (req, res) => {
  const token = (req.headers.authorization || '').slice(7);
  delete store.tokens[token];
  save(store);
  res.json({ ok: true });
});

app.get('/api/me', auth, (req, res) => {
  res.json({ user: publicUser(req.user) });
});

app.post('/api/sync/push', auth, (req, res) => {
  const mutations = Array.isArray(req.body?.mutations) ? req.body.mutations : [];
  const deviceId = req.body?.device_id || null;
  const applied = [];
  const rejected = [];
  const now = new Date().toISOString();

  for (const m of mutations) {
    const { entity, id, op, client_updated_at: clientUpdatedAt } = m;
    if (!ENTITIES.includes(entity) || !id || !['upsert', 'delete'].includes(op) || !clientUpdatedAt) {
      rejected.push({ id, reason: 'invalid_mutation' });
      continue;
    }
    store.entities[entity] ??= {};
    const existing = store.entities[entity][id];
    if (
      existing &&
      existing.user_id === req.user.id &&
      new Date(existing.client_updated_at) > new Date(clientUpdatedAt)
    ) {
      rejected.push({ id, entity, reason: 'lww_keep_server', server: existing });
      continue;
    }

    let row;
    if (op === 'delete') {
      row = {
        ...(existing || { id, user_id: req.user.id, name: '' }),
        device_id: deviceId,
        client_updated_at: clientUpdatedAt,
        updated_at: now,
        deleted_at: now,
      };
    } else {
      row = {
        id,
        user_id: req.user.id,
        device_id: deviceId,
        ...(m.payload || {}),
        client_updated_at: clientUpdatedAt,
        updated_at: now,
        created_at: existing?.created_at || now,
        deleted_at: null,
      };
    }
    store.entities[entity][id] = row;
    applied.push({ id, entity, op, row });
  }
  save(store);
  res.json({ server_time: now, applied, rejected });
});

app.get('/api/sync/pull', auth, (req, res) => {
  const since = req.query.since ? String(req.query.since) : null;
  // Capture cursor before scanning so concurrent writes land in next pull.
  const serverTime = new Date().toISOString();
  const changes = {};
  for (const entity of ENTITIES) {
    const all = Object.values(store.entities[entity] || {}).filter(
      (r) => r.user_id === req.user.id,
    );
    changes[entity] = since
      ? all.filter((r) => new Date(r.updated_at) >= new Date(since))
      : all;
  }
  res.json({
    server_time: serverTime,
    since,
    changes,
  });
});

app.post('/api/uploads/product-image', auth, upload.single('image'), (req, res) => {
  const productId = req.body.product_id;
  const clientUpdatedAt = req.body.client_updated_at;
  if (!productId || !req.file) return res.status(422).json({ message: 'Invalid' });

  const existing = store.entities.products?.[productId];
  if (!existing || existing.user_id !== req.user.id) {
    return res.status(404).json({ message: 'Product not found' });
  }
  if (new Date(existing.client_updated_at) > new Date(clientUpdatedAt)) {
    return res.status(409).json({ message: 'lww_keep_server', product: existing });
  }

  const ext = path.extname(req.file.originalname || '') || '.jpg';
  const filename = `${productId}_${Date.now()}${ext}`;
  fs.renameSync(req.file.path, path.join(uploadDir, filename));

  const now = new Date().toISOString();
  existing.image_path = filename;
  existing.image_pending = false;
  existing.client_updated_at = clientUpdatedAt;
  existing.updated_at = now;
  save(store);

  res.json({
    product: existing,
    url: `http://127.0.0.1:${PORT}/storage/${filename}`,
  });
});

const PORT = Number(process.env.PORT || 8000);
app.listen(PORT, '0.0.0.0', () => {
  console.log(`wi-cart dev API on http://127.0.0.1:${PORT}`);
});
