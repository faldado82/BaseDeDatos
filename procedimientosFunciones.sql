--Esteban Martínez ( 271209 ) Guillermo Puppo ( 272406 ) Francisco Aldado ( 279264 ) 
USE BD2_ObligatorioFinal

set dateformat ymd

--3. Crear procedimientos y/o funciones para poder realizar las siguientes operaciones:

--PARAMETROS QUE RECIBE EL PROCEDIMIENTO
--a. Implementar un procedimiento AumentarCostosPlanta que reciba por parámetro: un Id de
--Planta, un porcentaje y un rango de fechas.


--TAREA DEL PROCEDIMIENTO
--El procedimiento debe aumentar en el porcentaje dado, para esa planta,
--los costos de mantenimiento que se dieron en ese rangode fechas.
--Esto tanto para mantenimientos de tipo:

--“OPERATIVO” donde se aumenta el
--costo por concepto de mano de obra (no se aumentan las horas, solo el costo)

--como de tipo 

--“NUTRIENTES” donde se debe aumentar los costos por concepto de uso de producto
--(no se debe aumentar ni los gramos de producto usado ni actualizar nada del maestro de
--productos)

--RETORNO DEL PROCEDIMIENTO
--El procedimiento debe retornar cuanto fue el aumento total de costo en dólares para la
--planta en cuestión.



--TESTEO DE FUNCIONALIDAD A--
declare @aumentoTotal decimal
set @aumentoTotal = 0
exec AumentarCostosPlanta 1,10,'2016-01-01 00:00:00','2022-12-31 23:59:59', @aumentoTotal output
print 'Aumento de los costos de mantenimiento para la planta 1 es = ' + convert(varchar(50),@aumentoTotal) 
--TESTEO DE FUNCIONALIDAD A--

-- drop procedure AumentarCostosPlanta

create procedure AumentarCostosPlanta
@idPlanta int,
@porcentaje int,
@fecha1 datetime,
@fecha2 datetime,
@aumentoTotal decimal output 

AS 
BEGIN try

declare @aux decimal
set @aux=0
 If exists(select * from Plantas where idPlanta=@idPlanta) -- pregunto si existe el id de la planta ingresado
 begin -- llave apertura if VALIDO IDPLANTA
   if exists
		(select * 
		 from mantenimientos mant 
				inner join MantOperativos op on mant.idMantenimiento = op.idMantOperativos
		 where mant.idPlantaFk = @idPlanta) -- pregunto si el id de la planta se encuetra relacionado con mantenimientos operativos 
		 begin -- apertura del if

			set @aumentoTotal=dbo.TotalCostoMPlantaOP(@idPlanta) 
			-- guardo el valor del costo total del mantenimiento de la planta antes de actualizar 
			
			update MantOperativos 
				set costoOperacion = costoOperacion + (costoOperacion * @porcentaje) / 100 -- aplicar la regla del porcentaje xq me caigo a pedazos costoOperacion+(costoOperacion *10)/100
				from MantOperativos op left join mantenimientos mant on op.idMantOperativos = mant.idMantenimiento
									   left join Plantas p on p.idPlanta = mant.idPlantaFK
				where mant.idPlantafk = @idPlanta -- variable @idPlanta
					and mant.fechaHoraMant >= @fecha1
					and mant.fechaHoraMant <= @fecha2

               
			set @aumentoTotal = dbo.TotalCostoMPlantaOP(@idPlanta) - @aumentoTotal  
			-- luego de realizar el update vuelvo a llamar a la funcion para que me haga la cuenta actualizada y saco el aumento con la diferencia de la cuenta
			set @aux = @aumentoTotal

		end -- cierre if UPDATE OPERATIVO
		if exists(select * 
				  from Mantenimientos mant2 inner join NutUtilizaProd nut
						on mant2.idMantenimiento = nut.idMantNutrientesFK
				  where mant2.idPlantaFK = @idPlanta) -- pregunto si el id de la planta se encuentra relacionado con mantenimientos nutrientes
		BEGIN -- apertura if UPDATE NUT
			      
			set @aumentoTotal= dbo.TotalCostoMPlantaNUT(@idPlanta)
				  
			update NutUtilizaProd
				set costoAplicacion = costoAplicacion + (costoAplicacion * @porcentaje ) / 100
				from NutUtilizaProd nut left join mantenimientos mant
					on nut.idMantNutrientesFK = mant.idMantenimiento
				where  mant.idPlantafk = @idPlanta
					and mant.fechaHoraMant >= @fecha1
					and mant.fechaHoraMant <= @fecha2

				set @aumentoTotal = @aumentoTotal+@aux
				set @aumentoTotal = dbo.TotalCostoMPlantaNUT(@idPlanta) - @aumentoTotal
		END-- cierre UPDATE NUTRIENTES
 end -- cierre if VALIDO ID PLANTA
 else
 begin -- llave apertura else
 print 'No existe el id de la planta'
 end -- cierre else

 end try

 begin catch
 print 'error en la ejecucion, verefique los datos de entrada'
 end catch







 --------------------------FUNCION QUE ME DEVUELVA EL TOTAL DEL AUMENTO --------------------------
create function TotalCostoMPlantaOP(@idPlanta int) returns  decimal
as begin
declare @total decimal
	
	select @total=  sum(op.costoOperacion) from MantOperativos op left join Mantenimientos mant
    on op.idMantOperativos=mant.idMantenimiento
	where mant.idPlantaFk = @idPlanta
	return @total
end

--------

create function TotalCostoMPlantaNUT(@idPlanta int) returns  decimal
as begin
declare @total decimal
	select @total=  sum(nut.costoAplicacion) from NutUtilizaProd nut left join mantenimientos mant
    on nut.idMantNutrientesFK= mant.idMantenimiento
     where mant.idPlantafk=@idPlanta
	return @total
end


------------------------------------------------------------------------------------------------------


 select * from MantOperativos -- costoOperacion
 select * from NutUtilizaProd -- costoAplicacion
 select * from Mantenimientos -- fechaHoraMant


-- ---- Rango de fechas --------------------------------------------------
-- select * from Mantenimientos m
-- where year(m.fechaHoraMant)>=2016
--  and year(m.fechaHoraMant)<=2020
--  order by year(m.fechaHoraMant)

--------------------------------------------------------------------------
-------- update costoOperativo------------- 
--update MantOperativos 
--set costoOperacion =costoOperacion+(costoOperacion *10)/100 -- aplicar la regla del porcentaje xq me caigo a pedazos costoOperacion+(costoOperacion *10)/100
--from MantOperativos op  left join mantenimientos mant on op.idMantOperativos= mant.idMantenimiento	
--where  mant.idPlantafk = 4 -- variable @idPlanta
--and  year(mant.fechaHoraMant)>=2015
--  and year(mant.fechaHoraMant)<=2022
------------------------------------------------------
-------------- consulta de verificacion de update Operativo exitosa -------------------------
--select * from MantOperativos op left join mantenimientos mant
--on op.idMantOperativos=mant.idMantenimiento
--where mant.idPlantafk= 4
-- and  year(mant.fechaHoraMant)>=2015
--  and year(mant.fechaHoraMant)<=2022



----------------------------------------------------------------------------------------------

------------ Update costoAplicacion NUTRIENTES ----------------------------------------------------------
--update NutUtilizaProd
--set costoAplicacion= costoAplicacion+(costoAplicacion *10)/100
--from NutUtilizaProd nut left join Mantenimientos m
--on nut.idMantNutrientesFK= m.idMantenimiento
--where  M.idPlantaFK= 2 -- variable @idPlanta
-- and  year(m.fechaHoraMant)>=2015
-- and year(m.fechaHoraMant)<=2022

------------------------------------------------------------------------------------------------
-------------- consulta de verificacion de update Nutriente Exitosa -------------------------
--  select *from NutUtilizaProd nut left join Mantenimientos m
--on nut.idMantNutrientesFK= m.idMantenimiento
--where  M.idPlantaFK= 2
-- and  year(m.fechaHoraMant)>=2015
-- and year(m.fechaHoraMant)<=2022
--order by M.idPlantaFK





--b. Mediante una función que recibe como parámetro un año: retornar el costo promedio de
--los mantenimientos de tipo “OPERATIVO” de ese año

create function RetornoPromedioAño1(@año int) returns decimal
as begin 
declare @porcentaje decimal(12,2);

set @porcentaje = (select avg(manto.costoOperacion) from Mantenimientos mant 
					inner join MantOperativos mantO on mant.idMantenimiento = manto.idMantOperativos
					where year(mant.fechaHoraMant) = @año);
	return @porcentaje;
end

declare @pr1 decimal(12,2);
set @pr1 = dbo.RetornoPromedioAño1(2022) ;
PRINT convert(varchar(15),@pr1)

-- 637 prom

select avg(manto.costoOperacion) from Mantenimientos mant 
inner join MantOperativos mantO on mant.idMantenimiento = manto.idMantOperativos
where year(mant.fechaHoraMant) = 2022


select sum(manto.costoOperacion) / count(*) as cantidad from Mantenimientos mant 
inner join MantOperativos mantO on mant.idMantenimiento = manto.idMantOperativos
where year(mant.fechaHoraMant) = 2022