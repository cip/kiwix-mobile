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

#ifndef CPLUGIN_H
#define CPLUGIN_H

#include <QObject>

class CPlugin : public QObject
{
    Q_OBJECT
public:
    explicit CPlugin();

    // This function should be overwritten, if the Plugin requires startup initialisation
    virtual void init();

signals:

public slots:

protected:
    void callback( int p_callbackId, QString p_jsParameters );
};

#endif // CPLUGIN_H
