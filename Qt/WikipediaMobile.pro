# Add files and directories to ship with the application
# by adapting the examples below.
# file1.source = myfile
# dir1.source = mydir
mainWwwDir.source = ../assets/www
wwwDir.source = www
xmlDir.source = xml
qmlDir.source = qml

DEPLOYMENTFOLDERS = mainWwwDir wwwDir xmlDir qmlDir # file1 dir1


SOURCES += main.cpp \
    src/plugins/notification.cpp \
    src/plugins/geolocation.cpp \
    src/plugins/fileapi.cpp \
    src/plugins/device.cpp \
    src/pluginregistry.cpp \
    src/plugins/console.cpp \
    src/plugins/connection.cpp \
    src/plugins/compass.cpp \
    src/plugins/accelerometer.cpp \
    src/plugins/events.cpp \
    src/cordova.cpp \
    src/cplugin.cpp \
    src/plugins/contacts.cpp
SOURCES +=     src/zimfilewrapper.cpp \
    src/zimreply.cpp \
    src/asynchronouszimreader.cpp

HEADERS += \
    src/plugins/notification.h \
    src/plugins/geolocation.h \
    src/plugins/fileapi.h \
    src/plugins/device.h \
    src/pluginregistry.h \
    src/plugins/console.h \
    src/plugins/connection.h \
    src/plugins/compass.h \
    src/plugins/accelerometer.h \
    src/plugins/events.h \
    src/cordova.h \
    src/cplugin.h \
    src/plugins/contacts.h
HEADERS +=  src/zimfilewrapper.h \
    src/zimreply.h \
    src/asynchronouszimreader.h

INCLUDEPATH += ../../../zimlib/include ../../../xz
symbian: {
    message("symbian")
    # TODO find out why this is not working on my linux. (actually it should)
    LIBS += -lzimlib
    LIBS += -lliblzma
#LIBS += -L../zimlib

#    LIBS += -l:libzimlib.a
 #   LIBS += -L../xz
  #  LIBS += -l:libliblzma.lib.a
} else:simulator {
    message("simulator")
   #Libs need to be copied to ../simulatorlibs manually
    LIBS *= -L../../../simulatorlibs -lzimlib
    LIBS *= -L../../../simulatorlibs -lliblzma
} else:linux-g++ {
    message("linux-g++")
    LIBS += -L/usr/lib
    LIBS += -L/usr/local/lib
    LIBS += -L/usr/lib/i386-linux-gnu/
    LIBS += -lzim -llzma
} else:android {
    message("android")
    LIBS += -L../libs/android -lzimlib
    LIBS += -L../libs/android -lliblzma

    RESOURCES += \
        qml.qrc
} else {
    message("Other target")
    LIBS *= -L../../zimlib -lzimlib
    LIBS *= -L../../xz -lliblzma
}

QT += network \
    core

greaterThan(QT_MAJOR_VERSION, 4) {
    message("Qt5 build")
    QT += widgets
    QT += location
    QT += sensors
    QT += feedback
    QT += systeminfo
    QT += contacts
    QT += quick declarative

    OTHER_FILES += qml/main_qt5.qml \
        qml/main_harmattan_qt5.qml \
        qml/cordova_wrapper.js

} else:!isEmpty(MEEGO_VERSION_MAJOR) {
    message("Qt4 build")
    message("Harmattan build")

    OTHER_FILES += qml/main_harmattan.qml \
        qml/cordova_wrapper.js

    QT += declarative
    CONFIG += mobility qdeclarative-boostable

    MOBILITY += feedback location systeminfo sensors contacts
} else {
    message("Qt4 build")
    message("Non-harmattan build")

    OTHER_FILES += qml/main.qml \
        qml/cordova_wrapper.js

    symbian:TARGET.UID3 = 0xE3522943
    #symbian:DEPLOYMENT.installer_header = 0x2002CCCF
    symbian:TARGET.CAPABILITY += NetworkServices

    QT += declarative

    CONFIG += mobility
    #MOBILITY += feedback location systeminfo sensors contacts
    #Removed temp location, as else not working on android.
    # error: W/dalvikvm(31667): JNI WARNING: expected return type 'I'
    #        W/dalvikvm(31667):              calling Lorg/kde/necessitas/mobile/QtLocation;.supportedPositiongMethods ()J

    MOBILITY += feedback systeminfo sensors contacts
}

QT += webkit

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    android/AndroidManifest.xml \
    android/res/drawable/icon.png \
    android/res/drawable/logo.png \
    android/res/drawable-hdpi/icon.png \
    android/res/drawable-ldpi/icon.png \
    android/res/drawable-mdpi/icon.png \
    android/res/layout/splash.xml \
    android/res/values/libs.xml \
    android/res/values/strings.xml \
    android/res/values-de/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-es/strings.xml \
    android/res/values-et/strings.xml \
    android/res/values-fa/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/values-nb/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values-pl/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-ru/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/origo/QtActivity.java \
    android/src/org/kde/necessitas/origo/QtApplication.java \
    android/version.xml

message(QT: $$QT)
message(MOBILITY: $$MOBILITY)

