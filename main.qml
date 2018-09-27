import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: root

    property date value: new Date(2018, 1, 15)

    title: qsTr("Hello Date Picker")
    visible: true
    width: 640
    height: 480

    Page {
        anchors.fill: parent

        header: ToolBar {}

        DateField {
            value: root.value

            onValueUpdated: {
                root.value = value
            }
        }
    }
}
