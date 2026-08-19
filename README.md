# Nintendo-Online Discourse Header

Eine Discourse Theme Component, die den nativen Discourse-Header um Nintendo-Online-Branding und globale Navigation erweitert. Sie erzeugt keinen zweiten Header und ersetzt nicht `.d-header`.

## Installation

1. Das Repository in einen Git-Hoster pushen.
2. In Discourse zu **Admin -> Customize -> Themes -> Install -> From a Git repository** wechseln.
3. Repository-URL eintragen, installieren und die Component dem aktiven Theme zuordnen.

Die Component erfordert Discourse `3.4.0` oder neuer.

## Konfiguration

Die Desktop-Navigation enthält fest diese Ziele:

- NEWS: `https://nintendo-online.de/news`
- SPIELE: `https://nintendo-online.de/games`
- REVIEWS: `https://nintendo-online.de/reviews`
- REPORTS: `https://nintendo-online.de/reports`
- FORUM: `https://forum.nintendo-online.de/`

Das Forum ist mit einer gelben Unterstreichung als aktiver Bereich markiert. Das Logo liegt als lokales Theme-Asset unter `assets/logo.svg`.

## Fonts und Dark Mode

Die Component lädt dieselben DM-Sans- und DM-Mono-Webfonts wie Nintendo-Online direkt von `nintendo-online.de`. Damit stimmen Font-Familien und Gewichte des Brandings (`DM Sans`, 900) sowie der Navigation (`DM Mono`, 500) mit der Hauptseite überein.

Die helle Navigation folgt der Referenzfarbe `#454545`. Über Discourse' aktiven Color-Scheme-Status wechselt sie im Dark Mode auf die Referenzfarbe `#F8FAFC`; dafür wird nicht `prefers-color-scheme` verwendet. Die Akzentfarbe bleibt `#FFC805`.

## Mobiles Verhalten

Unter `1024px` wird die breite Nintendo-Online-Navigation ausgeblendet. Suche, Benachrichtigungen, Avatar, Login und der native Sidebar-/Hamburger-Trigger verbleiben im Core-Header.

Die fünf Nintendo-Online-Links werden mit der nativen Sidebar-API in den Community-„More…“-Bereich aufgenommen. Das funktioniert für angemeldete und anonyme Besucher, sofern die Discourse-Sidebar aktiv ist.

Bei Instanzen, die die Sidebar komplett deaktiviert haben und ausschließlich das Legacy-Hamburger-Menü einsetzen, ergänzt die Component keine Links in dieses Menü. Dafür existiert kein gleichwertig stabiler öffentlicher Erweiterungspunkt; ein DOM-Hack wird bewusst nicht eingesetzt.

## Verwendete Discourse APIs

- `api.renderInOutlet("header-contents__before", NoGlobalHeader)`: ergänzt den mehrfach belegbaren offiziellen Header-Outlet. Flex-Order positioniert den Brand-Bereich neben dem nativen Sidebar-Trigger.
- `api.addCommunitySectionLink(...)`: ergänzt die Links in der nativen Community-Sidebar.

Der Core-Logo-Bereich wird per CSS ausgeblendet; die nativen Header-Icons und -Menüs werden nicht verändert. Das umfasst Suche, Benachrichtigungen, Chat, Login, Avatar und Staff-/Admin-Funktionen.

## Bekannte Einschränkungen

- `DM Sans` und `DM Mono` werden nicht zusätzlich geladen. Sind sie im Host-Theme verfügbar, werden sie genutzt; ansonsten greifen die definierten System-Fallbacks. Das vermeidet externe Font-Requests und funktioniert auch mit restriktiven Content-Security-Policies.
- Auf extrem schmalen Desktop-Ansichten oder bei starkem Browser-Zoom kann der Core den Topic-Titel gegenüber dem Branding priorisieren. Die Header-Controls bleiben dabei nutzbar.

## Update-Hinweise

Die Component verwendet den aktuellen Glimmer-Header und offizielle APIs, keine veralteten Widget-APIs oder Selektor-basierte DOM-Manipulation. Bei Discourse-Updates sollten besonders `home-logo-wrapper` und `addCommunitySectionLink` gegen die jeweiligen Release Notes geprüft werden.
