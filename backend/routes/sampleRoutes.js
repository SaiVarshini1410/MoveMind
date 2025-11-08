import express from 'express';

import { getMessage } from '../controllers/sampleController.js';

const router = express.Router();

router.get('/', getMessage);

export default router;