import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import QtMultimedia 5.15

Window {
    id: window
    width: 1000
    height: 800
    visible: true
    title: qsTr("Video Player")

    Rectangle {

        width: parent.width
        height: parent.height


        Video{
           id:videoPlayer
           fillMode: VideoOutput.PreserveAspectCrop   //fill and fit the window
           anchors.fill: parent // fill the entire window
           source: ""
           autoPlay: false

           property bool videoPaused: false


           onPlaybackStateChanged: {
               videoPaused = playbackState === MediaPlayer.PausedState;
               choosebtn.visible = playbackState === MediaPlayer.StoppedState;
           }

           onVideoPausedChanged: {
               choosebtn.visible = playbackState === MediaPlayer.StoppedState;
           }
        }

        Rectangle {
            id: choosebtn
            width: 100
            height: 40
            color: "#3498db"
            radius: 10
            border.color: "#2980b9"
            border.width: 1
            anchors.centerIn: parent


            Text {
                anchors.centerIn: parent
                text: "Choose File"
                color: "white"
                font.pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    fileDialog.visible = true
                }

                FileDialog {
                    id: fileDialog
                    title: qsTr("Select a video file")
                    visible: false
                    onAccepted: {
                        fileDialog.visible = false;
                        videoPlayer.source = "C:/Users/fasil/Downloads/test.wmv";
                        videoPlayer.play();
                        console.log(fileDialog.selectedFile)
                    }

                    onRejected: {
                        console.log("canceled")
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 50
            color: "#333333" // for control bar
            anchors.bottom: parent.bottom

            //play + pause btns without QtQuick Controls

            Rectangle {
                id: playPauseBtn
                width: 50
                height: 30
                color: "#37CDAE"  //bg for play and pause btns
                radius: 15
                border.color: "white"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                z: 2
                //icons for play and pause btns

                Text {
                    anchors.centerIn: parent
                    text: videoPlayer.playbackState === MediaPlayer.PlayingState ? "\u275A\u275A" : "\u25B6"
                    font.pixelSize: 15
                    color: "white"

                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(videoPlayer.playbackState === MediaPlayer.PlayingState) {
                            videoPlayer.pause()
                    }
                        else {
                            videoPlayer.play()
                        }
                    }


                }
            }
            //seek bar

            Rectangle {
                id: seekBar
                width: parent.width -120
                height: 25
                color: "white"
                radius: 2.5
                anchors.centerIn: parent
                anchors.right: playPauseBtn.right
                z: 1

                Rectangle {
                    id: seekProgress
                    width: (videoPlayer.position / videoPlayer.duration) * parent.width
                    height: parent.height
                    color: "#37CDAE"  //progress bar color
                    radius: 2.5

                }

               Rectangle {
                    id: dragger
                    width: 20
                    height: 20
                    color: "#B2FFC0"
                    radius: width / 2
                    anchors.verticalCenter: parent.verticalCenter
                    x: (videoPlayer.position / videoPlayer.duration) * (parent.width - 120) - width / 2;
                    visible: true
                }

                    MouseArea {
                         id: draggerArea
                         width: parent.width
                         height: parent.height
                         anchors.fill: parent
                         onClicked: {
                            var seekPosition = mouse.x / parent.width;
                            videoPlayer.seek(seekPosition * videoPlayer.duration);
                         }

                         onPressed: {
                           draggerArea.drag.target = dragger;
                         }

                    }
                }
            }
        }

        //update position of seek Bar

            Connections {
                target: videoPlayer
                onPositionChanged: {
                    if(videoPlayer.videoAvailable) {
                        seekProgress.width = (videoPlayer.position / videoPlayer.duration) * (parent.width - 120);
                        dragger.x = (videoPlayer.position / videoPlayer.duration) * (parent.width - 120) - dragger.width / 2;

                    }
                }
            }
        }
