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


#include <QApplication>

#include "src/cordova.h"

#if QT_VERSION < 0x050000
# include <QDeclarativeView>
#else
# include <QDeviceInfo>
# include <QQuickView>
#endif

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <qplatformdefs.h>

#ifdef MEEGO_EDITION_HARMATTAN
# include <MDeclarativeCache>
#endif


#include <QNetworkAccessManager>
#include <QDeclarativeNetworkAccessManagerFactory>
#include "src/zimreply.h"


class ZimNetworkAccessManager : public QNetworkAccessManager
{
public:
    ZimNetworkAccessManager(QObject* parent = 0) : QNetworkAccessManager(parent)
    {
    }

    virtual QNetworkReply *createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData)
    {
        qDebug() << "In ZimNetworkAccessManager::createRequest. Operation : " << op << " request.url():" << request.url();

        //if (op != GetOperation || request.url().scheme() != QLatin1String("qt-render") || request.url().host() != QLatin1String("button"))
        //TODO external links?
        qDebug() << "Loading url: " << request.url();
        if ((request.url().scheme() == QLatin1String("zim")) && (op == QNetworkAccessManager::GetOperation)) {
            qDebug() << "request targets zim file -> read from zimfile.";
            return new ZimReply(this, request);
        } else {
            qDebug() << "request not to zim file -> createRequest";
            return QNetworkAccessManager::createRequest(op, request, outgoingData);
        }
    }
};



class MyNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
 {
 public:
     virtual QNetworkAccessManager *create(QObject *parent);
 };

QNetworkAccessManager *MyNetworkAccessManagerFactory::create(QObject *parent)
 {
     QNetworkAccessManager *nam = new ZimNetworkAccessManager(parent);
     return nam;
 }


#ifdef MEEGO_EDITION_HARMATTAN
Q_DECL_EXPORT int main(int argc, char *argv[])
#else
int main(int argc, char *argv[])
#endif
{

#ifdef MEEGO_EDITION_HARMATTAN
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
#else
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
#endif

#if QT_VERSION < 0x050000
# ifdef MEEGO_EDITION_HARMATTAN
    QScopedPointer<QDeclarativeView> view(MDeclarativeCache::qDeclarativeView());
# else
    QScopedPointer<QDeclarativeView> view(new QDeclarativeView());
# endif
    Cordova::instance()->setTopLevelEventsReceiver(view.data());
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view->rootContext()->setContextProperty("cordova", Cordova::instance());
    //FIXME:
    view->engine()->setNetworkAccessManagerFactory(new MyNetworkAccessManagerFactory);
    ZimFileWrapper zimFileWrapper;

    //zimFileWrapper.openZimFile("../zim/HTML5VideoDemo.zim");
    //zimFileWrapper.openZimFile("C:\\Users\\Christian\\Downloads\\wikipedia_en_wp1_0.8_45000+_12_2010.zim");
    zimFileWrapper.openZimFile("/sdcard/Bryan Adams.zim");
# ifdef MEEGO_EDITION_HARMATTAN
    view->setSource(QUrl(QString("%1/qml/main_harmattan.qml").arg(Cordova::instance()->workingDir())));
    view->showFullScreen();
# else

#  if defined(Q_OS_SYMBIAN) || defined(QT_SIMULATOR)
    view->setSource(QUrl("qml/main.qml"));
    view->showFullScreen();
#  elif defined(Q_OS_ANDROID)
    //package qml into resources on android, as else not deployed to device.
    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();
#  else
    view->setSource(QUrl(QString("%1/qml/main.qml").arg(Cordova::instance()->workingDir())));
    view->show();
#  endif
# endif
#else // QT_VERSION >= 0x050000

    //HACK: we don't have any solution to check for harmattan in qt5
    // so we use check for LINUX OS and for "dfl61" substring in kernel version
    // (at least pr1.1 and pr1.2 contains it)
    QDeviceInfo info;
    bool isHarmattan = info.version(QDeviceInfo::Firmware).contains("dfl61");
#ifndef Q_OS_LINUX
    isHarmattan = false;
#endif

    //TODO: look later at boostable possibility for this here
    QScopedPointer<QQuickView> view(new QQuickView());;

    Cordova::instance()->setTopLevelEventsReceiver(view.data());
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->rootContext()->setContextProperty("cordova", Cordova::instance());

    if (isHarmattan) {
        view->setSource(QUrl(QString("%1/qml/main_harmattan_qt5.qml").arg(Cordova::instance()->workingDir())));
        view->showFullScreen();
    } else {
        view->setSource(QUrl(QString("%1/qml/main_qt5.qml").arg(Cordova::instance()->workingDir())));
        view->show();
    }
#endif

    return app->exec();
}
