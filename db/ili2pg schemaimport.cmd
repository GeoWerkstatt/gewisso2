REM ili2pg Schemaimport für Gewisso2
REM ------------------------------------------
REM Parameters:
REM 1: PostgreSQL Host (zB. my.postgis.example)
REM 2: PostgreSQL Port (zB. 5432)
REM 3: DB-User Name (zB. postgres)
REM 4: DB-User Password
REM 5: Database-Name (zB. gewisso)
REM 6: Schema-Name (zB. gewisso2)

java.exe -jar .\ili2pg\ili2pg-4.6.0.jar --schemaimport --dbhost %1 --dbport %2 --dbusr %3 --dbpwd %4 --dbdatabase %5 --dbschema %6 --createEnumTabs --createNumChecks --createUnique --createFk --createFkIdx --beautifyEnumDispName --createGeomIdx --smart2Inheritance --strokeArcs --createMetaInfo --defaultSrsCode 2056 --models SO_AFU_Gewaesser_20220401 ./assets/model/SO_AFU_Gewaesser_20220401.ili
