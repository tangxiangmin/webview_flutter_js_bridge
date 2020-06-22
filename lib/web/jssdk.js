let callbackId = 1
function _callMethod(config) {
    let callbackName = `__native_callback_${callbackId++}`
    // 注册全局回调函数
    if(typeof config.callback === 'function') {
        let callback = config.callback.bind(config)
        window[callbackName] = function(args){
            callback(args);
            delete window[callbackName]
        }
    }
    config.callback = callbackName
    // 通过JavaScriptChannel注入的全局对象
    window.AppSDK.postMessage(JSON.stringify(config))
}
const sdk = {
    // 封装toast
    toast(data, callback) {
        _callMethod({
            method: 'toast',
            params: data,
            callback
        })
    },
    checkGoBack(callback){
        _callMethod({
            method: 'checkGoBack',
            params: {},
            callback,
        })
    }
}

window.callJS = {
    // 通过window.callJS.goBack = xxx添加
}