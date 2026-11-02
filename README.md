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
- FORUM: `https://forum.nintendo-online.de/`

Das Forum ist als aktueller Bereich gelb markiert. Das Logo liegt als lokales Theme-Asset unter `assets/logo.svg`.

## Fonts und Dark Mode

Die Component bündelt dieselben DM-Sans- und DM-Mono-Webfonts wie Nintendo-Online als lokale Theme-Assets (`assets/dm-sans-*.woff2`, `assets/dm-mono-*.woff2`). Damit stimmen Font-Familien und Gewichte des Brandings (`DM Sans`, 900) sowie der Navigation (`DM Mono`, 500) mit der Hauptseite überein — ohne externe Abhängigkeit und ohne CORS-Einschränkungen.

Im hellen Modus folgen Header und Schrift der Vorlage mit Weiß und `#454545`; im Dark Mode nutzen sie `hsl(0 0% 13.3%)` und `hsl(210 40% 98%)`. Umgesetzt wird das über `light-dark(...)`, das dem von Discourse gesetzten `color-scheme` folgt – nicht der Browser-Präferenz `prefers-color-scheme`. Die Akzentfarbe bleibt `#FFC805`.

## Mobiles Verhalten

Unter `1092px` (dem `lg`-Breakpoint der Nintendo-Online-Vorlage) wird die breite Navigation ausgeblendet und ist dann nur noch über die Sidebar erreichbar. Suche, Benachrichtigungen, Avatar, Login und der native Sidebar-/Hamburger-Trigger verbleiben im Core-Header.

Die Nintendo-Online-Links werden über die native Sidebar-API in eine eigene Gruppierung namens „Nintendo-Online“ aufgenommen. Enthalten sind `News`, `Spiele`, `Reviews`, `Reports`, `Release-Kalender` und `Podcast` – jeweils mit Icon. `Forum` wird bewusst nicht in die Sidebar übernommen, da es bereits das aktuelle Forum-Ziel ist. Das funktioniert für angemeldete und anonyme Besucher, sofern die Discourse-Sidebar aktiv ist.

Bei Instanzen, die die Sidebar komplett deaktiviert haben und ausschließlich das Legacy-Hamburger-Menü einsetzen, ergänzt die Component keine Links in dieses Menü. Dafür existiert kein gleichwertig stabiler öffentlicher Erweiterungspunkt; ein DOM-Hack wird bewusst nicht eingesetzt.

## Verwendete Discourse APIs

- `api.renderInOutlet("header-contents__before", NoGlobalHeader)`: ergänzt den mehrfach belegbaren offiziellen Header-Outlet. Flex-Order positioniert den Brand-Bereich neben dem nativen Sidebar-Trigger.
- `api.addSidebarSection(...)`: ergänzt die eigene Sidebar-Gruppierung „Nintendo-Online“ mit Links zu den globalen Zielen.
- `api.renderInOutlet("sidebar-footer-actions", NoCookieSettings)`: ergänzt bei aktivem Nintendo-GAM-Netzwerk den Button „Cookie-Einstellungen“. Er öffnet Googles vorhandene CMP über `CONSENT_API_READY` und `showRevocationMessage()`, mit Lade- und Fehlerzustand. Auf Seiten ohne Anzeigen kann der Klick GPT für die CMP starten, ohne selbst Anzeigenplätze anzulegen oder Anzeigen anzufordern. Die Werbeauslieferung bleibt beim offiziellen Discourse Advertising Plugin.

Der Core-Logo-Bereich wird per CSS ausgeblendet; die nativen Header-Icons und -Menüs werden nicht verändert. Das umfasst Suche, Benachrichtigungen, Chat, Login, Avatar und Staff-/Admin-Funktionen.

## Bekannte Einschränkungen

- Die Header-Höhe beträgt `72px` (4.5rem).
- Beim Scrollen innerhalb eines Themas zeigt Discourse den Topic-Titel im Header. Damit dieser Platz bekommt, blendet die Component in diesem Zustand den Brand-Text und die Navigation aus — nur das Logo bleibt sichtbar. Oben im Thema (nicht gescrollt) sind Brand und Navigation wie gewohnt sichtbar.
- Auf extrem schmalen Desktop-Ansichten oder bei starkem Browser-Zoom kann der Core den Topic-Titel gegenüber dem Branding priorisieren. Die Header-Controls bleiben dabei nutzbar.

## Update-Hinweise

Die Component verwendet den aktuellen Glimmer-Header und offizielle APIs, keine veralteten Widget-APIs oder Selektor-basierte DOM-Manipulation. Bei Discourse-Updates sollten besonders `header-contents__before` und `addSidebarSection` gegen die jeweiligen Release Notes geprüft werden.
