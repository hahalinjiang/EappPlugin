var exec = require('cordova/exec');

exports.TYPE={
	BY_LEFT:"by_left",
	BY_RIGHT:"by_right",
	BY_BOTTOM:"by_bottom",
	BY_TOP:"by_top"
};

exports.openNewView = function (type,url, success, error) {
    exec(success, error, 'EappPlugin', 'openNewView', [type,url]);
};
exports.viewBack = function ( success, error) {
    exec(success, error, 'EappPlugin', 'viewBack', null);
};
exports.exitApp = function () {
    exec(null, null, 'EappPlugin', 'exitApp',null);
};
exports.barcodeScanne = function (success, error) {
    exec(success, error, 'EappPlugin', 'barcodeScanne',null);
};
exports.openNewView = function (type,url, success, error) {
    exec(success, error, 'EappPlugin', 'openNewView', [type,url]);
};
exports.getValueFromApp = function (key, success, error) {
    exec(success, error, 'EappPlugin', 'getValueFromApp', [key]);
};
exports.setValueForApp = function (key, value, success, error) {
    exec(success, error, 'EappPlugin', 'setValueForApp', [key,value]);
};
