Gewässer Informationssystem Kt. Solothurn (GEWISSO)
===================================================

Produktionsumgebung für das Gewässer Informationssystem des Kt. Solothurn ausgelegt für die Arbeit mit Hilfsklassen zur Definition der linearen Referenzen in QGIS.

| Files	   | #1  |
| /db/lrs_views.sql    | View-Definitionen: dynamische Segmente, Kilometrierungslayer, Error-Layer | 
| /db/ili2pg schemaimport.cmd  | ili2pg Schemaimport Statements | 
| /db/ili2pg dataimport.cmd  | ili2db Datenimport Statements | 
| /fme/gewisso2gewisso.fmw  | FME Workbench Gewisso-1 -> Gewisso-2 |
| /model/SO_AFU_Fliessgewaesser_20220228.ili  | Erfassungsmodell für für die Fliessgewässer und abschnittbezogene Fliessgewässerinformationen des Kt. Solothurn. |
| /qgis/gewisso.qgs  | QGIS-Projektdatei für Gewisso * |


##Spezielle Konfigurationen gewisso.qgs:
- Beziehungsreferenzen gemäss INTERLIS Modell
- Aufzählwerte mit ilicode 
