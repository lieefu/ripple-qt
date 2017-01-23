import QtQuick 2.0

SetPasswordForm {
    Keys.onPressed: {
        if(event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return){
            return;
        }
        if(input_pass1.focus) {
            input_pass2.forceActiveFocus();
            return;
        }
        if(input_pass2.focus) {
            btn_return.clicked();
            return;
        }
        input_pass1.forceActiveFocus();
    }
    Component.onCompleted:input_pass1.forceActiveFocus();
}
