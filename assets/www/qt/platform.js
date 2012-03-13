function getAboutVersionString() {
    return "1.1alpha1";
}

function setMenuItemState(action, state) {
    // Stupid iterator
    $.each(menu_items, function(i, item) {
        if(item.id == action) {
            item.disabled = !state;
        }
    });
    updateMenuState();
}

function setPageActionsState(state) {
    setMenuItemState("page-actions", state);
}

var menu_items = [
    {
        id: 'go-back',
        action: chrome.goBack,
        disabled: true
    },
    {
        id: 'go-forward',
        action: chrome.goForward,
        disabled: true
    },
    {
        id: 'read-in',
        action:  languageLinks.showAvailableLanguages
    },
    {
        id: 'page-actions',
        action: function() {
            popupMenu([
                mw.msg('menu-savePage'),
                mw.msg('menu-sharePage'),
                mw.msg('menu-cancel')
            ], function(value, index) {
                if (index == 0) {
                    savedPages.saveCurrentPage();
                } else if (index == 1) {
                    sharePage();
                }
            }, {
                cancelButtonIndex: 2,
                origin: this
            });
        }
    },
    {
        id: 'list-actions',
        action: function() {
            popupMenu([
                mw.msg('menu-nearby'),
                mw.msg('menu-savedPages'),
                mw.msg('menu-history'),
                mw.msg('menu-cancel')
            ], function(val, index) {
                if (index == 0) {
                    geo.showNearbyArticles();
                } else if (index == 1) {
                    savedPages.showSavedPages();
                } else if (index == 2) {
                    appHistory.showHistory();
                }
            }, {
                cancelButtonIndex: 3,
                origin: this
            });
        }
    },
    {
        id: 'view-settings',
        action: appSettings.showSettings
    }
];

function updateMenuState() {
    $('#menu').remove();
    var $menu = $('<div>');
    $menu
        .attr('id', 'menu')
        .appendTo('body');

    $.each(menu_items, function(i, item) {
        var $button = $('<button>');
        $button
            .attr('id', item.id)
            .attr('title', mw.msg(item.id));
        if(item.disabled) {
            $button.addClass("disabled");
        } else {
            $button.click(function() {
                item.action.apply(this);
            });
        }
        $button.append('<span>')
            .appendTo($menu);
    });
};


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

chrome.addPlatformInitializer(function() {
//    $('html').removeClass('goodscroll').addClass('badscroll');
})
