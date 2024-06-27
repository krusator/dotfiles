# vim Cheat Sheet
## Common Commands
`dd` - delete current line  
`dw` - aktuelles Wort löschen  
`u` - undo  
`yw` - yank (copy) zum Ende des aktuellen Wortes  
`yy` - ganze Zeile kopieren/yank  
`p` - aktuellen yank/delete einfügen  
`A` - edit at the of the line  
`I` - edit at the beginning if the line
`c` - change mode to - use like `ciw`: change inside hole word - means word is deleted and you can type new stuff
`cit` - change between tags  
`ci{` - lösche Inhalt der nächste geschweißten { Klammer und aktiviere Insert-Mode (geht auch mit anderen Klammern)


## Navigate in Files
`0` - um Zeilenanfang  
`$` - zum Zeilenende  
`_` - zum ersten nicht-Leerzeichen in Zeile  
`w` - Wort nach vorne  
`b` - Wort zurück  
`e` . zum Ende des Wortes  
`f "gesuchtes Zeichen"` - springe zum gesuchten Zeichen `;` - wiederhole Suche nach rechts - `,` wiederhole suche nach links  
`)` - zum nächsten Absatz  
`(` - zum voherigen Absatz  
`gg` - Anfang der Datei  
`G` - Ende der Datei  
`Ctr-U` - halb hoch scrollen  
`Ctr-D` - halb runter scrollen  
`h` - nach links  
`j` - nach unten  
`k` - nach oben  
`l` - nach rechts  
`%` - to the matching closing or opening bracket or parenthesis 

## Yank
`yiw` - yank aktuelles Wort  
`"*yy` - yank and copy current line to clipboard  
## Delete
`dd` - ganze Zeile löschen  
`dw` - Wort ab Cursor löschen  
`diw` - Wort auf Cursor löschen  
`db` - Wort vor Cursor löschen  
## Fenster
`:nb` - Nächstes Fenster  
`:pb` - Vorheriges Fenster
`Ctrl-W-v`- Fenster vertikal splitten  
`Ctrl-W-s` - Fenstern horizontal splitten  
`Ctrl-W-→` - Nach rechts springen  
`Ctrl-W-←` - Nach links springen  
`q` - Fenster schließen  

## Buffer (geöffnete Datei)
`bn` - nächsten Buffer öffnen  
`bp` - vorherigen Buffer öffnen  
`bd` - aktuellen Buffer schließen
