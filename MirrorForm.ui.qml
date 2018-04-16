import QtQuick 2.4
import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQml 2.2

Item {

    Rectangle {
        id: rectangle
        color: "#000000"
        anchors.fill: parent

        Label {
            id: label
            color: "#ffffff"
            text: qsTr("Mirror")
            z: 1
            font.italic: false
            anchors.topMargin: 5
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.fill: parent
            font.family: "Cantarell"
            font.pointSize: 28
            font.bold: false
            styleColor: "#ffffff"

            Rectangle {
                id: rectangle1
                x: -13
                y: 116
                color: "#ffffff"
                anchors.topMargin: 121
                anchors.fill: parent

                Rectangle {
                    id: rectangle2
                    color: "#000000"
                    anchors.rightMargin: 30
                    anchors.leftMargin: 30
                    anchors.bottomMargin: 30
                    anchors.topMargin: 30
                    anchors.fill: parent
                }
            }
        }
    }


}
