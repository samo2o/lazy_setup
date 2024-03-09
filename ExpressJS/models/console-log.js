const log = (message, type = 'log') => {
    const colorCodes = {
      success: '\x1b[32m', // Green
      error: '\x1b[31m',   // Red
      log: '\x1b[97m',     // White
    };

    const symbols = {
        success: '✔',
        error: '✖',
        log: 'i',
    };

    if (!colorCodes[type] || !symbols[type]) {
        console.error('Invalid log type');
        return;
    }

    const logPrefix = `${colorCodes[type]}${symbols[type]}`;
    const resetColor = '\x1b[0m';

    console.log(`${logPrefix} ${message}${resetColor}`);
};

module.exports = log;
