-- Views für die GEWISSO2-Layer
-- 31.03.2022, oliver.grimm@geowerkstatt.ch 

SET search_path TO ${dbSchema};

-- View zur Publizierung sämtlicher Gewaesserbasis-Informationen
drop view if exists gewaessereigenschaft_v;
create view gewaessereigenschaft_v
as select q.tid as t_id , q.gnrso, q.aname, q.strahler, q.eigentum, q.qualitaet, q.gdenr2, q.gdenr, q.groesse, q.typ,
public.ST_LineSubstring(geometrie, LEAST(m1, m2), GREATEST(m1, m2))::public.geometry(LINESTRING, 2056) as geometrie 
from 
(select 	public.ST_LineLocatePoint(bg.geometrie, public.ST_StartPoint(eig.geometrie)) as m1,
	    	public.ST_LineLocatePoint(bg.geometrie, public.ST_EndPoint(eig.geometrie)) as m2,
			bg.*,eig.strahler , eig.aname , eig.eigentum , eig.qualitaet , eig.gdenr2 , eig.gdenr , eig.groesse , eig.typ , eig.t_id as tid ,
			public.ST_AsText(bg.geometrie) as ng
			from 		  
		    GewaesserEigenschaften eig
		  join
		    GewaesserBasisgeometrie bg on eig.rgewaesser = bg.t_id) q
		    where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)


-- View zur Generierung und Publizierung der dynamisch segmentierten Oekomorphologie-Abschnitte
-- (filter Hilfsgeometrien aus, deren End- bzw. Startpunkte nicht für die Referenzierung verwendet werden können)
drop view if exists oekomorph_v;
create view oekomorph_v as 
select 
  r.t_id,
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
  attr.ueberhvegetation ,
  attr.domkorngroesse ,
  attr.nutzungumlandlinks ,
  attr.nutzungumlandrechts ,
  attr.vielenatabstuerze,
  r.gnrso,
  public.ST_LineSubstring(ng, LEAST(m1, m2), GREATEST(m1, m2))::public.geometry(LINESTRING, 2056) as geometrie
from
 (select * from
	  (select
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_StartPoint(seg.geometrie)) as m1,
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_EndPoint(seg.geometrie)) as m2,
	    seg.t_id,
	  	netz.gnrso,
	    public.ST_AsText(netz.geometrie) as ng
	  from
	    oekomorph seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)) r
join
  oekomorph attr on r.t_id = attr.t_id;

-- View zur Publizierung der kompletten Fischerei-Abschnitts-Informationen
drop view if exists fischrevierabschnitt_v;  
create view fischrevierabschnitt_v
as select seg.t_id, seg.geometrie, seg.nutzung, ent.revierid, ent.aname , ent.beschreibung, ent.eigentum, seg.bonitierung, ent.fischbestand, ent.fischerei , seg.rgewaesser from 		  
		    fischrevierabschnitt seg
		  join
		    fischrevier ent on seg.rfischrevier = ent.t_id;

 
-- View zur Generierung und Publizierung der dynamisch segmentierten Oekomorphologie-Abschnitte
-- (filter Hilfsgeometrien aus, deren End- bzw. Startpunkte nicht für die Referenzierung verwendet werden können)
drop view if exists fischrevier_v;
create view fischrevier_v as  
select 
  r.t_id,
  r.revierid,
  r.beschreibung,
  r.eigentum,
  r.bonitierung,
  r.fischbestand,
  r.fischerei,
  public.ST_LineSubstring(ng, LEAST(m1, m2), GREATEST(m1, m2))::public.geometry(LINESTRING, 2056) as geometrie
from
 (select * from
	  (select
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_StartPoint(seg.geometrie)) as m1,
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_EndPoint(seg.geometrie)) as m2,
	    seg.*,
	  	netz.gnrso,
	    public.ST_AsText(netz.geometrie) as ng
	  from
	    fischrevierabschnitt_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 != q.m2 and (q.m1 != 'NaN'::numeric or q.m2 != 'NaN'::numeric)) r
join
  fischrevierabschnitt_v attr on r.t_id = attr.t_id;


-- View zur Generierung und Publizierung der dynamisch referenzierten Bauwerke
drop view if exists bauwerk_v;
create view bauwerk_v as  
select
	    public.ST_LineInterpolatePoint(netz.geometrie,public.ST_LineLocatePoint(netz.geometrie, seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.typ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum 
	  from
	  	bauwerk seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id;


-- View zur Generierung und Publizierung der dynamisch referenzierten Abstürze
drop view if exists absturz_v;
create view absturz_v as  
select
	    public.ST_LineInterpolatePoint(netz.geometrie,public.ST_LineLocatePoint(netz.geometrie, seg.geometrie)) as geometrie,
	    seg.t_id,
	    seg.typ,
	    seg.material ,
	    seg.hoehe,
	    seg.erhebungsdatum,
	    seg.importdatum
	  from
	    absturz seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id;


-- View zur Publizierung von FischRevierAbschnitt-Objekten, bei welchen kein dynamisches Segment gebildet werden konnte
drop view if exists fischrevierabschnitt_error_v;
create view fischrevierabschnitt_error_v as  
select * from
	  (select
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_StartPoint(seg.geometrie)) as m1,
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_EndPoint(seg.geometrie)) as m2,
	    seg.*,
	  	netz.gnrso,
	    public.ST_AsText(netz.geometrie) as ng
	  from
	    fischrevierabschnitt_v seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric;


-- View zur Publizierung von Oekomorphologie-Objekten, bei welchen kein dynamisches Segment gebildet werden konnte
drop view if exists oekomorph_error_v;
create view oekomorph_error_v as 
select * from
	  (select
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_StartPoint(seg.geometrie)) as m1,
	    public.ST_LineLocatePoint(netz.geometrie, public.ST_EndPoint(seg.geometrie)) as m2,
	    seg.t_id,
	    seg.geometrie,
	  	netz.gnrso,
	    public.ST_AsText(netz.geometrie) as ng
	  from
	    oekomorph seg
	  join
	    gewaesserbasisgeometrie netz on seg.rgewaesser = netz.t_id) q
  where q.m1 = q.m2 or q.m1 = 'NaN'::numeric or q.m2 = 'NaN'::numeric;
  
 
-- View zur Publizierung der 20m-Kilometrierung entlang des Gewässerbasisnetzes 
drop view if exists gewaesserkilometrierung_v;
create view gewaesserkilometrierung_v as
select gnrso, kwert, public.ST_LineInterpolatePoint(line_geom, kwert / geom_length) as geometrie
from
	(select
		gnrso,
		geometrie as line_geom,
		public.ST_Length(geometrie) as geom_length,
		generate_series(0, cast(floor(public.ST_Length(geometrie)) as int), 20) as kwert
	from
		gewaesserbasisgeometrie g) q;
