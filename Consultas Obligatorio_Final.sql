--Esteban Martínez ( 271209 ) Guillermo Puppo ( 272406 ) Francisco Aldado ( 279264 ) 

--2. CONSULTAS ======================================================================================
USE BD2_ObligatorioFinal
--drop database BD2_ObligatorioFinal
--a. Mostrar Nombre de Planta y Descripción del Mantenimiento para el último(s)
--   mantenimiento hecho en el año actual

SELECT p.nombrePlanta, m.descripcionMant
FROM Mantenimientos m 
		 --Join PlantasTieneMantenimientos ptm ON m.idMantenimiento = ptm.idMantenimientoFK  
		Join Plantas p on m.idPlantaFK = p.idPlanta					  
WHERE m.fechaHoraMant = (SELECT Max(m2.fechaHoraMant) 
						 FROM Mantenimientos m2);



-- b. Mostrar la(s) plantas que recibieron más cantidad de mantenimientos

SELECT p.idPlanta, p.nombrePlanta, count(m.idMantenimiento) CantMantenimientos FROM Plantas p
	--Join PlantasTieneMantenimientos ptm on ptm.idPlantaFK = p.idPlanta
	inner Join Mantenimientos m on m.idPlantaFk = p.idPlanta
group by p.idPlanta, p.nombrePlanta
having count(*) = (select top 1 count(*) CantMantenimientos FROM Plantas p
					--Join PlantasTieneMantenimientos ptm on ptm.idPlantaFK = p.idPlanta
					Join Mantenimientos m on m.idPlantaFk = p.idPlanta
					group by p.idPlanta, p.nombrePlanta
					)
order by count(m.idMantenimiento) desc



/*
c. Mostrar las plantas que este año ya llevan más de un 20% de costo de mantenimiento
que el costo de mantenimiento de todo el año anterior para la misma planta ( solo
considerar plantas nacidas en el año 2019 o antes)
*/


select p1.idPlanta from plantas p1
where exists
	(select plantas.idPlanta from plantas 

	inner join Mantenimientos mant2
	on mant2.idPlantaFk = plantas.idPlanta
	
	left join NutUtilizaProd 
	on NutUtilizaProd.idMantNutrientesFK = mant2.idMantenimiento

	left join MantOperativos mantop
	on mantop.idMantOperativos = mant2.idMantenimiento

	where plantas.idPlanta = mant2.idPlantaFk

	and plantas.idPlanta = p1.idPlanta
	and year(mant2.fechaHoraMant) = year(getdate())
	group by plantas.idplanta
	having (isnull (sum(NutUtilizaProd.costoAplicacion),0))+(isnull (sum(mantop.costoOperacion),0))
	> 
		(select (isnull (sum(NutUtilizaProd.costoAplicacion),0))+(isnull (sum(mantop.costoOperacion),0)) as TOTAL from plantas p2  
		inner join Mantenimientos mant2
		on mant2.idPlantaFk = p2.idPlanta

		left join NutUtilizaProd 
		on NutUtilizaProd.idMantNutrientesFK = mant2.idMantenimiento

		left join MantOperativos mantop
		on mantop.idMantOperativos = mant2.idMantenimiento

		where p2.idPlanta = mant2.idPlantaFK
		and year(mant2.fechaHoraMant) = year(getdate()) -1
		and plantas.idPlanta = p2.idPlanta
		group by p2.idplanta) + (select (isnull (sum(NutUtilizaProd.costoAplicacion),0))+(isnull (sum(mantop.costoOperacion),0)) as TOTAL from plantas p2 
		inner join Mantenimientos mant2
		on mant2.idPlantaFk = p2.idPlanta

		left join NutUtilizaProd 
		on NutUtilizaProd.idMantNutrientesFK = mant2.idMantenimiento

		left join MantOperativos mantop
		on mantop.idMantOperativos = mant2.idMantenimiento

		where p2.idPlanta = mant2.idPlantaFK
		and year(mant2.fechaHoraMant) = year(getdate()) -1
		and plantas.idPlanta = p2.idPlanta
		group by p2.idplanta) * 0.20
	) 
and year(p1.fechaNac) <= 2019
group by p1.idPlanta


---- PRUEBAS ---
--select * from plantas p inner join mantenimientos m
--on m.idPlantaFk = p.idPlanta
--where year (m.fechaHoraMant) = 2022
--order by p.idPlanta

---- funciona para la suma de esa planta en OPERATIVOS
--select plantas.idPlanta, sum(MantOperativos.costoOperacion) as costoMantenimiento from plantas 
--inner join Mantenimientos mant1 on mant1.idPlantaFk = plantas.idPlanta
--inner join MantOperativos on MantOperativos.idMantOperativos = mant1.idMantenimiento
--where plantas.idPlanta = mant1.idPlantaFK
--and year(mant1.fechaHoraMant) = 2021--year(getdate())
--group by plantas.idplanta

----funciona para la suma de esa planta en NUTRIENTES
--select plantas.idPlanta, sum(NutUtilizaProd.costoAplicacion) as costoMantenimiento from plantas 
--inner join Mantenimientos mant1 on mant1.idPlantaFk = plantas.idPlanta
--inner join NutUtilizaProd on NutUtilizaProd.idMantNutrientesFK = mant1.idMantenimiento
--where plantas.idPlanta = mant1.idPlantaFK
--and year(mant1.fechaHoraMant) = 2021--year(getdate())
--group by plantas.idplanta
----FIN PRUEBAS--








/*d. Mostrar las plantas que tienen el tag “FRUTAL”, a la vez tienen el tag “PERFUMA” y no
tienen el tag “TRONCOROTO”. Y que adicionalmente miden medio metro de altura o
más y tienen un precio de venta establecido
*/

SELECT * FROM PLANTAS pla
where pla.idPlanta in (select ppt.idPlantaFK from tags inner join PlantasTieneTags ppt
					 on ppt.idTagFK = tags.idTag
					 where tags.nombreTag = 'PERFUMA')

and pla.idPlanta in (select ppt.idPlantaFK from tags inner join PlantasTieneTags ppt
					on ppt.idTagFK = tags.idTag
					where tags.nombreTag = 'FRUTAL')

and pla.idPlanta not in (select ppt2.idPlantaFK from tags inner join PlantasTieneTags ppt2
						 on ppt2.idTagFK = tags.idTag
						 where tags.nombreTag = 'TRONCO ROTO')
and pla.alturaCM >= 150
and pla.precioDolares is not null
and pla.precioDolares > 0
;


---- PRUEBAS -----
/*
select * from tags

select p.nombrePlanta, p.idPlanta, pt.idPlantaFK,pt.idTagFK,t.idTag,t.nombreTag
from plantas p inner join PlantasTieneTags pt on pt.idPlantaFK = p.idPlanta
inner join tags t on t.idTag = pt.idTagFK

where (t.nombreTag = 'TRONCO ROTO' or t.nombreTag = 'PERFUMA')
or t.nombreTag = 'FRUTAL'
*/
---- FIN PRUEBAS -----

/*
e. Mostrar las Plantas que recibieron mantenimientos que en su conjunto incluyen todos
los productos existentes
*/


select mant.idPlantaFK from Mantenimientos mant
inner join NutUtilizaProd nutu on mant.idMantenimiento = nutu.idMantNutrientesFK
group by mant.idPlantaFK
having  count(distinct nutu.idProductoUtilizado)
				= 
		(select count(pro.idCodigoProducto) from Productos pro);


/*
f. Para cada Planta con 2 años de vida o más y con un precio menor a 200 dólares:

sumarizar su costo de Mantenimiento total ( contabilizando tanto mantenimientos de
tipo “OPERATIVO” como de tipo “NUTRIENTES”) 

y mostrar solamente las plantas que su costo sumarizado es mayor que 100 dólares.
*/

select * from plantas pla
where year(getdate()) - year(pla.fechaNac) >= 2
and pla.precioDolares < 200
and exists (select * from mantenimientos mant
			left join MantOperativos mantO on mant.idMantenimiento = mantO.idMantOperativos
			left join NutUtilizaProd nutu on mant.idMantenimiento = nutu.idMantNutrientesFK
			where mant.idPlantaFK = pla.idPlanta
			group by mant.idPlantaFK
			having (isnull (sum(nutU.costoAplicacion),0))+(isnull (sum(mantO.costoOperacion),0))
			> 100
			);

