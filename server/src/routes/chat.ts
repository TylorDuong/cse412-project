import { Router } from 'express';

const router = Router();

// TODO: POST /api/chat - accept user message, run the LLM agent, return the response.
router.post('/', (_req, res) => {
  res.status(501).json({ error: 'Not implemented' });
});

export default router;
