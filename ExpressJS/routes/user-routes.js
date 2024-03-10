const express = require('express');
const { check } = require('express-validator');

const router = express.Router();

const { login, signup } = require('../controllers/user-controllers');

router.post(
    '/login',
    [
        check('username').notEmpty(),
        check('password').notEmpty()
    ],
    login
);

router.post(
    '/signup',
    [
        check('username').isLength({ min: 3, max: 30 }),
        check('email').isEmail(),
        check('password').notEmpty()
    ],
    signup
);

module.exports = router;
