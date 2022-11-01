let callbacks = {};
let callbackId = 1;

class JSBridgeHelper {
    sendMessage(api, data) {

        return new Promise((resolve, reject) => {
            if (!api || api.length <= 0) {
                reject('api is invalid');
                return;
            }
            let nativeBridge = window.nativeBridge;
            if (nativeBridge === null || nativeBridge === undefined) {
                reject(`
        channel named nativeBridge not found in flutter. please add channel:
        WebView(
          url: ...,
          ...
          javascriptChannels: {
            JavascriptChannel(
              name: nativeBridge,
              onMessageReceived: (message) {
                (instance of WebViewFlutterJavaScriptBridge).parseJavascriptMessage(message);
              },
            ),
          },
        )
        `);
                return;
            }
            /// encode message
            const callbackId = this._pushCallback(resolve);
            const encoded = JSON.stringify({
                api: api,
                data: data,
                callbackId: callbackId,
            });

            nativeBridge.postMessage(encoded);
        });
    }

    receiveMessage(message) {
        if (message.callbackId) {
            const cb = this._popCallback(message.callbackId);
            if (cb) {
                cb(message.data);
            } else {
                if (message.api === 'isHome') {
                    this._postMessage(message.api, true.toString(), message.callbackId)
                }
            }
        }
    }

    /**
     * 给App发送消息
     * @param api
     * @param data
     * @param callbackId
     * @private
     */
    _postMessage(api, data, callbackId) {
        const encoded = JSON.stringify({
            api: api,
            data: data,
            callbackId: callbackId,
        })
        let nativeBridge = window.nativeBridge
        nativeBridge.postMessage(encoded)
    }

    /**
     * 记录一个函数并返回其对应的记录id
     * @param cb 需要记录的函数
     */
    _pushCallback(cb) {
        let id = callbackId++;
        let key = `api_${id}`;
        callbacks[key] = cb;
        return key;
    }

    /**
     * 删除id对应的函数
     * @param {string} id 函数的id
     */
    _popCallback(id) {
        if (callbacks[id]) {
            const cb = callbacks[id];
            callbacks.id = null;
            return cb;
        }
        return null
    }
}

const jsBridgeHelper = new JSBridgeHelper()
window.jsBridgeHelper = jsBridgeHelper;