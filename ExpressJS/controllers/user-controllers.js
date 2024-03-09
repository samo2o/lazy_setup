require('dotenv').config();
const jwt = require("jsonwebtoken");
const mongoose = require('mongoose');

const HttpError = require("../models/http-error");
const User = require("../models/user-schema");

const login = async (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return next(
            HttpError(
                'Invalid inputs. Please check your inputs and try again.',
                422
            )
        );
    }

    const { username, password } = req.body;

    let userExists;
    try {
        userExists = await User.find({ username: username });
    } catch (error) {
        return next(
            error || 'Something went wrong while checking for username.'
        )
    }

    if (!usernameExists) {
        return next(
            HttpError(
                'No username was found.',
                404
            )
        )
    }

    let passwordValid;
    try {
        passwordValid = await bcrypt.compare(password, userExists.password);
    } catch (error) {
        return next(
            error || 'Something went wrong while checking the password. Please try again later.'
        )
    }

    if (!passwordValid) {
        return next(
            HttpError(
                'Incorrect password.',
                401
            )
        );
    }

    let token;
    try {
        token = jwt.sign({ userId: userExists.id, email: userExists.email }, process.env.SECRET_KEY, { expiresIn: '1h' });
    } catch (error) {
        return next(
            error || 'Something went wrong while signing for a new user token.'
        );
    }

    res.json({
        token: token
    })
}

const signup = async (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return next(
            HttpError(
                'Invalid inputs. Please check your inputs and try again.',
                422
            )
        );
    }

    const { username, email, password } = req.body;

    let emailExists;
    let usernameExists;
    try {
        emailExists = await User.find({ email: email });
        usernameExists = await User.find({ username: username });
    } catch (error) {
        return next(
            error || 'Something went wrong while checking for email and username.'
        )
    }

    if (emailExists) {
        return next(
            HttpError(
                'This email is already exists.',
                409
            )
        );
    }
    if (usernameExists) {
        return next(
            new HttpError(
                'The provided username was taken. Please re-enter a unique username and try again.',
                409
            )
        );
    }

    let hashPassword;
    try {
        hashPassword = bcrypt.hash(password, 12);
    } catch (error) {
        return next(
            error || 'Something went wrong while saving the user password. Please try again later.'
        );
    }

    if (!hashPassword) {
        return next(
            new HttpError(
                'Something went wrong while saving the user password. Please try again later.',
                500
            )
        );
    }

    const createdUser = new User({
        username: username,
        email: email,
        password: hashPassword
    });

    let sess;
    try {
        sess = await mongoose.startSession();
        sess.startTransaction();
        await createdUser.save({ session: sess });
        await sess.commitTransaction();
    } catch (error) {
        return next(
            error || 'Something went wrong while saving userdata.'
        );
    }

    let token;
    try {
        token = jwt.sign({ userId: createdUser.id, email: createdUser.email }, process.env.SECRET_KEY, { expiresIn: '1h' });
    } catch (error) {
        return next(
            error || 'Something went wrong while getting the user token. Please try again later.'
        );
    }

    if (!token) {
        return next(
            HttpError(
                'Something went wrong while getting the user token. Please try again later.',
                500
            )
        );
    }

    res.status(
        201
    ).json({
        token: token
    });
}

exports.login = login;
exports.signup = signup;
