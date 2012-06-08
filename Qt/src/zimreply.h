#include <src/zimfilewrapper.h>
#include <QNetworkReply>
#include <QBuffer>
#include <QPainter>
#include <QImage>
#include <QColor>
#include <QThread>
#include <src/asynchronouszimreader.h>

class ZimReply : public QNetworkReply
{
    Q_OBJECT
private:
    static ZimFileWrapper* zimFileWrapper;

public:
    ZimReply(QObject* object, const QNetworkRequest& request)
        : QNetworkReply(object)
        , position(0)
    {        
        setRequest(request);
        setOperation(QNetworkAccessManager::GetOperation);
        open(ReadOnly|Unbuffered);
        setUrl(request.url());
        qDebug() <<"Creating AsynchronousZimReader";
        //TODO: check whether can be optimized reusing thread.
        // (Would require that requests are strictly sequential,
        // which is doubtful)
        AsynchronousZimReader *zimReader = new AsynchronousZimReader(this,ZimReply::zimFileWrapper);

        connect(zimReader, SIGNAL(readDone(QByteArray)),
                SLOT(readFromZimFileDone(QByteArray)));
        zimReader->readAsync(request.url());
    }

    qint64 readData(char* data, qint64 maxSize)
    {
        const qint64 readSize = qMin(maxSize, (qint64)(buffer.size() - position));
        memcpy(data, buffer.constData() + position, readSize);
        position += readSize;
        return readSize;
    }

    virtual qint64 bytesAvailable() const
    {
        return buffer.size() - position;
    }

    virtual qint64 pos () const
    {
        return position;
    }

    virtual bool seek( qint64 pos )
    {
        if (pos < 0 || pos >= buffer.size())
            return false;
        position = pos;
        return true;
    }

    virtual qint64 size () const
    {
        return buffer.size();
    }


    static void setZimFileWrapper(ZimFileWrapper* zimFileWrapper) {
        ZimReply::zimFileWrapper = zimFileWrapper;        
    }

    static ZimFileWrapper* getZimFileWrapper() {
        return zimFileWrapper;
    }

public slots:
    void readFromZimFileDone(const QByteArray& data)
    {
        qDebug() << Q_FUNC_INFO << " url: " << this->url();
        setHeader(QNetworkRequest::ContentTypeHeader, QLatin1String("text/html"));
        position = 0;
        buffer = data;
        emit readyRead();
        emit finished();
    }

    void abort()
    {
    }
public:
    QNetworkReply* rawReply;
private:
    QByteArray buffer;
    int position;


};

