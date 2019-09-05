/*
 * Copyright 2017 eWise Systems, Inc.
 */
(function () {
    var eWise = {};

    var getParamNames = function (func) {
        var STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
        var ARGUMENT_NAMES = /([^\s,]+)/g;
        var fnStr = func.toString().replace(STRIP_COMMENTS, '');
        var result = fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(ARGUMENT_NAMES);
        if (result === null)
            result = [];
        return result;
    };

    if(window.Papa){
        eWise.Papa = window.Papa;
    }    
    
    eWise.currentPage = function (pages) {
        var page;
        if (pages.some(function (p) {
            if (p.isCurrentPage()) {
                page = p;
                eWise.acaEngineJsLogger.info('found me at ' + p.name);
                return true;
            }
            eWise.acaEngineJsLogger.info('not at ' + p.name);
            return false;
        })) {
            return page;
        } else {
            eWise.acaEngineJsLogger.info('unkown page');
            return null;
        }
    };

    eWise.getState = function () {
        var state = eWise.engine.getState();
        if (state) {
            return JSON.parse(state);
        } else {
            return state;
        }
    };

    eWise.setState = function (state) {
        eWise.engine.setState(JSON.stringify(state));
    };

    eWise.aca = function (acaFactory) {
        if (typeof acaFactory !== 'function') {
            eWise.acaEngineJsLogger.error('Illegal argument. eWise.aca expects a function.');
            throw 'Illegal argument. eWise.aca expects a function.';
        }

        var params = getParamNames(acaFactory);
        var args = [];
        for (var i = 0; i < params.length; i++) {
            if (eWise.hasOwnProperty(params[i])) {
                args[i] = eWise[params[i]];
            } else {
                args[i] = undefined;
            }
        }

        var aca = acaFactory.apply(undefined, args);
        var goal = eWise.engine.goal();
        if (typeof aca[goal] !== 'function') {
            var errorMessage = 'ACA does not support goal: ' + goal;
            eWise.acaEngineJsLogger.error(errorMessage);
            eWise.engine.setStatus("error");
            eWise.engine.setErrorMessage(errorMessage);
            eWise.engine.done();
        } else {
            aca[goal].call(undefined);
        }
    };

    window.eWise = eWise;
}());
