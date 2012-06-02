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
    # TODO find out why this is not working on my linux. (actually it should)
    LIBS += -lzimlib
    LIBS += -lliblzma
#LIBS += -L../zimlib

#    LIBS += -l:libzimlib.a
 #   LIBS += -L../xz
  #  LIBS += -l:libliblzma.lib.a
} else:simulator {
   #Libs need to be copied to ../simulatorlibs manually
    LIBS *= -L../../../simulatorlibs -lzimlib
    LIBS *= -L../../../simulatorlibs -lliblzma
} else:linux-g++ {
    LIBS += -L/usr/lib
    LIBS += -L/usr/local/lib
    LIBS += -L/usr/lib/i386-linux-gnu/
    LIBS += -lzim -llzma
} else {
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
    MOBILITY += feedback location systeminfo sensors contacts
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
    qtc_packaging/debian_harmattan/changelog

