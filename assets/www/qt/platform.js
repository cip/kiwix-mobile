function getAboutVersionString() {
    return "1.1beta2";
}

function setMenuItemState(action, state, noUpdate) {
    if(state) {
        $("command[action='" + action + "']").removeAttr("disabled");
    } else {
        $("command[action='" + action + "']").attr("disabled", "disabled");
    }
    if(!noUpdate) {
        updateMenuState();
    }
}

function setPageActionsState(state) {
    setMenuItemState("read-in", state, true);
    setMenuItemState("save-page", state, true);
    setMenuItemState("share-page", state, true);
}

window.CREDITS = [
    "<a href='http://phonegap.com'>PhoneGap</a>, Apache License 2.0",
    "<a href='http://jquery.com'>jQuery</a>, MIT License",
    "<a href='http://leaflet.cloudmade.com/'>Leaflet.js</a>, 2-Clause BSD License",
    "<a href='http://zeptojs.com'>Zepto</a>, MIT License",
    "<a href='http://cubiq.org/iscroll-4'>iScroll</a>, MIT License",
    "<a href='http://twitter.github.com/hogan.js/'>Hogan.js</a>, Apache License 2.0"
    ];



function selectText() {
    console.log("platform.js: selectText()")
}

function sharePage() {
    // @fixme if we don't have a page loaded, this menu item should be disabled...
    var title = app.getCurrentTitle(),
        url = app.getCurrentUrl().replace(/\.m\.wikipedia/, '.wikipedia');
    window.plugins.share.show(
        {
            subject: title,
            text: url
        }
    );
}

chrome.showNotification = function(text) {
            console.log("platform.js: chrome.showNotification()")
}

function updateMenuState() {
    console.log("platform.js: updateMenuState()")
};

network.isConnected = function()  {
    return navigator.network.connection.type == Connection.NONE ? false : true;
}

//@Override
app.setCaching = function(enabled, success) {
    console.log('setting cache to ' + enabled);
    if(enabled) {
        window.plugins.CacheMode.setCacheMode('LOAD_CACHE_ELSE_NETWORK', success);
    } else {
        window.plugins.CacheMode.setCacheMode('LOAD_DEFAULT', success);
    }
}

