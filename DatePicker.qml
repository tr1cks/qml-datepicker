import QtQuick 2.11
import QtQuick.Controls 2.4

Popup {
    //TODO: consider rounded corners
    //TODO: consider transition animation to new maximum day, month, year
    //TODO: fix reseting to first element month and day, when year and month changes respectively
    id: root

    property date value: new Date()
    property date min: new Date(1970, 0, 1)
    property date max: new Date(2037, 11, 31)
    property int fontSize: 16

    signal valueUpdated(var value)

    modal: true
    focus: true
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    rightPadding: 20
    leftPadding: 20

    onOpened: {
        yearTumbler.currentIndex = root.value.getFullYear() - root.min.getFullYear()

        if(isMinYear()) {
            monthTumbler.currentIndex = (root.value.getMonth() - root.min.getMonth())
        } else {
            monthTumbler.currentIndex = root.value.getMonth()
        }

        if(isMinYear() && isMinMonth()) {
            dayTumbler.currentIndex = (root.value.getDate() - root.min.getDate())
        } else {
            dayTumbler.currentIndex = root.value.getDate() - 1
        }
    }

    onClosed: {
        root.valueUpdated(new Date(currentYear(yearTumbler.currentIndex),
                                   currentMonth(monthTumbler.currentIndex),
                                   currentDay(dayTumbler.currentIndex)))
    }


    Row {
        spacing: 10

        Tumbler {
            id: yearTumbler

            model: root.max.getFullYear() - root.min.getFullYear() + 1

            delegate: Label {
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)

                text: currentYear(modelData)
                font.pointSize: root.fontSize

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function displacementItemOpacity(displacement, visibleItemCount) {
                    return 1.0 - Math.abs(displacement) / (visibleItemCount / 2)
                }
            }
        }

        Tumbler {
            id: monthTumbler

            width: 100

            model: {
                var months = 12

                if(isMaxYear()) {
                    months = root.max.getMonth() + 1
                }

                if(isMinYear()) {
                    months -= root.min.getMonth()
                }

                return months
            }

            delegate: Label {
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)

                text: Qt.locale().standaloneMonthName(currentMonth(modelData))
                font {
                    capitalization: Font.Capitalize
                    pointSize: root.fontSize
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function displacementItemOpacity(displacement, visibleItemCount) {
                    return 1.0 - Math.abs(displacement) / (visibleItemCount / 2)
                }
            }
       }

        Tumbler {
            id: dayTumbler

            model: {
                var days = daysInMonth(currentYear(yearTumbler.currentIndex),
                                       currentMonth(monthTumbler.currentIndex))

                if(isMaxYear() && isMaxMonth()) {
                    days = root.max.getDate()
                }

                if(isMinYear() && isMinMonth()) {
                    days -= (root.min.getDate() - 1)
                }

                return days
            }

            delegate: Label {
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)

                text: currentDay(modelData)
                font.pointSize: root.fontSize

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function displacementItemOpacity(displacement, visibleItemCount) {
                    return 1.0 - Math.abs(displacement) / (visibleItemCount / 2)
                }
            }
        }
    }

    function isMinYear() {
        return yearTumbler.currentIndex === 0
    }

    function isMaxYear() {
        return yearTumbler.currentIndex === (yearTumbler.model - 1)
    }

    function isMinMonth() {
        return monthTumbler.currentIndex === 0
    }

    function isMaxMonth() {
        return monthTumbler.currentIndex === (monthTumbler.model - 1)
    }

    function currentYear(yearIdx) {
        return yearIdx + root.min.getFullYear()
    }

    function currentMonth(monthIdx) {
        if(yearTumbler.currentIndex === 0) {
            return monthIdx + root.min.getMonth()
        } else {
            return monthIdx
        }
    }

    function currentDay(dayIdx) {
        if(yearTumbler.currentIndex === 0 && monthTumbler.currentIndex === 0) {
            return dayIdx + root.min.getDate()
        } else {
            return dayIdx + 1
        }
    }

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }
}
