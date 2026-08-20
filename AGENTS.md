# AGENTS.md

## Zweck und Geltungsbereich

Dieses Repository enthält eine **Discourse Theme Component**, die den Header von Nintendo-Online.de im Discourse-Forum nachbildet. Diese Anleitung gilt für das gesamte Repository.

Die Component ergänzt den nativen Discourse-Header. Sie darf keinen zweiten Header erzeugen und `.d-header` nicht ersetzen. Native Discourse-Funktionen wie Sidebar-Trigger, Suche, Chat, Benachrichtigungen, Login, Avatar sowie Staff-/Admin-Menüs müssen erhalten und bedienbar bleiben.

## Architektur

- `about.json` ist das Manifest der Theme Component. Theme-Assets müssen dort registriert werden, bevor sie in SCSS über Discourse-Variablen wie `$no-logo` verwendet werden.
- `javascripts/discourse/api-initializers/no-header.gjs` ist der Integrationseinstieg. Er registriert den Header über `api.renderInOutlet("header-contents__before", ...)` und die mobilen Links über `api.addSidebarSection(...)`.
- `javascripts/discourse/components/no-global-header.gjs` enthält das Glimmer-Template für Logo, Markenname und Desktop-Navigation.
- `common/common.scss` enthält gemeinsame Tokens, lokale Fonts, Header-Reihenfolge, Fokuszustände und das Verhalten beim gescrollten Topic-Titel.
- `desktop/desktop.scss` enthält die Desktop-Breakpoints. Die Navigation wird ab `1092px` eingeblendet; Logo und Titel skalieren ab `768px`.
- `mobile/mobile.scss` enthält ausschließlich mobile Ergänzungen, die nicht bereits in `common.scss` abgedeckt sind.
- `assets/` enthält das Logo und die lokal ausgelieferten DM-Sans-/DM-Mono-Fonts. Keine externen Font-CDNs hinzufügen.
- `README.md` beschreibt Installation, sichtbares Verhalten, feste Ziel-URLs und bekannte Grenzen. Bei einer Änderung dieser Verträge muss die README im selben Change aktualisiert werden.

## Unverhandelbare UI-Verträge

- Offizielle Discourse-Erweiterungspunkte verwenden. Keine DOM-Manipulation, veralteten Widget-APIs oder MutationObserver-Hacks einführen.
- Den Core-Logo-Bereich darf die Component ausblenden; Core-Controls und ihre Events dürfen nicht überschrieben oder nachgebaut werden.
- Der Desktop-Link `Forum` bezeichnet die aktuelle Seite mit `aria-current="page"` und gelber Schrift.
- Unter `1092px` bleibt die breite Navigation verborgen. Die externen Ziele werden stattdessen über die native Sidebar-Sektion „Nintendo-Online“ angeboten.
- Wenn Discourse in `.extra-info-wrapper` einen gescrollten Topic-Titel zeigt, werden Markenname und Navigation ausgeblendet; das Logo bleibt sichtbar und der Topic-Titel erhält Vorrang.
- Light/Dark Mode folgt dem von Discourse gesetzten `color-scheme` über `light-dark(...)`, nicht ausschließlich `prefers-color-scheme`.
- Die Markenfarbe ist `#ffc805`; gemeinsame Werte als `--no-header-*` Custom Properties pflegen.
- Tastatur-Fokus muss sichtbar bleiben. Neue Icons oder rein dekorative Elemente brauchen passende `aria-*`-Semantik; Navigationsbereiche brauchen einen zugänglichen Namen.

## Implementierungsstil

- JavaScript/Glimmer im bestehenden `.gjs`-Stil schreiben und Discourse-Imports (`discourse/...`) beibehalten.
- Externe Linkdaten zentral im Initializer halten, statt dieselben Sidebar-Links einzeln zu duplizieren.
- Bestehende Klassen mit dem Präfix `no-global-header` und Tokens mit `--no-header-` fortführen.
- Responsive Regeln in den kleinsten passenden Scope legen: gemeinsam in `common.scss`, Desktop-Abweichungen in `desktop/desktop.scss`, mobile Abweichungen in `mobile/mobile.scss`.
- Discourse-Theme-Asset-Referenzen verwenden; keine Annahmen über Next.js, npm-Bundling oder einen eigenen Webserver treffen.
- Änderungen klein halten. Besonders bei Flex-Reihenfolge, Breiten, `z-index`, Header-Höhe und `:has(.extra-info-wrapper)` auf Seiteneffekte in Topic-, Login- und anonymen Zuständen achten.
- Keine URLs, Breakpoints, Versionsanforderungen oder API-Verträge erfinden. Bei Änderungen zuerst gegen Repository und aktuelle Discourse-Dokumentation prüfen.

## Lokale Befehle und Teststatus

Abhängigkeiten werden über npm verwaltet:

```bash
npm ci
```

Playwright kann direkt aufgerufen werden:

```bash
npx playwright test
npx playwright test --project=chromium
```

Wichtig: `package.json` definiert derzeit keine npm-Scripts. `tests/example.spec.ts` und `playwright.config.ts` sind noch das unveränderte Playwright-Scaffold und testen `playwright.dev`, nicht diese Discourse Theme Component. Ein erfolgreicher Lauf ist daher **kein** Nachweis für die Header-Funktion. Tests dürfen erst als Komponenten-Regressionstest bezeichnet werden, wenn sie gegen eine konfigurierte Discourse-Testinstanz und die tatsächlich installierte Component laufen.

Es gibt aktuell keinen lokalen Compiler, Linter oder eigenständigen Discourse-Dev-Server in diesem Repository. Nicht vorhandene Prüfungen nicht als erfolgreich melden.

## Verifikation für Header-Änderungen

Mindestens statisch prüfen:

```bash
git diff --check
git diff -- AGENTS.md README.md about.json javascripts common desktop mobile tests
```

Für eine belastbare visuelle Prüfung die Component in einer kompatiblen Discourse-Instanz (mindestens die in `about.json` angegebene Version) installieren oder aktualisieren und folgende Zustände kontrollieren:

1. Desktop über `1092px`: Logo, Titel, Navigation, aktives Forum und alle nativen Header-Controls.
2. Breiten zwischen `768px` und `1091px` sowie unter `768px`: keine breite Navigation, kein Überlauf, native Sidebar erreichbar.
3. Angemeldet und anonym: Sidebar-Sektion und jeweils verfügbare Core-Controls.
4. Heller und dunkler Discourse-Farbmodus: Textkontrast, Logo, Hover- und Fokuszustände.
5. Topic oben und nach dem Scrollen: `.extra-info-wrapper` hat Vorrang, während das Logo sichtbar bleibt.
6. Tastaturbedienung und Browser-Zoom: sichtbare Fokusmarkierung, keine verdeckten Bedienelemente.

Bei Änderungen an Sidebar-Links zusätzlich Ziel-URL, Beschriftung, Tooltip und Discourse-Icon-Namen prüfen. Bei Änderungen an Fonts oder Logo müssen Asset-Datei, `about.json`-Schlüssel und SCSS-Variable zusammenpassen.

## Abschlusskriterien

- Der Diff ist auf die angeforderte Änderung begrenzt; generierte Reports, `node_modules/` und `.playwright-mcp/` werden nicht committed.
- `git diff --check` ist sauber.
- README und Manifest stimmen mit dem implementierten Verhalten überein.
- Statische Prüfung und echte Laufzeit-/Browserprüfung werden im Ergebnis klar getrennt benannt.
- Ohne konfigurierte Discourse-Instanz keine visuelle oder funktionale Produktionsreife behaupten.
