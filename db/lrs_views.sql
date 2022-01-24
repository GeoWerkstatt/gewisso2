
drop view gewaesser_v;
create view gewaesser_v
as select * from 		  
		    GewaesserBasisgeometrie bg
		  join
		    GewaesserEigenschaften eig on bs.rgewaesser = eig.t_id;


drop view oekomorph_v cascade;
create view oekomorph_v as 
select 
  r.t_id,
  attr.abschnittid,
  attr.abschnittnr ,
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

 
drop view fischenzabschnitt_fischenz_v;  
create view fischenzabschnitt_fischenz_v
as select seg.t_id, seg.geometrie, seg.nutzung, ent.revierid, ent.fischenzname, ent.fischenzbeschreibung, ent.eigentum, ent.bonitierung, ent.fischbestand, ent.fischerei, ent.rgewaesser from 		  
		    fischenzabschnitt seg
		  join
		    fischenz ent on seg.rfischenz = ent.t_id;

 
drop view fischenz_v cascade;
create view fischenz_v as  
select 
  r.t_id,
  r.revierid,
  r.fischenzname,
  r.fischenzbeschreibung,
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
	  	netz.aname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    fischenzabschnitt_fischenz_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)) r
join
  fischenzabschnitt_fischenz_v attr on r.t_id = attr.t_id


drop view bauwerk_v CasCADE;
create view bauwerk_v as  
select
	    ST_LineInterpolatePoint(ST_CurveToLine(netz.geometrie),ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.bauwerknr,
	    seg.typ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum,
	    seg.exportdatum 
	  from
	    bauwerk seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id


drop view absturz_v cascade;
create view absturz_v as  
select
	    ST_LineInterpolatePoint(ST_CurveToLine(netz.geometrie),ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.nummer ,
	    seg.typ,
	    seg.material ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum,
	    seg.exportdatum 
	  from
	    absturz seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id


drop view errorfischenz_v cascade;
create view errorfischenz_v as  
select * from
	  (select
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_StartPoint(seg.geometrie)) as m1,
	    ST_LineLocatePoint(ST_CurveToLine(netz.geometrie), ST_EndPoint(seg.geometrie)) as m2,
	    seg.*,
	  	netz.aname,
	  	netz.gnrso,
	    ST_AsText(ST_CurveToLine(netz.geometrie)) as ng
	  from
	    fischenzabschnitt_fischenz_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric


drop view erroroekomorph_v cascade;
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
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric