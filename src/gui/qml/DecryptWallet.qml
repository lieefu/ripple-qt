import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("ripple-qt_输入钱包密码")
    flags: Qt.Dialog
    DecryptWalletForm {
        btn_return.onClicked: {
            var passtext=input_pass.text;
            console.log(passtext);
        }
    }
}
