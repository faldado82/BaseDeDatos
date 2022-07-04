--Esteban Martínez ( 271209 ) Guillermo Puppo ( 272406 ) Francisco Aldado ( 279264 ) 
-- Triggers
USE BD2_ObligatorioFinal
set dateformat ymd

--4. Mediante el uso de disparadores, crear las siguientes reglas de negocio y auditoría:

--a. Auditar cualquier cambio del maestro de Productos. Se debe llevar un registro detallado de
--las inserciones, modificaciones y borrados, en todos los casos registrar desde que PC se
--hacen los movimientos, la fecha y la hora, el usuario y todos los datos que permitan una
--correcta auditoría (si son modificaciones que datos se modificaron, qué datos había antes,
--que datos hay ahora, etc). La/s estructura/s necesaria para este punto es libre y queda a
--criterio del alumno 

--drop trigger TR_AuditoriaProductos

create trigger TR_AuditoriaProductos
on Productos
AFTER insert, delete, update
as
begin try	
	if  Exists(select * from inserted) and Exists (select * from deleted)--es update
		begin --update
	
		insert AuditoriaProductos select 'Datos anteriores',SYSTEM_USER,user,getdate(),
				d.idCodigoProducto,d.descripcionProd,d.precioActualxGramo from deleted d;
	
		insert AuditoriaProductos select 'Datos nuevos',SYSTEM_USER,user,getdate(),
				i.idCodigoProducto,i.descripcionProd,i.precioActualxGramo from inserted i;
	end--update
	else
	begin 
		if Exists(select * from inserted)--es insert
		begin--insert
			insert AuditoriaProductos select 'Datos insertados',SYSTEM_USER,user,getdate(),
			i.idCodigoProducto,i.descripcionProd,i.precioActualxGramo from inserted i;
		end--insert

		else --delete
		begin
			insert AuditoriaProductos select 'Datos eliminados',SYSTEM_USER,user,getdate(),
				d.idCodigoProducto,d.descripcionProd,d.precioActualxGramo from deleted d;
		end--delete
	end
end try
BEGIN CATCH
--Maneras de testear errores en el catch
        DECLARE @ErrorMsg VARCHAR(MAX), @ErrorNumber INT, @ErrorProc sysname, @ErrorLine INT 

        SELECT @ErrorMsg = ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorProc = ERROR_PROCEDURE(), @ErrorLine = ERROR_LINE();
        RollBack Tran;

        INSERT INTO ErrorLog (ErrorMsg,  ErrorNumber,  ErrorProc,  ErrorLine)
        VALUES               (@ErrorMsg, @ErrorNumber, @ErrorProc, @ErrorLine)
--Maneras de testear errores en el catch
END CATCH


-- ================ TEST de Auditorias ====================================== 
INSERT INTO Productos(idCodigoProducto,descripcionProd,precioActualxGramo) 
values 
('AAA00','Probando trigger 00, insert Auditoria 00', 7) -- BORRAR DESPUES DE TESTEAR

delete Productos where idCodigoProducto ='ABC11'

update productos set idCodigoProducto = 'YYY00'
where precioActualxGramo = 11;

delete Productos where precioActualxGramo > 1;

select * from AuditoriaProductos a 
select * from productos

--drop table productos

--TEST de Auditorias ===========================================


--Maneras de testear errores en el catch
CREATE TABLE ErrorLog (
   ErrorLogID INT IDENTITY(1,1),
   ErrorDate DATETIME DEFAULT (GETUTCDATE()),
   ErrorMsg VARCHAR(MAX), 
   ErrorNumber INT, 
   ErrorProc sysname, 
   ErrorLine INT 
);

select * from Errorlog
delete ErrorLog
--Maneras de testear errores en el catch




-- =========================================================================================
-- b. Controlar que no se pueda dar de alta un mantenimiento cuya fecha-hora es menor que la
-- fecha de nacimiento de la planta

--drop trigger TR_FechaHoraMant1

create trigger TR_FechaHoraMant1
on Mantenimientos
Instead of insert, update
as 
begin try
	if not exists(select * from deleted)
	begin
		insert into Mantenimientos (fechaHoraMant, idPlantaFk, descripcionMant)
		select i.fechaHoraMant, i.idPlantaFk, i.descripcionMant from inserted i
		inner join Plantas p on p.idPlanta = i.idPlantaFk
		where i.fechaHoraMant > p.fechaNac
	end
	else
	begin
		update Mantenimientos 
		set fechaHoraMant = i.fechaHoraMant,
			idPlantaFk = i.idPlantaFk, 
			descripcionMant = i.descripcionMant 
		from Mantenimientos m
			inner join inserted i on i.idMantenimiento = m.idMantenimiento
			inner join plantas p on p.idPlanta = i.idPlantaFk 
		where i.fechaHoraMant > p.fechaNac and i.idMantenimiento = m.idMantenimiento
	end
end try
begin catch

DECLARE @ErrorMsg VARCHAR(MAX), @ErrorNumber INT, @ErrorProc sysname, @ErrorLine INT 
        SELECT @ErrorMsg = ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorProc = ERROR_PROCEDURE(), @ErrorLine = ERROR_LINE();
        RollBack Tran;

        INSERT INTO ErrorLog (ErrorMsg,  ErrorNumber,  ErrorProc,  ErrorLine)
        VALUES               (@ErrorMsg, @ErrorNumber, @ErrorProc, @ErrorLine)
		print 'error al producirse el insert'
end catch


/*
set dateformat ymd
insert into Mantenimientos values('2019-01-01',98,'prueba trigger')

insert into Mantenimientos values
('2017-01-01',98,'prueba trigger 2'),
('2013-01-01',98,'prueba trigger 3'),
('2027-01-01',98,'prueba trigger 4'),
('2019-01-01',98,'prueba trigger 5'),
('2012-01-01',98,'prueba trigger 6')

select * from mantenimientos m
order by idMantenimiento desc

insert into Productos values ('123456','asdfafdsa',55),
							 ('456123',null,25),
							 ('789456','sdfafa',85)
*/