import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1200
    height: 720
    minimumWidth: 1000
    minimumHeight: 620
    title: "LITHO COMMAND DASHBOARD"

    property int page: 0
    property int progress: 0
    property bool exposing: false
    property real dose: 32.50
    property real overlay: 1.62
    property var pages: ["Dashboard", "Wafer Map", "Batch Queue", "Scanner Health", "Alarms"]
    property bool stopped: false

    function safetyCheckPassed() {
        if (!vacuumStable) {
            alarmMessage = "[CRITICAL] Vacuum not stable. Exposure blocked."
            return false
        }

        if (!waferLoaded) {
            alarmMessage = "[CRITICAL] No wafer loaded. Exposure blocked."
            return false
        }

        if (!reticleLocked) {
            alarmMessage = "[CRITICAL] Reticle not locked. Exposure blocked."
            return false
        }

        if (!doorClosed) {
            alarmMessage = "[CRITICAL] Access door open. Exposure blocked."
            return false
        }

        alarmMessage = "[INFO] Safety interlocks passed. Exposure allowed."
        return true
    }


    Timer {
        interval: 120
        running: exposing
        repeat: true

        onTriggered: {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "http://127.0.0.1:8000/status")
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    var data = JSON.parse(xhr.responseText)

                    progress = data.progress
                    dose = data.dose
                    flowIndex = steps.indexOf(data.state)
                }
            }
            xhr.send()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#07111b"

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.preferredWidth: 210
                Layout.fillHeight: true
                color: "#07111b"
                border.color: "#27485c"

                Column {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: "LITHO//OPS"
                        color: "white"
                        font.pixelSize: 24
                        font.bold: true
                    }

                    Text {
                        text: "COMMAND NAVIGATION"
                        color: "#8aa8b8"
                        font.pixelSize: 10
                        font.bold: true
                    }

                    Repeater {
                        model: pages

                        Rectangle {
                            width: parent.width
                            height: 38
                            radius: 6
                            color: page === index ? "#15516b" : "#0d1d2a"
                            border.color: page === index ? "#6de3ff" : "#2e4a5c"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "white"
                                font.pixelSize: 12
                                font.bold: page === index
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: page = index
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#2e4a5c"
                    }
                    Button {
                        width: parent.width
                        height: 32
                        text: "STOP EXPOSURE"
                        enabled: exposing || progress > 0

                        onClicked: {
                            stopped = true
                            exposing = false
                            exposeTimer.stop()
                            flowTimer.stop()
                            inspectTimer.stop()

                            console.log("STOPPED at " + progress + "%")
                        }
                    }


                    Button {
                        width: parent.width
                        height: 34
                        text: exposing ? "EXPOSING..." : "START EXPOSURE"

                        onClicked: {
                            stopped: false
                            progress = 0
                            exposing = true
                            exposeTimer.restart()
                        }
                    }

                    Button {
                        width: parent.width
                        height: 32
                        text: "RESET"

                        onClicked: {
                            progress = 0
                            exposing = false
                        }
                    }
                }
            }



            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    color: "#0b1622"
                    border.color: "#27485c"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                        text: pages[page].toUpperCase()
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 18
                        anchors.verticalCenter: parent.verticalCenter
                        text: "TOOL: LITHO-01  |  RECIPE: N7_GATE_LAYER  |  RETICLE: 5E22-4121"
                        color: "#9fb9c8"
                        font.pixelSize: 11
                    }
                }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: page

                    // PAGE 0: DASHBOARD
                    Rectangle {
                        color: "#07111b"

                        Row {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 14

                            Rectangle {
                                width: 430
                                height: parent.height
                                radius: 8
                                color: "#0b1622"
                                border.color: "#3c6175"

                                Text {
                                    x: 14
                                    y: 12
                                    text: "WAFER EXPOSURE MAP"
                                    color: "white"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                Rectangle {
                                    id: wafer
                                    width: 300
                                    height: 300
                                    radius: 150
                                    anchors.centerIn: parent
                                    color: "#0e2b3a"
                                    border.color: "#7adfff"
                                    border.width: 2
                                    clip: true

                                    Repeater {
                                        model: 17 * 17

                                        Rectangle {
                                            property int col: index % 17
                                            property int row: Math.floor(index / 17)

                                            width: 11
                                            height: 11
                                            x: 55 + col * 11
                                            y: 55 + row * 11

                                            color: {
                                                var dx = x + 5 - wafer.width / 2
                                                var dy = y + 5 - wafer.height / 2
                                                if (Math.sqrt(dx * dx + dy * dy) > 125)
                                                    return "transparent"

                                                if (index % 29 === 0)
                                                    return "#d85c5c"

                                                if (index % 17 === 0)
                                                    return "#d8c95c"

                                                return "#2387b8"
                                            }

                                            border.color: "#07121d"
                                            border.width: 1
                                        }
                                    }



                                    Rectangle {
                                        width: parent.width
                                        height: 14
                                        radius: 5
                                        color: "#9fffe3"
                                        opacity: exposing ? 0.36 : 0.08
                                        y: 28 + (progress / 100) * 225
                                        anchors.horizontalCenter: parent.horizontalCenter

                                        Behavior on y {
                                            NumberAnimation {
                                                duration: 180
                                                easing.type: Easing.InOutQuad
                                            }
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: progress + "%"
                                        color: "white"
                                        font.pixelSize: 34
                                        font.bold: true
                                    }
                                }
                            }



                            Rectangle {
                                width: 330
                                height: parent.height
                                radius: 8
                                color: "#0b1622"
                                border.color: "#3c6175"

                                Text {
                                    x: 14
                                    y: 12
                                    text: "SCANNER PARAMETERS"
                                    color: "white"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                Text {
                                    x: 16
                                    y: 55
                                    text:
                                        "PROCESS STATE\n" + (exposing ? "EXPOSING" : progress === 100 ? "COMPLETE" : "READY") +
                                        "\n\nDOSE\n" + Number(dose).toFixed(2) + " mJ/cm²" +
                                        "\n\nOVERLAY ERROR\n" + Number(overlay).toFixed(2) + " nm" +
                                        "\n\nFOCUS OFFSET\n-0.018 µm" +
                                        "\n\nVACUUM: STABLE\nRETICLE: LOCKED\nTRACK LINK: ONLINE"
                                    color: "#d7e8ef"
                                    font.pixelSize: 12
                                    lineHeight: 1.25
                                }
                            }

                            Rectangle {
                                width: parent.width - 790
                                height: parent.height
                                radius: 8
                                color: "#0b1622"
                                border.color: "#3c6175"

                                Text {
                                    x: 14
                                    y: 12
                                    text: "CELL INTELLIGENCE"
                                    color: "white"
                                    font.pixelSize: 15
                                    font.bold: true
                                }

                                Text {
                                    x: 16
                                    y: 55
                                    text:
                                        "Yield Estimate: 97.8%\n" +
                                        "Throughput: 142 WPH\n" +
                                        "Lens Health: 94%\n" +
                                        "Stage Stability: 98%\n" +
                                        "Thermal Drift: NORMAL\n\n" +
                                        "AI ANALYSIS:\nOverlay stable. No critical drift detected.\nRecommend unload after scan completion."
                                    color: "#9de8ff"
                                    font.pixelSize: 12
                                    lineHeight: 1.35
                                }
                            }
                        }
                    }

                    // PAGE 1: WAFER MAP
                    Rectangle {
                        color: "#07111b"

                        Text {
                            anchors.centerIn: parent
                            text: "FULL WAFER MAP VIEW\nNext: clickable die inspection"
                            color: "white"
                            font.pixelSize: 28
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // PAGE 2: BATCH QUEUE
                    Rectangle {
                        color: "#07111b"

                        Text {
                            x: 40
                            y: 40
                            text:
                                "BATCH QUEUE\n\n" +
                                "01  W01  DONE   PASS\n" +
                                "02  W02  DONE   PASS\n" +
                                "03  W03  DONE   PASS\n" +
                                "04  W04  " + (exposing ? "EXPOSING   SCAN" : "READY     --") + "\n" +
                                "05  W05  QUEUE  --\n" +
                                "06  W06  QUEUE  --\n" +
                                "07  W07  QUEUE  --"
                            color: "#d7e8ef"
                            font.pixelSize: 18
                            lineHeight: 1.4
                        }
                    }

                    // PAGE 3: SCANNER HEALTH
                    Rectangle {
                        color: "#07111b"

                        Text {
                            x: 40
                            y: 40
                            text:
                                "SCANNER HEALTH\n\n" +
                                "Illumination System: 96%\n" +
                                "Wafer Stage: 98%\n" +
                                "Reticle Stage: 95%\n" +
                                "Vacuum System: STABLE\n" +
                                "Thermal System: WATCH"
                            color: "#d7e8ef"
                            font.pixelSize: 18
                            lineHeight: 1.4
                        }
                    }

                    // PAGE 4: ALARMS
                    Rectangle {
                        color: "#07111b"

                        Text {
                            x: 40
                            y: 40
                            text:
                                "ALARMS\n\n" +
                                "Critical: 0\n" +
                                "Warnings: 1\n\n" +
                                "[WARN] Thermal drift approaching watch threshold\n" +
                                "[INFO] Reticle clamp locked\n" +
                                "[INFO] Chamber vacuum stable"
                            color: "#d7e8ef"
                            font.pixelSize: 18
                            lineHeight: 1.4
                        }
                    }
                }
            }
        }
    }
}