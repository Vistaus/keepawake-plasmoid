import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.batterymonitor

PlasmoidItem {
    id: root

    readonly property bool isAwakeEnabled: inhibition.isManuallyInhibited
    readonly property bool isInEditMode: Plasmoid.containment?.corona?.editMode ?? false
    readonly property bool shouldHide: !Plasmoid.configuration.alwaysShowIcon && !isAwakeEnabled && !isInEditMode

    readonly property real idleOpacity: 0.6

    Plasmoid.status: shouldHide ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

    function toggleAwake(): void {
        if (isAwakeEnabled) {
            inhibition.uninhibit();
        } else {
            inhibition.inhibit(i18n("Keep Awake widget"));
        }
    }

    InhibitionControl {
        id: inhibition
    }

    preferredRepresentation: compactRepresentation
    fullRepresentation: Item {}  // no popup: clicking just toggles

    toolTipMainText: Plasmoid.title
    toolTipSubText: isAwakeEnabled ? i18n("Sleep and screen locking are blocked")
                                   : i18n("Sleep and screen locking are allowed")

    compactRepresentation: Component {
        Kirigami.Icon {
            readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

            Layout.preferredWidth:  isVertical ? width : height
            Layout.preferredHeight: isVertical ? width : height

            source: root.isAwakeEnabled ? Plasmoid.configuration.iconActive : Plasmoid.configuration.iconInactive

            opacity: root.isAwakeEnabled ? 1.0 : root.idleOpacity
            active: mouseArea.containsMouse

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleAwake()
            }
        }
    }
}
