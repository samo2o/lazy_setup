require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');

const HttpError = require('./models/http-error');
const log = require('./models/console-log');
const userRouter = require('./routes/user-routes');

const app = express();

app.use(express.json());

//CORS
app.use((req, res, next) => {
    res.setHeader(
        'Access-Control-Allow-Origin',
        '*'
    );
    res.setHeader(
        'Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    );
    res.setHeader(
        'Access-Control-Allow-Methods',
        'GET, POST, PATCH, DELETE'
    );
    next();
});

//ROUTES
app.use('/api/v1/user', userRouter);

//UN-SUPPORTED ROUTES
app.use((req, res, next) => {
    return next(
        new HttpError(
            'This route is not supported.',
            404
        )
    );
});

//ERRORS MIDDLEWARE
app.use((error, req, res, next) => {
    if (req.headerSent) {
        return next(error);
    }
    res.status(
        error.code || 500
    ).json({
        code: error.code || 500,
        message: error.message || 'Something went wrong.'
    });
});

mongoose.connect(
    `mongodb://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@${process.env.DB_ADDRESS}:${process.env.DB_PORT}/${process.env.DB_NAME}?directConnection=true`
).then(() => {
    app.listen(process.env.SV_PORT);
    log('Server initiated successfully...', 'success');
    log('listening in port: ' + process.env.SV_PORT);
}).catch((error) => {
    log('Server failed to initiate.', 'error');
    log(error, 'error');
});
