# Nintendo-Online Forum

Der native Discourse-Header und seine Bedienelemente bleiben erhalten. Branding und globale Links ergänzen die bestehenden Erweiterungspunkte.

Bei aktivem GAM-Netzwerk 23326979771 steht „Cookie-Einstellungen“ unter den nativen Seitenleistenaktionen. Die Schaltfläche öffnet die bereits veröffentlichte Google-CMP und zeigt Lade-/Fehlerzustände. Sie legt keine Anzeigenplätze an, ändert keine Größen und fordert keine Anzeigen an. Die Auslieferung bleibt vollständig beim offiziellen Advertising Plugin.

Die Ergänzung verwendet die vorhandenen Discourse-Farbvariablen, bleibt in schmalen Seitenleisten umbrechbar und erhält die nativen Fokuszustände. Der mobile Weg über das Seitenleistenmenü ist separat zu prüfen.

Der Cookie-Link verändert weder `disableInitialLoad` noch den Zustand der GPT-Dienste. Ein bei Bedarf geladenes GPT erhält das Netzwerk über den dokumentierten `network-code`-Parameter, damit Seiten ohne Anzeigen keine globalen Ladeeinstellungen für spätere Navigationen setzen.

Beim ersten Klick ohne bereits geladene CMP wartet die Schaltfläche auf die tatsächliche GoogleFC-API und reiht den Öffnungsaufruf anschließend einmal über `CONSENT_API_READY` ein. Bereits eingebundene GPT-Skripte werden wiederverwendet. Ein begrenzter Ladezustand von höchstens 20 Sekunden sowie aufgeräumte Timer verhindern hängenbleibende oder verspätete Dialogaufrufe.
