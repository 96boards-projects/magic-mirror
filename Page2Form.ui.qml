import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: page

    Label {
        id: label
        color: "#ffffff"
        text: qsTr("Weather")
        anchors.rightMargin: 0
        z: 1
        font.italic: false
        anchors.topMargin: 0
        anchors.bottomMargin: 343
        anchors.leftMargin: 12
        anchors.fill: parent
        font.family: "Cantarell"
        font.pointSize: 28
        font.bold: false
        styleColor: "#ffffff"
    }

// Begin
    function getData() {
        var xmlhttp = new XMLHttpRequest();
        var url = "http://api.openweathermap.org/data/2.5/weather?id=1261481&units=metric&appid=<enter api key>";

        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                myFunction(xmlhttp.responseText);
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }

    function myFunction(response) {
        var arr = JSON.parse(response);
        var main_temp = arr.main.temp;
        var name = arr.name;
        var count = arr.sys.country;
        var weather_title = arr.weather[0].main;
        var weather_desc = arr.weather[0].description;
        var tempmin = arr.main.temp_min;
        var tempmax = arr.main.temp_max;
        console.log(name);
        temp.text = main_temp + "c";
        place.text = name + ", " + count;
        weather_main.text = weather_title;
        weather_secondary.text = weather_desc;
        temp_min.text = "Min: " + tempmin + "c";
        temp_max.text = "Max: " + tempmax + "c";
    }

    Timer {
            id: timer_init
            interval: 1000
            running: true
            onTriggered: getData()
        }
    Timer {
            id: timer
            interval: 1000*60*10
            running: true
            repeat: true
            onTriggered: getData()
        }
// End

    property alias page: page



    Rectangle {
        id: rectangle
        color: "#000000"
        anchors.fill: parent

        Frame {
            id: frame
            anchors.topMargin: 94
            anchors.fill: parent

            Label {
                id: place
                color: "#ffffff"
                text: qsTr("Place, CA")
                font.pointSize: 39
                font.family: "Arial"
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: -12
                anchors.bottomMargin: -12
                anchors.fill: parent

                Label {
                    id: temp
                    x: -18
                    y: 70
                    color: "#ffffff"
                    text: qsTr("23")
                    anchors.rightMargin: 6
                    anchors.leftMargin: -6
                    verticalAlignment: Text.AlignTop
                    font.pointSize: 120
                    styleColor: "#ffffff"
                    anchors.bottomMargin: 8
                    anchors.topMargin: 70
                    anchors.fill: parent

                    Label {
                        id: temp_min
                        x: -6
                        y: 170
                        color: "#ffffff"
                        text: qsTr("Min: 20")
                        anchors.rightMargin: -8
                        anchors.leftMargin: 8
                        font.pointSize: 50
                        styleColor: "#ffffff"
                        anchors.bottomMargin: 0
                        anchors.topMargin: 166
                        anchors.fill: parent

                        Label {
                            id: temp_max
                            x: -14
                            y: 98
                            color: "#ffffff"
                            text: qsTr("Max: 30")
                            anchors.rightMargin: -5
                            anchors.leftMargin: 0
                            font.pointSize: 50
                            styleColor: "#ffffff"
                            anchors.bottomMargin: 0
                            anchors.topMargin: 64
                            anchors.fill: parent

                            Label {
                                id: weather_main
                                x: -8
                                y: 165
                                color: "#ffffff"
                                text: qsTr("Cloudy")
                                anchors.rightMargin: 0
                                anchors.leftMargin: 0
                                font.pointSize: 75
                                styleColor: "#ffffff"
                                anchors.bottomMargin: -9
                                anchors.topMargin: 61
                                anchors.fill: parent

                                Label {
                                    id: weather_secondary
                                    x: 0
                                    y: 185
                                    color: "#ffffff"
                                    text: qsTr("with a chance of meatballs")
                                    anchors.leftMargin: 8
                                    wrapMode: Text.WordWrap
                                    font.pointSize: 35
                                    styleColor: "#ffffff"
                                    anchors.rightMargin: -8
                                    anchors.bottomMargin: 8
                                    anchors.topMargin: 113
                                    anchors.fill: parent
                                }
                            }
                        }
                    }
                }
            }
        }

    }

}
