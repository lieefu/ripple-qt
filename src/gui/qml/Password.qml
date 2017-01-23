import QtQuick 2.0

PasswordForm {
    Keys.onPressed: {
        if(event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return){
            return;
        }
        event.accepted = true;
        if(input_pass.focus){
            btn_return.clicked();
            return;
        }
        input_pass.forceActiveFocus();
    }
    Component.onCompleted:input_pass.forceActiveFocus();
}
