ahoj 
och joj

-- vkladanie rezervacie
insert into rezervacie (id_rezervacia, id_spoj, miesto_na_sedenie, id) values (
  null
 ,(select id_spoj from spoje where datum = to_date('04-dec-14')
                                   and id_linka = (select id_linka from linky where oznacenie_linky = 'R13' 
                                                                                  and smer = 'Bratislava'
                                                                                  and cas_odchodu = '5:00'))
 ,case when((select count(*) from rezervacie where id_spoj = (select id_spoj from spoje where datum = to_date('04-dec-14')
                                                     and id_linka = (select id_linka from linky where oznacenie_linky = 'R13' 
                                                                                  and smer = 'Bratislava'
                                                                                  and cas_odchodu = '5:00'))
            ) +1 ) <= (select kapacita from autobusy where id_autobus =
                (select id_autobus from spoje where id_spoj = (
                  (select id_spoj from spoje where datum = to_date('04-dec-14')
                                   and id_linka = (select id_linka from linky where oznacenie_linky = 'R13' 
                                                                                  and smer = 'Bratislava'
                                                                                  and cas_odchodu = '5:00')))))
  then ((select count(*) from rezervacie where id_spoj = (select id_spoj from spoje where datum = to_date('04-dec-14')
                                                     and id_linka = (select id_linka from linky where oznacenie_linky = 'R13' 
                                                                                  and smer = 'Bratislava'
                                                                                  and cas_odchodu = '5:00'))
    ) +1 )
  else null
  end
 ,1
);

-- vyhladat spoje, ktore isli v dany datum
select spoje.datum, spoje.ID_SPOJ, linky.oznacenie_linky, linky.smer, linky.CAS_ODCHODU from
spoje left outer join linky using (ID_LINKA)
where datum = to_date('04-12-2014');

-- zistenie prijmov z listkov za den
select sum(cena) as "Prijem z listkov" from
    ( listky join cennik on
      ( ( round(listky.VZDIALENOST) between cennik.vzdialenost_od and cennik.VZDIALENOST_DO) 
      and (listky.CENOVA_UROVEN = cennik.CENOVA_UROVEN) )
    )
    join spoje using(ID_SPOJ)
where datum = to_date('03-12-14');

-- zistenie prijmov z rezervacii za den
select sum(cena) as "Prijem z rezervacii" from 
    (rezervacie natural join cennik_rez) 
    join spoje using (ID_SPOJ)
where datum = to_date('04-12-14');

-- zistenie celkovych prijmov
select
  (select sum(cena) from
    listky join cennik on
    ( ( round(listky.VZDIALENOST) between cennik.vzdialenost_od and cennik.VZDIALENOST_DO) 
    and (listky.CENOVA_UROVEN = cennik.CENOVA_UROVEN) )) as "Prijem z listkov",
  (select sum(cena) from 
    rezervacie natural join cennik_rez) as "Prijem z rezervacii",
  ( (select sum(cena) from
      listky join cennik on
      ( ( round(listky.VZDIALENOST) between cennik.vzdialenost_od and cennik.VZDIALENOST_DO) 
      and (listky.CENOVA_UROVEN = cennik.CENOVA_UROVEN) ))
    +
    (select sum(cena) from 
      rezervacie natural join cennik_rez)
  ) as "Prijem celkom"
from dual;

