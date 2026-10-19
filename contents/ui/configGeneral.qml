import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: root

    property string cfg_iconActive: Plasmoid.configuration.iconActive
    property string cfg_iconInactive: Plasmoid.configuration.iconInactive
    property alias cfg_alwaysShowIcon: alwaysShowIconCheckBox.checked

    property string cfg_iconActiveDefault
    property string cfg_iconInactiveDefault

    readonly property real hintOpacity: 0.7

    component IconPicker: RowLayout {
        id: picker

        property string currentIcon
        property string defaultIcon
        readonly property bool isDefault: currentIcon === defaultIcon
        signal picked(string iconName)

        spacing: Kirigami.Units.smallSpacing

        QQC2.Button {
            implicitWidth: Kirigami.Units.iconSizes.large + Kirigami.Units.largeSpacing * 2
            implicitHeight: implicitWidth

            onClicked: iconDialog.open()

            Kirigami.Icon {
                anchors.centerIn: parent
                width: Kirigami.Units.iconSizes.large
                height: width
                source: picker.currentIcon
            }

            KIconThemes.IconDialog {
                id: iconDialog
                onIconNameChanged: picker.picked(iconName)
            }
        }

        QQC2.Button {
            icon.name: "edit-reset"
            display: QQC2.AbstractButton.IconOnly
            text: i18n("Reset to default")
            enabled: !picker.isDefault
            onClicked: picker.picked(picker.defaultIcon)

            QQC2.ToolTip.text: text
            QQC2.ToolTip.visible: hovered
            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
        }
    }

    Kirigami.FormLayout {
        anchors.fill: parent

        IconPicker {
            Kirigami.FormData.label: i18n("Sleep is blocked:")
            currentIcon: root.cfg_iconActive
            defaultIcon: root.cfg_iconActiveDefault
            onPicked: iconName => root.cfg_iconActive = iconName
        }

        IconPicker {
            Kirigami.FormData.label: i18n("Sleep is allowed:")
            currentIcon: root.cfg_iconInactive
            defaultIcon: root.cfg_iconInactiveDefault
            onPicked: iconName => root.cfg_iconInactive = iconName
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: alwaysShowIconCheckBox
            Kirigami.FormData.label: i18n("Visibility:")
            text: i18n("Always show icon")
        }

        QQC2.Label {
            text: i18n("Keep the icon in the panel, even when sleep is allowed.")
            font: Kirigami.Theme.smallFont
            opacity: root.hintOpacity
            wrapMode: Text.Wrap
        }
    }
}
