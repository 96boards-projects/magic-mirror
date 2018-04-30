import QtQuick 2.9
import QtQuick.Controls 2.2

Page {

    // Begin
        function getData() {
            var xmlhttp = new XMLHttpRequest();
            var url = "http://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=abec9e19c6d34f469a4c58302717fa9f";

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
            var title = arr.articles[0].title;
            var desc = arr.articles[0].description;
            var authname = arr.articles[0].author;
            var source = arr.articles[0].source.name;
            var date = arr.articles[0].publishedAt;
            console.log(desc);
            title_lable.text = "HeadLine: " + title + "\nBy: " + authname + "\n" + desc + "\nSource: " + source + "\nTime: " + date;

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

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 720
        height: 1280
        color: "#000000"
        anchors.fill: parent

        Label {
            id: label
            color: "#ffffff"
            text: qsTr("News")
            font.italic: false
            anchors.topMargin: 5
            anchors.bottomMargin: 8
            anchors.leftMargin: 13
            anchors.fill: parent
            font.family: "Cantarell"
            font.pointSize: 28
            font.bold: false
            styleColor: "#ffffff"

            Label {
                id: title_lable
                color: "#ffffff"
                text: qsTr("Foo News Title")
                fontSizeMode: Text.Fit
                styleColor: "#ffffff"
                anchors.bottomMargin: 0
                anchors.topMargin: 77
                anchors.fill: parent
                wrapMode: Text.WordWrap
            }
        }
    }

}
