eWise.bridge = {
    callback(state) {
        window.webkit.messageHandlers.callback.postMessage(state);
    }
};

true;
