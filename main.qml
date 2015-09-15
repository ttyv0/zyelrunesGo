import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2

Window {
  id: mainWindow
  width: 800
  height: 600
  title: "ZyElRunes"

  GridLayout {
    id: mainGrid
    anchors.fill: parent
    GridView {
      id: runesGridView
      width: mainWindow.width - gridLayout.width
      anchors.top: parent.top
      height: gridLayout.height
      cellHeight: 50
      cellWidth: 50
      interactive: false
      model: runesModel.len
      delegate: Item {
        property string runename: runesModel.name(index)
        width: 50
        height: columnItem.height
        Column {
          id: columnItem
          anchors.fill: parent
          Rectangle {
            id: rectImage
            width: 28
            height: 28
            Image {
              id: runeImage
              anchors.fill: parent.fill
              source: "images/" + runename + ".png"
            }
          }
          Text {
            text: runename
          }
          spacing: 1
        }
      }
    }
    GridLayout {
      id: gridLayout
      anchors.top: parent.top
      anchors.right: parent.right
      columnSpacing: 10
      rowSpacing: 12
      columns: 2
      Label {
        id: levelLabel
        text: qsTr("Level: ") + levelSlider.value
      }
      Slider {
        id: levelSlider
        stepSize: 1
        maximumValue: 255
        minimumValue: 1
        value: 1
      }
      Label {
        id: soketLabel
        text: soketsSlider.visible ? qsTr("Sokets: ") + (soketsSlider.value === 0 ? "" : soketsSlider.value + 1) : qsTr("Sokets: ")
      }
      ComboBox {
        id: soketsBox
        model: [" ", "2", "3", "4", "5", "6"]
        onActivated: { soketsSlider.value = index }
        visible: false
      }
      Slider {
        id: soketsSlider
        stepSize: 1
        maximumValue: 5
        minimumValue: 0
        value: 0
        tickmarksEnabled: true
        onValueChanged: { soketsBox.currentIndex = soketsSlider.value }
      }
      Label {
        id: thingLabel
        text: qsTr("Things:")
      }
      ComboBox {
        id: thingsBox
      }
      Label {
        id: charLabel
        text: qsTr("Character:")
      }
      ComboBox {
        id: charBox
        model: [ qsTr("Any Hero"),
          qsTr("Amazon"),
          qsTr("Assasin"),
          qsTr("Necromancer"),
          qsTr("Barbarian"),
          qsTr("Paladin"),
          qsTr("Sorceress"),
          qsTr("Druid"),
          qsTr("All Heroes")]
      }
      CheckBox {
        id: sortBox
        text: qsTr("Sort level")
      }
      Button {
        id: findButton
        text: qsTr("Find!")
        onClicked: {soketsBox.visible = !soketsBox.visible; soketsSlider.visible = !soketsSlider.visible}
      }
    }
    TableView {
      id: table
      anchors.top: runesGridView.bottom
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      model: runewordModel.len
      Layout.minimumWidth: runesGridView.width
      TableViewColumn {
          title: qsTr("Item")
          delegate: Item {
              Text {
                  anchors.verticalCenter: parent.verticalCenter
                  color: styleData.textColor
                  elide: styleData.elideMode
                  text: runewordModel.items(styleData.row)
              }
          }
      }
      TableViewColumn {
          title: qsTr("Level")
          delegate: Item {
              Text {
                  anchors.verticalCenter: parent.verticalCenter
                  color: styleData.textColor
                  elide: styleData.elideMode
                  text: runewordModel.level(styleData.row)
              }
          }
      }
      TableViewColumn {
          title: qsTr("Runes")
          delegate: Item {
              Text {
                  anchors.verticalCenter: parent.verticalCenter
                  color: styleData.textColor
                  elide: styleData.elideMode
                  text: runewordModel.runes(styleData.row)
              }
          }
      }
    }

    Text {
        id: text1
        text: qsTr("Text")
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: gridLayout.bottom
        anchors.left: table.right
        font.pixelSize: 12
    }
  }
}
