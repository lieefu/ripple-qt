import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 500
    height: 250
    title: qsTr("ripple-qt_输入钱包密码")
    flags: Qt.Dialog
    PasswordForm {
        pass_label{
            text:"钱包密码:"
        }
        btn_cancel.onClicked: {
            close();
        }

        btn_return.onClicked: {
            var passtext=input_pass.text;
            if(app.decryptWallet(passtext)){
                prompt_info.text="钱包解密成功";
                app.showMainWin();
                window.close();
                return;
            }
            prompt_info.text="密码错误，钱包解密失败";
        }
    }
}
