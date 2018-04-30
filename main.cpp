#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick/QQuickView>
#include <QtCore/QDebug>
#include <QtCore/QDir>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtQuick>

#include <iostream>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

/* mraa headers */
#include "mraa/common.hpp"
#include "mraa/gpio.hpp"

#include <pthread.h>

#include "flick.h"

#define GPIO_PIN_1 34


void onGestureCb(FlickGesture_t gesture, FlickGestureClass_t gestClass, bool isEdgeFlick, bool inProgress){
    const char *g, *cl;
    switch (gesture){
    case GESTURE_GARBAGE_MODEL:
        g = "GARBAGE_MODEL";
        break;
    case FLICK_WEST_TO_EAST:
        g = "FLICK_WEST_TO_EAST";
        system("xdotool key Left");
        break;
    case FLICK_EAST_TO_WEST:
        g = "FLICK_EAST_TO_WEST";
        system("xdotool key Right");
        break;
    default:
        g = "NO_GESTURE";
    }

    qInfo << "Gesture: %s, class: %s, edge flick: %s, in progress: %s \n", g, cl, isEdgeFlick?"yes":"no", inProgress?"yes":"no";
}

void *blinky(void *rec)
{

    sleep(5);
    system("xdotool mousemove 0 1080");
    sleep(1);
    system("xdotool click 1");
    system("xdotool key Tab");

    Flick flick(34, 33);

        flick.gestureCallback = onGestureCb;
        usleep(250000);
            int ret = flick.SetRuntimeParameter(0xa1, 0x1f, 0xFFFFFFFF); // lock data output   <-----
            ret = flick.SetRuntimeParameter(0x80, 0x1b, 0x1F); // disable calibration
            //printf("ret: %d \n", ret);

        while (1) {
            flick.Poll();
            usleep(5000);
        }
        return 0;
}

int main(int argc, char *argv[])
{
    qInfo() << "run";
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    pthread_t threads[2];
    int rc;
    pthread_create(&threads[0], NULL, blinky, (void *)rc);
    if (rc)
    {
        qInfo() << rc;
    }

    return app.exec();
}
