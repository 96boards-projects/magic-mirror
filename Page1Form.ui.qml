import QtQuick 2.9
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQml 2.2

Page {
    id: page_1

    property alias rectangle: rectangle
    Rectangle {
        id: rectangle
        property alias calendar: calendar
        //property alias clock: clock
        color: "#000000"
        anchors.fill: parent

        Label {
            id: label
            color: "#ffffff"
            text: qsTr("Calendar")
            font.italic: false
            anchors.topMargin: 5
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.fill: parent
            font.family: "Cantarell"
            font.pointSize: 28
            font.bold: false
            styleColor: "#ffffff"

            Item {
                id: clock
                z: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.fill: parent

                Column {
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 53
                    anchors.fill: parent
                    property alias text1: text1
                    property alias timer: timer
                    Text {
                        id: text1
                        color: "#ffffff"
                        styleColor: "#ffffff"
                        font {
                            family: "Cantarell"
                            pixelSize: 80
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Calendar {
                        id: calendar
                        antialiasing: true
                        weekNumbersVisible: false
                        anchors.rightMargin: 67
                        anchors.leftMargin: 67
                        anchors.bottomMargin: 29
                        anchors.topMargin: 149
                        anchors.fill: parent
                        //
                        style: CalendarStyle {
                            id: cal_style
                            gridVisible: false
                            dayOfWeekDelegate: Rectangle {
                                color: "black"
                                height: dayText.height * 2
                                Label {
                                    id: dayText
                                    text: control.locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                                    anchors.centerIn: parent
                                    font.pixelSize: 30
                                    font.bold: true
                                    color: "white"
                                }
                            }

                            navigationBar: Rectangle {
                                color: "black"
                                height: dateText.height * 2

                                Rectangle {
                                    color: "white"
                                    height: 1
                                    width: parent.width
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    height: 1
                                    width: parent.width
                                    color: "white"
                                }

                                Label {
                                    id: dateText
                                    text: styleData.title
                                    font.pixelSize: 40
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.leftMargin: 2
                                    anchors.rightMargin: 2
                                    color: "white"
                                }
                            }

                            dayDelegate: Rectangle {
                                id: cal_rect
                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.00
                                        color: styleData.selected ? "white" : (styleData.visibleMonth && styleData.valid ? "black" : "black");
                                    }

                                }
                                property alias cal_lable: cal_lable
                                Label {
                                    id: cal_lable
                                    text: styleData.date.getDate()
                                    anchors.centerIn: parent
                                    color: styleData.selected ? "black" : (styleData.visibleMonth && styleData.valid ? "white" : "grey");
                                    font.bold: true
                                    font.pointSize: 25
                                    font.family: "Cantarell"                                 
                                }



                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: "white"
                                    anchors.bottom: parent.bottom
                                }

                                Rectangle {
                                    width: 1
                                    height: parent.height
                                    color: "white"
                                    anchors.right: parent.right
                                }
                            }
                        }
                    }
                }


            Timer {
                id: timer
                interval: 500
                running: true
                repeat: true

                onTriggered: {
                    var date = new Date()
                    text1.text = date.toLocaleTimeString(Qt.locale("en_US"), "hh:mm:ss ap")
                }

             }


            }
        }
        // property alias cal : cal


    }

}

