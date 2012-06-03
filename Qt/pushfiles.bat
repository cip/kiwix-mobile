

adb root
adb push "c:\users\Christian\Downloads\Bryan Adams.zim" "/data/data/org.kde.necessitas.example.WikipediaMobile/files/Bryan Adams.zim"
adb push C:\Symbian\Carbide\workspace\kiwixqt\WikipediaMobileQt\assets\www /data/data/org.kde.necessitas.example.WikipediaMobile/files/
REM adb shell "mkdir /data/data/org.kde.necessitas.example.WikipediaMobile/files/xml"
REM #adb push C:\Symbian\Carbide\workspace\kiwixqt\WikipediaMobileQt\Qt\xml\plugins.xml /data/data/org.kde.necessitas.example.WikipediaMobile/files/xml
adb push C:\Symbian\Carbide\workspace\kiwixqt\WikipediaMobileQt\Qt\xml\plugins.xml /data/data/org.kde.necessitas.example.WikipediaMobile/files


adb shell "ls  /data/data/org.kde.necessitas.example.WikipediaMobile/files/index.html"