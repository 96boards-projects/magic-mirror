import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true

    width: 1920
    height: 1080
    title: qsTr("Magic_Mirror")
    flags: Qt.FramelessWindowHint | Qt.Window

    function change(){
    tabBar.incrementCurrentIndex()
}

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        WecomeForm{
        }

        Page1Form {
        }

        Page2Form {
        }
        Page3Form {

        }
        MirrorForm {

        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Welcome")
        }
        TabButton {
            text: qsTr("Calander")
        }
        TabButton {
            text: qsTr("Weather")
        }
        TabButton {
            text: qsTr("News")
        }
        TabButton {
            text: qsTr("Mirror")
        }
    }
}
