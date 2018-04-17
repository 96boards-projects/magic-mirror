import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQml 2.2

Item {
    property alias image1: image1
    property alias image: image
    width: 1920
    height: 1080
    Rectangle {
        id: rectangle
        color: "#000000"
        anchors.fill: parent

        Label {
            id: label
            x: 13
            y: 5
            color: "#ffffff"
            text: qsTr("Welcome")
            font.italic: false
            anchors.topMargin: 5
            anchors.bottomMargin: 0
            anchors.leftMargin: 13
            anchors.fill: parent
            font.family: "Cantarell"
            font.pointSize: 28
            font.bold: false
            styleColor: "#ffffff"

            Image {
                id: image
                anchors.bottomMargin: 223
                anchors.leftMargin: 1239
                anchors.rightMargin: 8
                anchors.topMargin: 281
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "arrow-left.png"
            }

            Image {
                id: image1
                anchors.bottomMargin: 252
                anchors.leftMargin: -6
                anchors.rightMargin: 1253
                anchors.topMargin: 252
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "arrow-right.png"
            }

            Label {
                id: label1
                color: "#ffffff"
                text: qsTr("Swipe to Navigate")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                styleColor: "#ffffff"
            }
        }

        Image {
            id: image2
            anchors.topMargin: 770
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "96Boards.png"
        }
    }

}
