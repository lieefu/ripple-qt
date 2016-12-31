import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
Window {
    id: window
    width: 630
    height: 360
    visible: false
    title: qsTr("ripple-qt")
    flags: Qt.Dialog
    AboutForm {
        labelAbout.text: cfg.getLicenceInfo()
        labelAbout.onLinkActivated: Qt.openUrlExternally(link)
    }
}
