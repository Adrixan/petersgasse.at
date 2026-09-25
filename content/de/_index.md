+++
identifier = 'start'
date = "2019-02-28"
+++

<div class="video-container">
  <video class="index-video" src="/Schulvideo_480p.mp4" autoplay muted defaultMuted playsinline webkit-playsinline loop controls preload="auto" poster="/images/schulvideo-poster.webp">
    <source src="/Schulvideo_480p.mp4" type="video/mp4">
    Ihr Browser unterstützt dieses Videoformat leider nicht.
  </video>
  <script>
    (function() {
      var v = document.querySelector('video.index-video');
      if (v) {
        v.defaultMuted = true;
        v.muted = true;
        var p = v.play();
        if (p && p.catch) {
          p.catch(function() {
            var resume = function() {
              v.play();
              window.removeEventListener('touchstart', resume, { passive: true });
              window.removeEventListener('scroll', resume, { passive: true });
              window.removeEventListener('click', resume);
            };
            window.addEventListener('touchstart', resume, { passive: true, once: true });
            window.addEventListener('scroll', resume, { passive: true, once: true });
            window.addEventListener('click', resume, { once: true });
          });
        }
      }
    })();
  </script>
</div>

Das BRG Petersgasse ist ein Realgymnasium mit Englisch als erster lebender Fremdsprache und einem mathematisch-naturwissenschaftlichen Schwerpunkt in der Oberstufe.

# Aktuelle Aussendungen
* [1. Mitteilungsblatt 2026/27](</1. Mitteilungsblatt.pdf>)
* [Hinweise und Infos zur Nachmittagsbetreuung](</Nachmittagsbetreuung.pdf>)
* [Juniorkursbuch](</Juniorkursbuch.pdf>)
* [Anleitung zur Verwendung von WebUntis](</infoblatt_webuntis.pdf>)

# Wichtige Links

* [WebUntis](https://petersgasse.webuntis.com/WebUntis/?school=petersgasse#/basic/login)
* [Webmail OUTLOOK](http://www.outlook.com/petersgasse.at)
* [EDUVIDUAL-Lernplattform](https://www.eduvidual.at/local/eduvidual/pages/login.php)
* [Schulbibliothek](https://petersgasse.at/index.php/links/30-allgemein-schulbibliothek/46-schulbibliothek)
* [Portal](https://www.portal.at/pat/public/loginform?target=https://www.portal.at/pat/private&smquerydata=&smauthreason=0)

# Wichtige Dokumente zur Anmeldung
* [Aufnahmeansuchen 2.-8. Klasse](</Aufnahmeansuchen 2. - 8. Klasse.pdf>)

# Wichtige Infos für das Leben im Schulgebäude

* [Hausordnung](</Hausordnung.pdf>)
* [Verhaltensvereinbarungen](/Verhaltensvereinbarungen.pdf)
* [Gebrauch elektronischer Geräte](</Gebrauch elektronischer Geräte.pdf>)
* [Raumplan](</Raumplan.pdf>)

# Unterstützungangebote innerhalb der Schule

* [Sprechstunden Schulärztinnen](</Sprechstunden-Schulärztinnen.pdf>)
* [Schüler:innen Beratung]( {{< relref "schule/unterstuetzung.md" >}} )
* [Schulpsychologie](</Infoblatt_Schulpsychologie.pdf>)

# Unterstützungsangebote außerhalb der Schule

|  Angebot  | Rufnummer |
|--------|--------|
| Hotline der Bildungsdirektion für schulische Krisen | 0664 803 455 665 |
| Schulpsychologische Beratungsstelle Steirischer Zentralraum | 05 0248 345 DW 660 bzw. 661 |
| Telefonseelsorge | 142 (rund um die Uhr, anonym & kostenlos) |
| Rat auf Draht | 147 (für Kinder & Jugendliche, kostenlos) |
| „Reden wir!“ | Steirisches Hilfetelefon: 0800 20 44 22 |
| PsyNot – Psychologische Notfallhilfe | 0800 44 99 33 |
| Institut für Kind, Jugend und Familie | 0699 1603 0001 |

---
# Wichtige Termine

<iframe id="blockrandom"
		name="iframe"
		src="https://outlook.office365.com/owa/calendar/d7f8a3ad77a74fb8ac309396f4c1f674@petersgasse.at/17489634fdce4639b5cba7f7738ad28216629884423289205626/calendar.html"
		width="100%"
		height="700"
		scrolling="auto"
		frameborder="1"
		title="Termine"></iframe>
---

Die Einbringung von Anträgen per Fax ist nicht möglich!
