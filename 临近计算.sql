--向gc_2g中添加distance和cgi字段
--计算每个点最近的几个点，可以是同一张表，也可是不同表
CREATE OR REPLACE FUNCTION queryNearest() RETURNS int AS $idx$ DECLARE
idx int= 1;
dis float8=0;
cgi varchar;
r record;
BEGIN
	for r in select "cgi" as acgi,geom from gc_2g where geom is not null
	loop 
        --limit后面的参数表示最近的多少个
		update gc_2g set (distance,cgi)=(select ST_Transform(a.geom,3857) <-> ST_Transform(r.geom,3857) as distance,a.cgi as cgi from gc_lte_0312 a order by a.geom <-> r.geom limit 1) where gc_2g."cgi"=r.acgi;
		idx=idx+1;
	end loop;
	return idx;
END
$idx$ LANGUAGE plpgsql;