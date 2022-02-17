-- Views für die GEWISSO2-Layer
-- 14.02.2022, oliver.grimm@geowerkstatt.ch 


drop view if exists gewaesser_v;
create view gewaesser_v
as select bg.*,eig.strahler,eig.datenherrkm, eig.vorfluternebengnr , eig.vorflutergewissnr , eig.eigentum , eig.qualitaet , eig.gdenr2 , eig.gdenr , eig.groesse , eig.typ , eig.datenherrgwb  from 		  
		    GewaesserBasisgeometrie bg
		  join
		    GewaesserEigenschaften eig on eig.rgewaesser = bg.t_id;


drop view if exists oekomorph_v;
create view oekomorph_v as 
select 
  r.t_id,
  --attr.abschnittid,
  --attr.abschnittnr ,
  attr.sohlenbreite ,
  attr.eindolung ,
  attr.breitenvariabilitaet ,
  attr.tiefenvariabilitaet ,
  attr.sohlenverbauung ,
  attr.sohlmaterial ,
  attr.boeschungsfussverbaulinks ,
  attr.boeschungsfussverbaurechts ,
  attr.materiallinks ,
  attr.materialrechts ,
  attr.uferbeschaffenheitlinks ,
  attr.uferbeschaffenheitrechts ,
  attr.algenbewuchs ,
  attr.makrophytenbewuchs ,
  attr.totholz ,
  attr.klasse ,
  attr.ueberhvegetation ,
  attr.domkorngroesse ,
  attr.nutzungumlandlinks ,
  attr.nutzungumlandrechts ,
  attr.raumbedarf ,
  attr.vielenatabstuerze,
  r.aname,
  r.gnrso,
  ST_LineSubstring(ng, LEasT(m1, m2), GREATEST(m1, m2))::geometry(LINESTRING, 2056) as geometrie
from
 (select * from
	  (select
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_StartPoint(seg.geometrie)) as m1,
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_EndPoint(seg.geometrie)) as m2,
	    seg.t_id,
	  	netz.aname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    oekomorph seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)) r
join
  oekomorph attr on r.t_id = attr.t_id;

 
drop view if exists fischrevierabschnitt_fischrevier_v;  
create view fischrevierabschnitt_fischrevier_v
as select seg.t_id, seg.geometrie, seg.nutzung, ent.revierid, ent.aname , ent.beschreibung, ent.eigentum, ent.bonitierung, ent.fischbestand, ent.fischerei , seg.rgewaesser from 		  
		    fischrevierabschnitt seg
		  join
		    fischrevier ent on seg.rfischrevier = ent.t_id;

 
drop view if exists fischrevier_v;
create view fischrevier_v as  
select 
  r.t_id,
  r.revierid,
  r.aname,
  r.beschreibung,
  r.eigentum,
  r.bonitierung,
  r.fischbestand,
  r.fischerei,
  ST_LineSubstring(ng, LEasT(m1, m2), GREATEST(m1, m2))::geometry(LINESTRING, 2056) as geometrie
from
 (select * from
	  (select
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_StartPoint(seg.geometrie)) as m1,
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_EndPoint(seg.geometrie)) as m2,
	    seg.*,
	  	netz.aname as gewname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    fischrevierabschnitt_fischrevier_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)) r
join
  fischrevierabschnitt_fischrevier_v attr on r.t_id = attr.t_id;


drop view if exists bauwerk_v;
create view bauwerk_v as  
select
	    ST_LineInterpolatePoint(ST_CurveToLine(netz.geometrie),ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.bauwerknr,
	    seg.typ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum 
	  from
	  	bauwerk seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id;


drop view if exists absturz_v;
create view absturz_v as  
select
	    ST_LineInterpolatePoint(ST_CurveToLine(netz.geometrie),ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.nummer ,
	    seg.typ,
	    seg.material ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum
	  from
	    absturz seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id;


drop view if exists errorfischrevier_v;
create view errorfischrevier_v as  
select * from
	  (select
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_StartPoint(seg.geometrie)) as m1,
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_EndPoint(seg.geometrie)) as m2,
	    seg.*,
	  	netz.aname as gewname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    fischrevierabschnitt_fischrevier_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric;


drop view if exists erroroekomorph_v;
create view erroroekomorph_v as 
select * from
	  (select
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_StartPoint(seg.geometrie)) as m1,
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_EndPoint(seg.geometrie)) as m2,
	    seg.t_id,
	    seg.geometrie,
	  	netz.aname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    oekomorph seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric;
  
 
 
drop view gewaesserkilometrierung_v;
create view gewaesserkilometrierung_v as
select gnrso, kwert, ST_LineInterpolatePoint(line_geom, kwert / geom_length) as geometrie
from
	(select
		gnrso,
		ST_CurveToLine(geometrie) as line_geom,
		ST_Length(geometrie) as geom_length,
		generate_series(0, cast(floor(ST_Length(geometrie)) as int), 20) as kwert
	from
		gewaesserbasisgeometrie g) q;
