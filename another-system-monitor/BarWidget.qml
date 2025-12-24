import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Rectangle {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    property real cpuUsage: 0
    property var coreUsage: []
    property string cpuCursor: ""

    // internal buffer
    property string stdoutBuffer: ""

    implicitWidth: row.implicitWidth + Style.marginM * 2
    implicitHeight: row.implicitHeight + Style.MarginM * 2
    color: Style.capsuleColor
    radius: Style.radiusM

    Process {
        id: cpuProc

        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                stdoutBuffer += data
            }
        }

        // when the process stops running, stdout is complete
        onRunningChanged: {
            if (running) return

            if (!stdoutBuffer.length)
                return

            try {
                const obj = JSON.parse(stdoutBuffer)

                if (obj.usage !== undefined)
                    cpuUsage = obj.usage

                if (obj.coreUsage)
                    coreUsage = obj.coreUsage

                if (obj.cursor)
                    cpuCursor = obj.cursor
            } catch (e) {
                console.warn("dgop cpu JSON parse failed:", e)
            }

            stdoutBuffer = ""
        }
    }

    Timer {
        interval: 2000 // Change this to set what interval the usage is refreshed
        running: true
        repeat: true
        onTriggered: {
            if (cpuCursor.length > 0) {
                cpuProc.command = [
                    "dgop", "cpu", "--json",
                    "--cursor", cpuCursor
                ]
            } else {
                // baseline
                cpuProc.command = ["dgop", "cpu", "--json"]
            }

            cpuProc.running = true
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Style.marginS

        NIcon {
            icon: "cpu"
            color: Color.mPrimary
        }

        NText {
            text: cpuUsage.toFixed(1) + "%"
            color: Color.mOnSurface
            pointSize: Style.fontSizeS
        }
    }
}
