REM ili2pg Schemaimport für Gewisso2
REM ------------------------------------------
REM Parameters:
REM 1: PostgreSQL Host (zB. my.postgis.example)
REM 2: PostgreSQL Port (zB. 5432)
REM 3: DB-User Name (zB. postgres)
REM 4: DB-User Password
REM 5: Database-Name (zB. gewisso2)
REM 6: Schema-Name (zB. gewisso)

java.exe -jar .\ili2pg\ili2pg-4.6.0.jar --schemaimport --dbhost %1 --dbport %2 --dbusr %3 --dbpwd %4 --dbdatabase %5 --dbschema %6 --setupPgExt --coalesceCatalogueRef --createEnumTabs --createNumChecks --createUnique --createFk --createFkIdx --beautifyEnumDispName --createGeomIdx --createTypeConstraint --createEnumTabsWithId --createTidCol --smart2Inheritance --sqlEnableNull --defaultSrsCode 2056 --models SO_AFU_Fliessgewaesser_20220228 ./model/SO_AFU_Fliessgewaesser_20220228.ili