const getBasePath = function () {
    let basePath = (window.BASE_PATH || '');
    if (basePath.endsWith('/')) {
        basePath = basePath.slice(0, -1);
    }
    return basePath;
}

module.exports = getBasePath;