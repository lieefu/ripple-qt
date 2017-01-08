import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 500
    height: 250
    title: qsTr("ripple-qt_输入私钥密码")
    flags: Qt.Dialog
    PasswordForm {
        pass_label{
            text:"私钥密码:"
        }
        btn_return.onClicked: {
            var passtext=input_pass.text;
            var keystr=app.decryptKey(passtext);
            if(keystr===""){
               prompt_info.text="密码错误，私钥解密失败！";
                return;
            }
            prompt_info.text="私钥解密成功";
            accountpage.showkeystr=keystr
            window.close();


        }
    }
}
