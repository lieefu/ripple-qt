import QtQuick 2.7

Page1Form {
    button1.onClicked: {
        console.log("Button Pressed. Entered text: " + textField1.text);
        app.setMessage(textField1.text);
    }
    function setMessage(msg){
        console.log("Response text: " + msg);
        return "qml page1 返回消息";
    }
}
