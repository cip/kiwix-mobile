/*
 *  Copyright 2011 Wolfgang Koller - http://www.gofg.at/
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include "cplugin.h"
#include "cordova.h"

#include <QDebug>

CPlugin::CPlugin() : QObject(0) {
}


/**
 * Override this function if your plugin requires startup initialisation
 */
void CPlugin::init() {
}

/**
 * Execute a callback on the javascript end
 */
void CPlugin::callback( int p_callbackId, QString p_jsParameters ) {
    QString javascript;

    if( p_jsParameters.length() > 0 ) {
        javascript = "Cordova.callback( " + QString::number( p_callbackId ) + ", " + p_jsParameters + " );";
    }
    else {
        javascript = "Cordova.callback( " + QString::number( p_callbackId ) + " );";
    }

    qDebug() << "Running: " << javascript;
    Cordova::instance()->execJS(javascript);
}
