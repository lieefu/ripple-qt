import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
    width: 800
    height: 600
    property alias labelAbout: labelAbout
    Label {
        id: labelAbout
        x: 33
        y: 34
        text: qsTr("Label")
        textFormat: Text.RichText
    }
}
