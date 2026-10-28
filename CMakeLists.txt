cmake_minimum_required(VERSION 3.21)

project(techfix VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core Gui Quick QuickControls2 QuickLayouts Svg Qml
)

add_executable(techfix
    main.cpp
    src/ui/components/CustomScrollBar.qml
)

qt_add_resources(techfix "qml"
    PREFIX "/"
    FILES
        Main.qml
        src/ui/pages/DashboardPage.qml
        src/ui/pages/ClientsPage.qml
        src/ui/pages/AppareilsPage.qml
        src/ui/pages/ReparationsPage.qml
        src/ui/pages/TechniciensPage.qml
        src/ui/pages/InterventionsPage.qml
        src/ui/pages/ReparationDetailPage.qml
        src/ui/components/StatCard.qml
        src/ui/components/EntityCard.qml
        src/ui/components/ModalDialog.qml
        src/ui/components/StatusBadge.qml
        src/ui/components/SearchBar.qml
        src/ui/components/FilterChip.qml
        src/ui/components/FormField.qml
        src/ui/components/Timeline.qml
        src/ui/components/Sidebar.qml
        src/ui/components/TopBar.qml
        src/ui/viewmodels/DashboardViewModel.qml
        src/ui/viewmodels/ClientViewModel.qml
        src/ui/viewmodels/AppareilViewModel.qml
        src/ui/viewmodels/TechnicienViewModel.qml
        src/ui/viewmodels/ReparationViewModel.qml
        src/ui/viewmodels/InterventionViewModel.qml
        src/ui/theme/Theme.qml
        src/ui/theme/Colors.qml
        src/ui/theme/Fonts.qml
        src/ui/theme/Spacing.qml
        src/ui/theme/Effects.qml
        src/ui/utils/Formatter.qml
        src/ui/utils/Validator.qml
        src/ui/utils/Constants.qml
        src/ui/dialogs/NewClientDialog.qml
        src/ui/dialogs/EditClientDialog.qml
        src/ui/dialogs/NewAppareilDialog.qml
        src/ui/dialogs/NewTechnicienDialog.qml
        src/ui/dialogs/NewReparationDialog.qml
        src/ui/dialogs/NewInterventionDialog.qml
        src/ui/dialogs/ConfirmDeleteDialog.qml
        # === TOUTES LES ICÔNES SVG ===
        assets/icons/dashboard.svg
        assets/icons/users.svg
        assets/icons/laptop.svg
        assets/icons/wrench.svg
        assets/icons/user-cog.svg
        assets/icons/clipboard-list.svg
        assets/icons/search.svg
        assets/icons/sun.svg
        assets/icons/moon.svg
        assets/icons/loader.svg
        assets/icons/check-circle.svg
        assets/icons/dollar-sign.svg
        assets/icons/alert-triangle.svg
        assets/icons/plus-circle.svg
        assets/icons/edit.svg
        assets/icons/phone.svg
        assets/icons/trash.svg
        assets/icons/clock.svg
        assets/icons/calendar.svg
        assets/icons/truck.svg
        assets/icons/circle-dot.svg
        assets/icons/chevron-right.svg
        assets/icons/x.svg
        assets/icons/menu.svg
        # === AUTRES ASSETS ===
        assets/images/logo.svg
        assets/data/mock_data.json
)

target_link_libraries(techfix PRIVATE
    Qt6::Core Qt6::Gui Qt6::Quick Qt6::QuickControls2
    Qt6::QuickLayouts Qt6::Svg Qt6::Qml
)