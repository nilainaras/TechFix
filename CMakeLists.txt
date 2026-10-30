cmake_minimum_required(VERSION 3.21)

project(TechFix VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

# ── Exécutable ───────────────────────────────────────────────────────────────
qt_add_executable(appTechFix
    src/main.cpp
)

# Icône de l'application sous Windows (techfix.rc.in → techfix.rc avec le bon chemin)
if(WIN32)
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/assets/windows/techfix.rc.in"
        "${CMAKE_CURRENT_BINARY_DIR}/techfix.rc"
        @ONLY
    )
    target_sources(appTechFix PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/techfix.rc")
endif()

set_target_properties(appTechFix PROPERTIES
    WIN32_EXECUTABLE TRUE        # pas de fenêtre console noire
    MACOSX_BUNDLE TRUE
)

# ── Singletons QML (Theme, UI, Fmt, Icons, AppData, Forms) ──────────────────────────
# Un singleton doit être déclaré AVANT qt_add_qml_module.
set_source_files_properties(
    qml/theme/Theme.qml
    qml/theme/UI.qml
    qml/theme/Fmt.qml
    qml/theme/Icons.qml
    qml/data/AppData.qml
    qml/data/Forms.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

# ── Module QML "TechFix" ─────────────────────────────────────────────────────
qt_add_qml_module(appTechFix
    URI TechFix
    VERSION 1.0
    QML_FILES
        # point d'entrée
        qml/Main.qml

        # thème et outils globaux
        qml/theme/Theme.qml
        qml/theme/UI.qml
        qml/theme/Fmt.qml
        qml/theme/Icons.qml

        # données fictives
        qml/data/AppData.qml
        qml/data/Forms.qml
        qml/data/DemoData.js

        # composants réutilisables
        qml/components/Txt.qml
        qml/components/Icon.qml
        qml/components/LogoMark.qml
        qml/components/AppButton.qml
        qml/components/IconButton.qml
        qml/components/Card.qml
        qml/components/CardHeader.qml
        qml/components/Tag.qml
        qml/components/StatusBadge.qml
        qml/components/Avatar.qml
        qml/components/SearchField.qml
        qml/components/FormField.qml
        qml/components/SelectField.qml
        qml/components/FilterChips.qml
        qml/components/Segmented.qml
        qml/components/ThemeToggle.qml
        qml/components/ToggleSwitch.qml
        qml/components/ProgressBar.qml
        qml/components/CountText.qml
        qml/components/EmptyState.qml
        qml/components/SoftShadow.qml
        qml/components/AppScrollBar.qml
        qml/components/PageScaffold.qml
        qml/components/CardGrid.qml
        qml/components/SidePanel.qml
        qml/components/FormPanel.qml
        qml/components/ConfirmDialog.qml
        qml/components/ToastHost.qml
        qml/components/Stepper.qml
        qml/components/ProgressDots.qml
        qml/components/RepairRow.qml
        qml/components/RepairCard.qml
        qml/components/KpiCard.qml
        qml/components/InfoLine.qml
        qml/components/SettingRow.qml
        qml/components/Tip.qml

        # graphiques (QML pur)
        qml/charts/ChartUtils.js
        qml/charts/Sparkline.qml
        qml/charts/AreaChart.qml
        qml/charts/BarChart.qml
        qml/charts/DonutChart.qml
        qml/charts/HBarList.qml

        # structure de l'écran
        qml/layout/Sidebar.qml
        qml/layout/SidebarItem.qml
        qml/layout/TopBar.qml
        qml/layout/NotificationsPopup.qml
        qml/layout/SearchPopup.qml

        # pages
        qml/pages/DashboardPage.qml
        qml/pages/RepairsPage.qml
        qml/pages/RepairDetailPage.qml
        qml/pages/ClientsPage.qml
        qml/pages/DevicesPage.qml
        qml/pages/TechniciansPage.qml
        qml/pages/InvoicesPage.qml
        qml/pages/StatsPage.qml
        qml/pages/HistoryPage.qml
        qml/pages/SettingsPage.qml
        qml/pages/AboutPage.qml
)

# ── Ressources : polices et logo ─────────────────────────────────────────────
# Accessibles dans le code sous ":/assets/..." (C++) ou "qrc:/assets/..." (QML).
qt_add_resources(appTechFix "techfix_assets"
    PREFIX "/"
    FILES
        assets/fonts/Inter_400Regular.ttf
        assets/fonts/Inter_500Medium.ttf
        assets/fonts/Inter_600SemiBold.ttf
        assets/fonts/Inter_700Bold.ttf
        assets/fonts/PlusJakartaSans_600SemiBold.ttf
        assets/fonts/PlusJakartaSans_700Bold.ttf
        assets/fonts/PlusJakartaSans_800ExtraBold.ttf
        assets/logo/techfix-icon.png
        assets/logo/techfix-logo.svg
)

target_link_libraries(appTechFix PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appTechFix
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
