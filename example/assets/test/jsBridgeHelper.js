let callbacks = {};
let callbackId = 1;

class JSBridgeHelper {
    /**
     * 发送消息
     * @param api
     * @param data
     * @returns {Promise<unknown>}
     */
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
            // encode message
            const callbackId = this._pushCallback(resolve);
            // 发送消息
            this._postMessage(api, data, callbackId)
            // 增加回调异常容错机制，避免消息丢失导致一直阻塞
            setTimeout(() => {
                const cb = this._popCallback(callbackId)
                if (cb) {
                    cb(null)
                }
            }, 500)
        });
    }

    /**
     * 接受消息处理
     * @param message
     */
    receiveMessage(message) {
        // 新增isResponseFlag为true，避免App收到消息后需要再回复问题
        if (message.isResponseFlag) {
            // 通过callbackId 获取对应Promise
            const cb = this._popCallback(message.callbackId);
            if (cb) { // 有值，则直接调用对应函数
                cb(message.data);
            }
        } else if (message.callbackId) {
            if (message.api === 'isHome') {
                this._postMessage(message.api, true, message.callbackId, true)
            } else {
                // 对为支持的api返回默认null
                this._postMessage(message.api, null, message.callbackId, true)
            }
        }
    }

    /**
     * 给App发送消息
     * @param api
     * @param data
     * @param callbackId
     * @param isResponseFlag
     * @private
     */
    _postMessage(api, data, callbackId, isResponseFlag = false) {
        const encoded = JSON.stringify({
            api: api,
            data: data,
            callbackId: callbackId,
            isResponseFlag: isResponseFlag,
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
            callbacks[id] = null;
            return cb;
        }
        return null
    }
}

const jsBridgeHelper = new JSBridgeHelper()
window.jsBridgeHelper = jsBridgeHelper;