import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import chatRouter from './routes/chat.js';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => res.json({ status: 'ok' }));
app.use('/api/chat', chatRouter);

const port = Number(process.env.PORT ?? 3001);
app.listen(port, () => console.log(`Server listening on http://localhost:${port}`));
