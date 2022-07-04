--Esteban Martínez ( 271209 ) Guillermo Puppo ( 272406 ) Francisco Aldado ( 279264 ) 
CREATE DATABASE BD2_ObligatorioFinal
use BD2_ObligatorioFinal
set dateformat ymd



--drop database BD2_ObligatorioFinal
-- Drops de tablas en caso de necesitarlas

-- ENTIDADES:
CREATE TABLE Tags(
idTag int identity(1,1) primary key,
nombreTag varchar(30) not null unique
);

CREATE TABLE Plantas(
idPlanta int identity (1,1) primary key,
nombrePlanta varchar(30) not null,
fechaNac datetime not null check(fechaNac <= getdate()),
alturaCM int check(alturaCM BETWEEN 1 and 12000),
fechaHoraMedida datetime check(fechaHoraMedida <= getdate()),
precioDolares decimal(12,2) check(precioDolares > 0),
Constraint R_Fechas_Altura check  (fechaNac < fechaHoraMedida)
);
--RNE  si la altura de la planta está registrada, esta fecha-hora no puede ser nula 
	

CREATE TABLE Mantenimientos(
idMantenimiento int identity(1,1) primary key, 
fechaHoraMant datetime not null check(fechaHoraMant <= getdate()),
idPlantaFk int not null,
foreign key (idPlantaFk) references Plantas (idPlanta),
descripcionMant varchar(500) not null
);


CREATE TABLE MantOperativos(
idMantOperativos int References Mantenimientos(idMantenimiento),
cantHoras decimal(4,2) not null check(cantHoras > 0),
costoOperacion decimal(12,2) not null check(costoOperacion > 0),
Primary Key(idMantOperativos)
);

CREATE TABLE Productos(
idCodigoProducto char(5) Primary Key check(len(idCodigoProducto) = 5),
descripcionProd varchar(500) not null unique,
precioActualxGramo decimal(10,2) not null check(precioActualxGramo > 0)
);

--RELACIONES
CREATE TABLE PlantasTieneTags(
idTagFK int References Tags(idTag),
idPlantaFK int References Plantas(idPlanta),
Primary Key(idTagFK, idPlantaFK)
);


CREATE TABLE NutUtilizaProd(
idProductoUtilizado char(5) References Productos(idCodigoProducto),
idMantNutrientesFK int References Mantenimientos(idMantenimiento),
cantidadProd int not null check(cantidadProd > 0),
costoAplicacion decimal(12,2) not null check(costoAplicacion > 0),
Primary key(idProductoUtilizado, idMantNutrientesFK)
);

--drop table AuditoriaProductos
CREATE TABLE AuditoriaProductos(
id int identity(1,1),
tipoDeOperacion varchar(30)check (tipoDeOperacion in ('Datos insertados','Datos eliminados','Datos anteriores','Datos nuevos')) not null,
pc varchar(100) not null,
usuario varchar(100) not null,
fechaYhora datetime not null,
idCodigoProducto char(5) not null,
descripcionProd varchar(500) not null,
precioActualxGramo decimal(10,2) not null
primary key(id, fechaYhora, usuario, tipoDeOperacion)
);




-- CREACION DE INDICES ===================================================================
CREATE INDEX I_PlantaTieneTags on PlantasTieneTags(idPlantaFK);
CREATE INDEX I_NutUtilizaProd on NutUtilizaProd(idMantNutrientesFK);
CREATE INDEX I_Mantenimientos on Mantenimientos(idPlantaFk);


-- **********  ATENCION  **************
-- IR A TRIGGERS Y AGREGAR DISPARADORES



-- INSERT A TABLAS =========================================================================

--Insert de Tags de Plantas
INSERT INTO Tags(nombreTag) values
('FRUTAL'),
('TRONCO ROTO'),
('TRONCO DOBLADO'),
('SIN FLOR'),
('CON FLOR'),
('FLOR ROJA'),
('FLOR BLANCA'),
('FLOR AMARILLA'),
('FLOR VIOLETA'),
('FLOR ROSADA'),
('SOMBRA'),
('HIERBA'),
('PERFUMA'),
('INTERIOR'),
('EXTERIOR'),
('LUZ MIXTA'),
('SIN ESPINAS'),
('CON ESPINAS'),
('PASSIFLORACEAE'),
('ULMACEAE'),
('FITOLACACEAE'),
('MORACEAE'),
('RAMNACEAE'),
('ESTIRACACEAE'),
('BIGNONIACEAE'),
('COMBRETACEAE'),
('TIMELEACEAE'),
('SAXIFRAGACEAE'),
('LILIACEAE'),
('MIRTACEAE'),
('ANACARDIACEAE'),
('IRIDANCEAE'),
('FABACEAE'),
('VERBENACEAE'),
('SAPINDACEAE'),
('RUBIACAEAE'),
('TILIACEAE'),
('BERBERIDACEAE'),
('MIRSINACEAE'),
('LAURACEAE'),
('PALMACEAE'),
('EUFORBIACEAE'),
('FLACOURTIACEAE'),
('HORTALIZA'),
('CALASTRACEAE'),
('UMBELIFERAS'),
('QUENOPODIACEAS'),
('CRUCIFERAS'),
('CUCURBITACEAS'),
('COMPOSITACEAS'),
('LEGUMINOSAS'),
('SOLANACEAS'),
('LILIACEAS')
;

---- TAGS CON ERRORES ----
INSERT INTO Tags(nombreTag) values
--Error nombre de tag repetido
('FRUTAL')
---- TAGS CON ERRORES ----



-- Insert de Plantas
--VERDURAS / FRUTAS
--Umbeliferas
insert into Plantas(nombrePlanta,fechaNac,alturaCM,fechaHoraMedida,precioDolares) values

('Zanahoria','2017-11-15 06:31:20',16,'2017-11-16 07:30:00',0.80), --1
('Apio','2021-11-07 06:37:20',22,'2021-11-07 07:00:00',1.20), --2
('Perejil','2017-11-27 07:31:50',27,'2017-11-27 08:40:01',0.70), --3
('Hinojo','2021-12-01 06:46:20',15,'2021-12-01 07:03:00',1), --4
('Kuratu','2021-12-01 07:10:22',5,'2021-12-01 07:11:00',1), --5

--Quenopodiaceas
('Remolacha','2021-12-05 06:31:20',17,'2021-12-05 07:32:00',1.9), --6
('Acelga','2021-12-05 06:37:20',21,'2021-12-05 07:33:00',1), --7
('Espinaca','2021-12-05 06:31:20',19,'2021-12-05 07:39:00',1), --8

--Cruciferas
('Repollo blanco','2021-12-06 06:31:20',17,'2021-12-06 06:32:00',2.3), --9
('Brocoli','2021-12-06 06:35:20',16,'2021-12-06 06:36:00',2), --10
('Coliflor','2021-12-06 06:37:20',16,'2021-12-06 06:40:00',2), --11
('Rabanito','2021-12-06 06:45:20',4,'2021-12-06 06:46:00',0.40), --12
('Berro','2021-12-06 06:51:20',12,'2021-12-06 06:52:00',0.40), --13
('Nabo','2021-12-06 06:53:20',7,'2021-12-06 06:54:00',0.40), --14
('Repollo colorado','2021-12-06 06:57:20',17,'2021-12-06 06:58:00',2.3), --15

--Cucurbutaceas
('Calabaza','2022-01-15 09:31:20',26,'2022-01-15 09:32:00',2), --16
('Pepino','2022-01-15 09:34:20',11,'2022-01-15 09:35:00',1.1), --17
('Zapallo','2022-01-15 09:38:20',22,'2022-01-15 09:40:00',2), --18
('Zucchini','2022-01-15 09:46:20',13,'2022-01-15 09:47:00',3), --19
('Melon','2022-01-15 09:50:20',16,'2022-01-15 09:51:00',3), --20

('Sandia','2018-01-15 10:22:20',32,'2018-01-15 10:23:00',3), --21
('Porongo','2018-01-15 10:25:20',17,'2018-01-15 10:27:00',1), --22

('Zapallito','2022-01-15 13:39:20',8,'2022-01-15 13:42:00',1.3), --23
('Chuchu','2022-01-15 13:42:20',14,'2022-01-15 13:44:00',0.80), --24


--Compositaceas
('Lechuga','2022-01-16 08:42:20',16,'2022-01-16 08:43:20',2.9), --25
('Escarola','2022-01-16 08:44:20',16,'2022-01-16 08:45:20',1), --26
('Achicoria','2022-01-16 08:46:20',12,'2022-01-16 08:47:20',1.3), --27
('Girasol','2022-01-16 08:48:20',42,'2022-01-16 08:49:20',3), --28
('Manzanilla','2022-01-16 08:50:20',12,'2022-01-16 08:51:20',1.5), --29
('Diente de lon','2022-01-16 08:52:20',7,'2022-01-16 08:53:20',0.20), --30
('Ajenjo','2022-01-16 08:54:20',3,'2022-01-16 08:55:20',0.20), --31


--Leguminosas
('Poroto','2022-01-17 11:09:20',15,'2022-01-17 11:10:20',0.30), --32
('Arveja','2022-01-17 11:11:20',13,'2022-01-17 11:12:20',0.30), --33
('Chaucha','2022-01-17 11:13:20',10,'2022-01-17 11:14:20',0.30), --34
('Soja','2022-01-17 11:15:20',15,'2022-01-17 11:16:20',0.70), --35
('Garbanzo','2022-01-17 11:17:20',11,'2022-01-17 11:18:20',0.30), --36
('Alfalfa','2022-01-17 11:20:20',40,'2022-01-17 11:21:20',0.50), --37
('Poroto manteca','2022-01-17 11:22:20',2,'2022-01-17 11:24:20',0.30), --38

--Solanaceas
('Papa','2022-01-18 09:31:20',7,'2022-01-18 09:32:20',0.15), --39
('Tomate','2022-01-18 09:33:20',10,'2022-01-18 09:34:20',3), --40
('Locote','2022-01-18 09:36:20',17,'2022-01-18 09:37:20',2), --41
('Berenjena','2022-01-18 09:39:20',19,'2022-01-18 09:40:20',2), --42

--Liliaceas
('Cebolla','2022-01-19 13:42:20',3,'2022-01-19 13:43:20',0.50), --43
('Cebollita de verdeo','2022-01-19 13:44:20',11,'2022-01-19 13:45:20',0.70), --44
('Ajo','2022-01-19 13:46:20',1,'2022-01-19 13:47:20',0.50), --45
('Puerro','2022-01-19 13:48:20',23,'2022-01-19 13:49:20',1), --46
('Esparrago','2022-01-19 13:50:20',6,'2022-01-19 13:51:20',3), --47

--Florales
('Aelea','2022-02-20 06:15:20',21,'2022-02-20 06:16:20',2.22), --48
('Anturio','2022-02-20 06:17:20',12,'2022-02-20 06:18:20',1.70), --49
('Bromelia','2022-02-20 06:19:20',11,'2022-02-20 06:20:20',3.75), --50
('Buganvilla','2022-02-20 06:21:20',10,'2022-02-20 06:22:20',2.11), --51
('Calendula','2022-02-20 06:23:20',20,'2022-02-20 06:24:20',3.55), --52
('Clavel','2022-02-20 06:15:25',10,'2022-02-20 06:27:20',4), --53

('Crisantemo','2022-02-21 07:50:25',10,'2022-02-21 07:51:25',2.90), --54
('Dalia','2022-02-21 07:52:25',12,'2022-02-21 07:53:25',3.60), --55
('Espatifilo','2022-02-21 07:55:25',11,'2022-02-21 07:56:25',1.69), --56
('Flor de loto','2022-02-21 07:57:25',14,'2022-02-21 07:58:25',6.70), --57
('Gradenia','2022-02-21 07:59:25',14,'2022-02-21 08:00:25',3.90), --58

('Granio','2022-02-23 13:42:20',10,'2022-02-23 13:43:20',3.10), --59
('Jazmin','2022-02-23 13:44:20',10,'2022-02-23 13:45:20',4), --60
('Kalanchoe','2022-02-23 13:46:20',10,'2022-02-23 13:47:20',3), --61
('Lirio','2022-02-23 13:48:20',11,'2022-02-23 13:49:20',3.20), --62
('Margarita','2022-02-23 13:50:20',10,'2022-02-23 13:51:20',2.90), --63

('Orquidea','2022-02-27 10:00:00',9,'2022-02-27 10:01:00',5), --64
( 'Pensamiento','2022-02-27 10:02:00',8,'2022-02-27 10:03:00',4), --65
('Petunia','2022-02-27 10:04:00',11,'2022-02-27 10:05:00',3), --66
('Tulipan','2022-02-27 10:06:00',15,'2022-02-27 10:07:00',5), --67
('Verbena','2022-02-27 10:08:00',12,'2022-02-27 10:09:00',2), --68

('Rosa Roja','2022-02-27 10:10:00',14,'2022-02-27 10:11:00',4), --69
('Rosa blanca','2022-02-27 10:12:00',14,'2022-02-27 10:13:00',4), --70
('Rosa negra','2022-02-27 10:14:00',14,'2022-02-27 10:15:00',4), --71
('Rosa amarilla','2022-02-27 10:16:00',14,'2022-02-27 10:17:00',4), --72
('Rosa azul','2022-02-27 10:18:00',14,'2022-02-27 10:19:00',4), --73

--Arbustos frutales 2017
('Arandano','2017-02-27 10:10:00',151,'2017-02-27 10:11:00',95), --74
('Frambuesa','2017-02-27 10:12:00',130,'2017-02-27 10:13:00',75), --75
('Madroño','2017-02-27 10:14:00',160,'2017-02-27 10:15:00',87), --76
('Mora','2017-02-27 10:16:00',130,'2017-02-27 10:17:00',70), --77
('Grosella','2017-02-27 10:18:00',170,'2017-02-27 10:19:00',110), --78

--Arbustos sin fruto 2018
('Grosella','2018-02-27 10:18:00',170,'2018-02-27 10:19:00',80), --79
('Malva imperial','2018-02-27 10:12:00',130,'2018-02-27 10:13:00',63), --80
('Veigelia','2018-02-27 10:14:00',160,'2018-02-27 10:15:00',77), --81
('Adelfa','2018-02-27 10:16:00',130,'2018-02-27 10:17:00',60), --82
('Ceanoto','2018-02-27 10:18:00',170,'2018-02-27 10:19:00',97), --83

--Arbustos sin fruto 2019
('Celinda de espigas','2019-02-27 10:18:00',170,'2019-02-27 10:19:00',70), --84
('Durillo','2019-02-27 10:12:00',130,'2019-02-27 10:13:00',62), --85
('Abelia','2019-02-27 10:14:00',160,'2019-02-27 10:15:00',76), --86
('Veigelia','2019-02-27 10:16:00',130,'2019-02-27 10:17:00',59), --87
( 'Griñolera','2019-02-27 10:18:00',170,'2019-02-27 10:19:00',95), --88

--Arboles frutales
('Manzano','2018-02-28 10:18:00',180,'2018-02-28 10:19:00',150), --89
('Naranjo','2018-02-28 10:12:00',125,'2018-02-28 10:13:00',130), --90
('Limonero','2018-02-28 10:14:00',162,'2018-02-28 10:15:00',115), --91
('Peral','2019-02-28 10:24:00',131,'2019-02-28 10:25:00',130), --92
('Mango','2019-02-28 10:27:00',173,'2019-02-28 10:28:00',210), --93

--Arboles sin fruto
('Roble','2019-02-28 10:18:00',189,'2019-02-28 10:19:00',190), --94
('Pino','2019-02-28 10:12:00',175,'2019-02-28 10:13:00',137), --95
('Eucalipto','2018-02-28 10:14:00',162,'2018-02-28 10:15:00',120), --96
('Anacahuita','2018-02-28 10:16:00',90,'2018-02-28 10:17:00',108), --97
('Coronilla','2018-02-28 10:18:00',100,'2018-02-28 10:19:00',75) --98
;

---- PLANTAS CON ERRORES ----
insert into Plantas(nombrePlanta,fechaNac,alturaCM,fechaHoraMedida,precioDolares) values
--Error en la fecha de medida menor a fecha de nacimiento OK
('Error1','2018-02-28 10:18:00',100,'2016-02-28 10:19:00',150),
--Error precio en dolares mayor a 0 OK
('Error2','2018-02-28 10:18:00',180,'2018-02-28 10:19:00',0),
--Error Hora de medida Mayor a la fecha actual OK
('Error3','2018-02-28 10:18:00',180,'2023-02-28 10:19:00',150),
--Error en la altura Fuera de rango 1-12000 OK
('Error4','2018-02-28 10:18:00',20000,'2018-02-28 10:19:00',150),
--Error en Fecha de nacimiento Mayor a la fecha actual OK
('Error5','2023-02-28 10:18:00',180,'2018-02-28 10:19:00',150)
---- PLANTAS CON ERRORES ----


INSERT INTO PlantasTieneTags(idPlantaFK,idTagFK) values
--SIN ESPINAS
(7,17),
(10,17),
(17,17),
(19,17),
(26,17),

--CON ESPINAS
(91,18),
(62,18),
(63,18),
(64,18),
(65,18),
(66,18),

--SIN FLOR
(12,4),
(20,4),
(21,4),
(89,4),
(87,4),
(88,4),
(91,4),

--CON FLOR 5
(62,5),
(63,5),
(64,5),
(65,5),
(66,5),
(50,5),

--PERFUMA 13
(62,13),
(63,13),
(64,13),
(65,13),
(66,13),
(50,13),

--con tag tronco roto, perfuma y frutal 
(83,13),
(85,1),
(85,13),
(83,2),
(85,2),
(82,2),
(82,1),
(82,13),

--con tagperfuma y frutal
(84,1),
(84,13),
(86,1),
(86,13),
(67,1),
(67,13)
;


INSERT INTO Mantenimientos(fechaHoraMant, descripcionMant, idPlantaFk )
VALUES
('2018-01-25 10:29:02', 'Transplante de maceta',1), 
('2021-12-26 11:22:22', 'Poda',2),
('2018-03-27 10:19:30', 'Cosecha',3),
('2022-04-28 10:29:02', 'Hidratacion',4),
('2022-04-29 10:29:41', 'Transplante de maceta',5),
('2021-06-30 10:21:03', 'Transplante de maceta',6),
('2021-07-02 11:22:12', 'Renovacion de cultivo',7),
('2022-01-23 12:23:52', 'Cosecha',8),
('2022-01-24 13:24:42', 'Hidratacion',9),
('2022-02-25 14:25:32', 'Cosecha',10),
('2022-01-26 15:23:22', 'Cosecha',11),
('2022-01-27 16:29:12', 'Cosecha',12),

('2022-01-25 10:29:02', 'Poda',13),
('2022-01-26 11:22:22', 'Poda',14),
('2022-01-27 10:19:30', 'Poda',15),
('2022-01-28 10:29:02', 'Poda',16),
('2022-01-29 10:29:41', 'Hidratacion',17),
('2022-01-30 10:21:03', 'Hidratacion',18),
('2022-02-02 11:22:12', 'Transplante de maceta',19),
('2022-02-23 12:23:52', 'Hidratacion',20),
('2022-02-24 13:24:42', 'Transplante de maceta',21),
('2022-02-25 14:25:32', 'Hidratacion',22),
('2022-02-26 15:23:22', 'Transplante de maceta',23),
('2022-02-27 16:29:12', 'Transplante de maceta',24),

('2022-01-25 10:29:02', 'Hidratacion',25),
('2022-01-26 11:22:22', 'Poda',26),
('2022-01-27 10:19:30', 'Poda',27),
('2022-01-28 10:29:02', 'Poda',28),
('2022-01-29 10:29:41', 'Hidratacion',29),
('2022-01-30 10:21:03', 'Hidratacion',30),
('2022-02-02 11:22:12', 'Hidratacion',31),
('2022-01-23 12:23:52', 'Hidratacion',32),
('2022-01-24 13:24:42', 'Hidratacion',33),
('2022-01-25 14:25:32', 'Transplante de maceta',34),
('2022-01-26 15:23:22', 'Transplante de maceta',35),
('2022-01-27 16:29:12', 'Transplante de maceta',36),

('2022-01-25 10:29:02', 'Cosecha',37),
('2022-01-26 11:22:22', 'Renovacion de cultivo',38),
('2022-01-27 10:19:30', 'Renovacion de cultivo',39),
('2022-01-28 10:29:02', 'Cosecha',40),
('2022-01-29 10:29:41', 'Poda',41),
('2022-01-30 10:21:03', 'Poda',42),
('2022-01-20 11:22:12', 'Poda',43),
('2022-02-23 12:23:52', 'Transplante de maceta',44),
('2022-03-24 13:24:42', 'Transplante de maceta',45),
('2022-04-25 14:25:32', 'Transplante de maceta',46),
('2022-04-26 15:23:22', 'Hidratacion',47),
('2022-04-27 16:29:12', 'Poda',48),

('2022-02-25 11:29:02', 'Colocacion de Tierra Abonada en Instalacion Principal',49),
('2022-02-26 12:22:22', 'Colocacion de Humus de lombriz en Instalacion Principal',50),
('2022-02-27 13:19:30', 'Colocacion Tierra Organica para Hortalizas en Instalacion Principal',51),
('2022-02-28 14:29:02', 'Colocacion de Perlita a la Tierra Abonada en la Instalacion Principal',52),
('2022-02-28 15:29:41', 'Colocacion de Nitrogeno en tierra de la Instalacion Principal',53),
('2022-03-01 16:21:03', 'Colocacion de Fosforo en tierra de la Instalacion Principal',54),
('2022-03-02 15:22:12', 'Colocacion de Carbon en tierra de la Instalacion Principal',55),
('2022-03-03 14:23:52', 'Colocacion de Lombrices en tierra de la Instalacion Principal',56),
('2022-03-04 13:24:42', 'Colocacion de Mata Yuyos en tierra de la Instalacion Principal',57),
('2022-03-25 14:25:32', 'Colocacion de Productos enraizantes en la tierra de Instalacion Principal',58),
('2022-03-26 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la Instalacion Principal',59),
('2022-03-27 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la Instalacion Principal',60),
('2022-03-25 10:19:02', 'Colocacion de Tierra Abonada en seccion 1',61),
('2022-03-26 11:32:22', 'Colocacion de Humus de lombriz en seccion 1',62),
('2022-04-27 10:47:30', 'Colocacion Tierra Organica para Hortalizas en seccion 1',63),
('2022-05-28 10:56:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 1',65),
('2022-02-28 10:15:41', 'Colocacion de Nitrogeno en tierra de la seccion 1',65),
('2022-03-30 10:24:03', 'Colocacion de Fosforo en tierra de la seccion 1',66),
('2022-03-02 11:35:12', 'Colocacion de Carbon en tierra de la seccion 1',67),
('2022-03-23 12:44:52', 'Colocacion de Lombrices en tierra de la seccion 1',68),
('2022-03-24 13:54:42', 'Colocacion de Mata Yuyos en tierra de la seccion 1',69),
('2022-03-25 14:25:32', 'Colocacion de Productos enraizantes en la seccion 1',70),
('2022-03-26 15:43:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 1',71),
('2022-03-27 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 1',72),
('2022-03-25 10:29:02', 'Colocacion de Tierra Abonada en seccion 2',73),
('2017-03-26 11:22:22', 'Colocacion de Humus de lombriz en seccion 2',74),
('2017-03-27 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 2',75),
('2017-06-28 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 2',76),
('2017-07-29 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 2',77),
('2017-08-30 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 2',78),
('2018-03-02 11:22:12', 'Colocacion de Carbon en tierra de la seccion 2',79),
('2018-04-23 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 2',80),
('2018-04-24 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 2',81),
('2018-05-21 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 2',82),
('2021-12-22 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 2',83),
('2021-12-23 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 2',84),
('2021-03-25 10:29:02', 'Colocacion de Tierra Abonada en seccion 3',85),
('2021-04-26 11:22:22', 'Colocacion de Humus de lombriz en seccion 3',86),
('2021-05-27 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 3',87),
('2021-06-28 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 3',87),

('2021-07-29 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 3',88),
('2021-08-30 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 3',89),
('2021-09-02 11:22:12', 'Colocacion de Carbon en tierra de la seccion 3',90),
('2022-01-23 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 3',91),
('2022-01-24 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 3',1),
('2022-01-25 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 3',2),
('2022-01-27 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 3',3),
('2022-01-12 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 3',4),

-------  nuevos insert del 2021
('2021-02-25 11:29:02', 'Colocacion de Tierra Abonada en Instalacion Principal',1),
('2021-02-26 12:22:22', 'Colocacion de Humus de lombriz en Instalacion Principal',1),
('2021-02-27 13:19:30', 'Colocacion Tierra Organica para Hortalizas en Instalacion Principal',1),
('2021-02-28 14:29:02', 'Colocacion de Perlita a la Tierra Abonada en la Instalacion Principal',3),
('2021-02-28 15:29:41', 'Colocacion de Nitrogeno en tierra de la Instalacion Principal',3),
('2021-02-28 16:21:03', 'Colocacion de Fosforo en tierra de la Instalacion Principal',3),
('2021-03-02 15:22:12', 'Colocacion de Carbon en tierra de la Instalacion Principal',21),
('2021-03-23 14:23:52', 'Colocacion de Lombrices en tierra de la Instalacion Principal',21),
('2021-03-24 13:24:42', 'Colocacion de Mata Yuyos en tierra de la Instalacion Principal',21),
('2021-03-25 14:25:32', 'Colocacion de Productos enraizantes en la tierra de Instalacion Principal',21),
('2021-03-26 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la Instalacion Principal',22),
('2021-03-27 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la Instalacion Principal',22),
('2021-04-05 10:19:02', 'Colocacion de Tierra Abonada en seccion 1',22),
('2021-04-26 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 2',74),
('2021-04-27 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 2',74),
('2021-04-28 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 2',75),
('2021-04-29 10:29:02', 'Colocacion de Tierra Abonada en seccion 3',76),
('2021-04-30 11:22:22', 'Colocacion de Humus de lombriz en seccion 3',77),
('2021-05-02 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 3',78),
('2021-05-03 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 3',79),
('2021-05-04 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 3',80),
('2021-05-05 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 3',81),
('2021-05-06 11:22:12', 'Colocacion de Carbon en tierra de la seccion 3',82),
('2021-05-07 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 3',83),
('2021-05-08 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 3',84),
('2021-05-09 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 3',85),
('2021-05-10 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 3',86),
('2021-05-11 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 3',87),

-------  nuevos insert del 2022
('2022-01-25 11:29:02', 'Colocacion de Tierra Abonada en Instalacion Principal',88),
('2022-01-26 12:22:22', 'Colocacion de Humus de lombriz en Instalacion Principal',1),
('2022-01-27 13:19:30', 'Colocacion Tierra Organica para Hortalizas en Instalacion Principal',1),
('2022-01-28 14:29:02', 'Colocacion de Perlita a la Tierra Abonada en la Instalacion Principal',1),
('2022-01-29 15:29:41', 'Colocacion de Nitrogeno en tierra de la Instalacion Principal',1),
('2022-01-30 16:21:03', 'Colocacion de Fosforo en tierra de la Instalacion Principal',1),
('2022-02-02 15:22:12', 'Colocacion de Carbon en tierra de la Instalacion Principal',3),
('2022-02-23 14:23:52', 'Colocacion de Lombrices en tierra de la Instalacion Principal',3),
('2022-02-24 13:24:42', 'Colocacion de Mata Yuyos en tierra de la Instalacion Principal',3),
('2022-02-25 14:25:32', 'Colocacion de Productos enraizantes en la tierra de Instalacion Principal',3),
('2022-02-26 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la Instalacion Principal',3),
('2022-02-27 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la Instalacion Principal',3),
('2022-02-28 10:19:02', 'Colocacion de Tierra Abonada en seccion 1',21),
('2022-03-26 11:32:22', 'Colocacion de Humus de lombriz en seccion 1',21),
('2022-03-27 10:47:30', 'Colocacion Tierra Organica para Hortalizas en seccion 1',21),
('2022-03-28 10:56:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 1',21),
('2022-03-29 10:15:41', 'Colocacion de Nitrogeno en tierra de la seccion 1',21),
('2022-03-30 10:24:03', 'Colocacion de Fosforo en tierra de la seccion 1',21),
('2022-04-02 11:35:12', 'Colocacion de Carbon en tierra de la seccion 1',22),
('2022-04-03 12:44:52', 'Colocacion de Lombrices en tierra de la seccion 1',22),
('2022-04-04 13:54:42', 'Colocacion de Mata Yuyos en tierra de la seccion 1',22),
('2022-04-05 14:25:32', 'Colocacion de Productos enraizantes en la seccion 1',22),
('2022-04-06 15:43:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 1',22),
('2022-04-07 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 1',67),
('2022-04-15 10:29:02', 'Colocacion de Tierra Abonada en seccion 2',67),
('2022-04-16 11:22:22', 'Colocacion de Humus de lombriz en seccion 2',67),
('2022-04-17 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 2',67),
('2022-04-18 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 2',67),
('2022-04-19 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 2',67),
('2022-04-20 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 2',68),
('2022-05-02 11:22:12', 'Colocacion de Carbon en tierra de la seccion 2',68),
('2022-05-03 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 2',68),
('2022-05-04 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 2',68),
('2022-05-05 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 2',68),
('2022-05-06 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 2',68),
('2022-05-07 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 2',68),
('2022-05-08 10:29:02', 'Colocacion de Tierra Abonada en seccion 3',68),
('2022-05-08 11:22:22', 'Colocacion de Humus de lombriz en seccion 3',68),
('2022-05-09 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 3',68),
('2022-05-09 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 3',68),
('2022-05-09 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 3',68),
('2022-05-10 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 3',69),
('2022-05-10 11:22:12', 'Colocacion de Carbon en tierra de la seccion 3',69),
('2022-05-10 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 3',89),
('2022-05-10 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 3',90),
('2022-05-10 14:25:32', 'Colocacion de Productos enraizantes en la tierra de seccion 3',90),
('2022-05-10 15:23:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 3',91),
('2022-04-06 11:32:22', 'Colocacion de Humus de lombriz en seccion 1',67),
('2022-04-07 10:47:30', 'Colocacion Tierra Organica para Hortalizas en seccion 1',67),
('2022-04-08 10:56:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 1',67),
('2022-04-09 10:15:41', 'Colocacion de Nitrogeno en tierra de la seccion 1',68),
('2022-04-10 10:24:03', 'Colocacion de Fosforo en tierra de la seccion 1',68),
('2022-04-11 11:35:12', 'Colocacion de Carbon en tierra de la seccion 1',68),
('2022-04-12 12:44:52', 'Colocacion de Lombrices en tierra de la seccion 1',69),
('2022-04-13 13:54:42', 'Colocacion de Mata Yuyos en tierra de la seccion 1',69),
('2022-04-14 14:25:32', 'Colocacion de Productos enraizantes en la seccion 1',69),
('2022-04-15 15:43:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 1',70),
('2022-04-16 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 1',70),
('2022-04-17 10:29:02', 'Colocacion de Tierra Abonada en seccion 2',70),
('2022-04-18 11:22:22', 'Colocacion de Humus de lombriz en seccion 2',71),
('2022-04-19 10:19:30', 'Colocacion Tierra Organica para Hortalizas en seccion 2',71),
('2022-04-20 10:29:02', 'Colocacion de Perlita a la Tierra Abonada en la seccion 2',71),
('2022-04-21 10:29:41', 'Colocacion de Nitrogeno en tierra de la seccion 2',72),
('2022-04-22 10:21:03', 'Colocacion de Fosforo en tierra de la seccion 2',72),
('2022-04-23 11:22:12', 'Colocacion de Carbon en tierra de la seccion 2',72),
('2022-04-24 12:23:52', 'Colocacion de Lombrices en tierra de la seccion 2',73),
('2022-04-25 13:24:42', 'Colocacion de Mata Yuyos en tierra de la seccion 2',73),
('2022-05-10 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 3',91),

-- los 11 mantenimientos de una planta que usa todos los productos
('2022-03-01 10:24:03', 'Colocacion de Fosforo en tierra de la seccion 1',65),
('2022-03-02 11:35:12', 'Colocacion de Carbon en tierra de la seccion 1',65),
('2022-03-23 12:44:52', 'Colocacion de Lombrices en tierra de la seccion 1',65),
('2022-03-24 13:54:42', 'Colocacion de Mata Yuyos en tierra de la seccion 1',65),
('2022-03-25 14:25:32', 'Colocacion de Productos enraizantes en la seccion 1',65),
('2022-03-26 15:43:22', 'Colocacion de Abono Polivalente en Hortalizas de la seccion 1',65),
('2022-03-27 16:29:12', 'Colocacion de Azufre, fosforo, potasio y nitrogeno en partes necesitadas de la seccion 1',65),
('2022-03-25 10:29:02', 'Colocacion de Tierra Abonada en seccion 2',65),
('2022-03-26 11:22:22', 'Colocacion de Humus de lombriz en seccion 2',65)
;






--- MANTENIMIENTOS CON ERRORES ---
INSERT INTO Mantenimientos(fechaHoraMant, descripcionMant, idPlantaFk )
VALUES
--Error1 Fecha de mantenimiento menor a la fecha de la planta 
--(no da mensaje de error porque lo controla el trigger)
('2009-01-25 10:29:02', 'Transplante de maceta',1), 
--Error2 fecha de mantenimiento mayor a la fecha actual
('2023-12-26 11:22:22', 'Poda',2)
--- MANTENIMIENTOS CON ERRORES ---









-- Insert de Mantenimientos Operativos
INSERT INTO MantOperativos(idMantOperativos, cantHoras, costoOperacion)
VALUES
( 1, 28, 500.30),
( 2, 18, 1500.00),
( 3, 28, 1405.10),
( 4, 38, 1200.00),
( 5, 15, 800.30),
( 6, 18, 600.00),
( 7, 16, 500.50),
( 8, 28, 700.40),
( 9, 38, 800.30),
(10, 54, 900.20),
(11, 38, 2500.10),
(12, 28, 1500.00),
(13, 8, 550.30),
(14, 6, 1550.00),
(15, 7, 1455.10),
(16, 5, 1250.00),
(17, 7, 850.30),
(18, 6, 650.00),
(19, 4, 550.50),
(20, 5, 750.40),
(21, 3, 850.30),
(22, 5, 950.20),
(23, 18, 2550.10),
(24, 24, 1550.00),
(25, 18, 650.30),
(26, 6, 2550.00),
(27, 7, 1455.10),
(28, 5, 1250.00),
(29, 7, 850.30),
(30, 6, 650.00),
(31, 24, 550.50),
(32, 25, 750.40),
(33, 23, 850.30),
(34, 5, 950.20),
(35, 28, 2550.10),
(36, 14, 1550.00),
(37, 1, 50.20),
(38, 2, 550.00),
(39, 3, 455.10),
(40, 1, 250.00),
(41, 2, 250.30),
(42, 3, 250.00),
(43, 2, 150.50),
(44, 3, 250.40),
(45, 2, 150.30),
(46, 2, 240.20),
(47, 2, 230.10),
(48, 4, 450.00),
-- solo 2021
( 97, 28, 50.30),
( 98, 18, 150.00),
( 99, 28, 140.10),
(100, 28, 140.10),
(101, 38, 120.00),
(102, 15, 80.30),
(103, 18, 60.00),
(104, 16, 50.50),
(105, 28, 70.40),
(106, 38, 80.30),
(107, 54, 90.20),
(108, 38, 250.10),
(109, 28, 15.00),
(110, 8, 55.30),
(111, 6, 150.00),
(112, 7, 145.10),
(113, 5, 120.00),
(114, 7, 85.30),
(115, 6, 65.00),
(116, 4, 55.50),
(117, 5, 75.40),
(118, 3, 85.30),
(119, 5, 95.20),
(120, 18, 255.10),
(121, 24, 155.00),
(122, 18, 65.30),
(123, 6, 250.00),
(124, 7, 145.10),
(125, 5, 120.00),
(126, 7, 85.30),
(127, 6, 65.00),
(128, 24, 50.50),
(129, 25, 70.40),
(130, 23, 80.30),
(131, 5, 90.20),
(132, 28, 250.10),
(133, 14, 150.00),
(134, 1, 50.20),
(135, 2, 55.00),
(136, 3, 45.10),
(137, 1, 25.00),
(138, 2, 25.30),
(139, 3, 25.00),
(140, 2, 15.50),
(141, 3, 25.40),
(142, 2, 15.30),
(143, 2, 24.20),
(144, 2, 23.10)
;

--- MANTENIMIENTOS OP CON ERRORES ---
INSERT INTO MantOperativos(idMantOperativos, cantHoras, costoOperacion)
VALUES
--Error1 Cantidad de horas menor a 0, tambien en numero de mantenimiento no existe
( 1000, 0, 500.30),
--Error2 Costo de la operacion mayor a 0
( 200, 18, 0),
--Error3 id repetido
( 2, 18, 1500.00),
--- MANTENIMIENTOS OP CON ERRORES ---


INSERT INTO Productos(idCodigoProducto,descripcionProd,precioActualxGramo) 
values 
('AAA12','Abono vitaminizador de tierra', 5.75),
('ABC11','Fertilizante natural que proporciona excelentes resultados para el crecimiento vegetal', 6.50),
('CCC99','Nitrógeno atmosférico, es fundamental para que nuestros suelos sean lugares de vida', 8.70),
('NNN46','Fósforo es usado por las plantas para ayudar a formar nuevas raíces, producir semillas, frutos y flores',6.55),
('ZZZ88','Carbón vegetal en el suelo funciona como un catalizador de la actividad vital de la biosfera de la capa del humus',8.45),
('XNM77','La lombriz de tierra es fundamental para la salud de la tierra, puesto que se encarga de transportar nutrientes y minerales hasta la superficie',7.55),
('XML56','herbicida organico ecosustentable', 7.20),
('JSO12','Producto compuesto por hormonas vegetales naturales, que tiene como objetivo estimular el crecimiento de raíces',6.95),
('YTO55','Abono para tierra de cultivo, de plantas y flores en jardín y huerto', 4.85),
('POO47','Azufre, permite la formación de proteínas en las plantas', 3.55),
('CMD77','Potasio nutrimentos de gran importancia en el crecimiento y desarrollo de las plantas', 6.30)
;


--- PRODUCTOS CON ERRORES ---
INSERT INTO Productos(idCodigoProducto,descripcionProd,precioActualxGramo) 
values 
--Error Codigo  producto repetido
('AAA12','Descripcion 1', 5.75),
--Error descripcion repetida
('lll99','Abono vitaminizador de tierra', 5.75),
--Error precio actual por gramo menor a 1
('AAO10','Descripcion 2', 0),
--Error codigo de producto fuera de rango, menor o mayor a 5 digitos
('AAA122','Descripcion 3', 5.75),
--- PRODUCTOS CON ERRORES ---



create function CostoAplicacion(@codProd char(5),@cantUtilizada int)returns decimal
as begin 
declare @total decimal;
set @total= (select p.precioActualxGramo  from Productos p 
             where p.idCodigoProducto=@codProd)*@cantUtilizada		
return @total
end

-- TEST PRUEBA DE CONTROL --
/*
Declare @codProd char(5)
Declare @cantProd int
Declare @costoApli decimal
Set @codProd = 'AAA12'
Set @cantProd = 20
Set @costoApli = dbo.CostoAplicacion(@codProd, @cantProd)  

PRINT convert(varchar(12), @costoApli)
*/



--drop table NutUtilizaProd

-- select * from NutUtilizaProd
-- cantidadProd en gramos

DECLARE @costoAplicacion decimal

set @costoAplicacion=dbo.CostoAplicacion('AAA12',50)
INSERT INTO NutUtilizaProd VALUES ('AAA12',49, 50, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ABC11',30)
INSERT INTO NutUtilizaProd values( 'ABC11',50, 30, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',54)
INSERT INTO NutUtilizaProd values( 'CCC99',51, 54, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',55)
INSERT INTO NutUtilizaProd values( 'NNN46',52, 55, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ZZZ88',1000)
INSERT INTO NutUtilizaProd values( 'ZZZ88',53, 1000, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XNM77',250)
INSERT INTO NutUtilizaProd values('XNM77',54, 250, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XML56',450)
INSERT INTO NutUtilizaProd values( 'XML56',55, 450, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('JSO12',690)
INSERT INTO NutUtilizaProd values( 'JSO12',56, 690, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('YTO55',1200)
INSERT INTO NutUtilizaProd values( 'YTO55',57, 1200, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',5600)
INSERT INTO NutUtilizaProd values( 'POO47',58, 5600, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',3000)
INSERT INTO NutUtilizaProd values( 'CMD77',59, 3000, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',300)
INSERT INTO NutUtilizaProd values( 'CCC99',61, 300, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',300)
INSERT INTO NutUtilizaProd values( 'NNN46',62, 300, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',370)
INSERT INTO NutUtilizaProd values( 'POO47',63, 370, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',230)
INSERT INTO NutUtilizaProd values( 'CMD77',64, 230, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('AAA12',510)
INSERT INTO NutUtilizaProd values( 'AAA12',65, 510, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',320)
INSERT INTO NutUtilizaProd values( 'ABC11',66, 320, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',534)
INSERT INTO NutUtilizaProd values( 'CCC99',67, 534, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',545)
INSERT INTO NutUtilizaProd values( 'NNN46',68, 545, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ZZZ88',400)
INSERT INTO NutUtilizaProd values( 'ZZZ88',69, 400, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XNM77',1250)
INSERT INTO NutUtilizaProd values( 'XNM77',70, 1250, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XML56',250)
INSERT INTO NutUtilizaProd values( 'XML56',71, 250, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('JSO12',290)
INSERT INTO NutUtilizaProd values( 'JSO12',72, 290, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',320)
INSERT INTO NutUtilizaProd values( 'YTO55',73, 320, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',460)
INSERT INTO NutUtilizaProd values( 'POO47',74, 460, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',500)
INSERT INTO NutUtilizaProd values( 'CMD77',75, 500, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',20)
INSERT INTO NutUtilizaProd values( 'CCC99',76, 20, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',10)
INSERT INTO NutUtilizaProd values( 'NNN46',77, 10, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',22)
INSERT INTO NutUtilizaProd values( 'POO47',78, 22, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',230)
INSERT INTO NutUtilizaProd values( 'CMD77',79, 12, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('AAA12',316)
INSERT INTO NutUtilizaProd VALUES ('AAA12',80, 316, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ABC11',470)
INSERT INTO NutUtilizaProd values( 'ABC11',81, 470, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',255)
INSERT INTO NutUtilizaProd values( 'CCC99',82, 255, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',556)
INSERT INTO NutUtilizaProd values( 'NNN46',83, 556, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ZZZ88',365)
INSERT INTO NutUtilizaProd values( 'ZZZ88',84, 365, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XNM77',259)
INSERT INTO NutUtilizaProd values('XNM77',85, 259, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XML56',298)
INSERT INTO NutUtilizaProd values( 'XML56',86, 298, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('JSO12',245)
INSERT INTO NutUtilizaProd values( 'JSO12',87, 245, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('YTO55',782)
INSERT INTO NutUtilizaProd values( 'YTO55',88, 782, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',989)
INSERT INTO NutUtilizaProd values( 'POO47',89, 989, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',420)
INSERT INTO NutUtilizaProd values( 'CMD77',90, 420, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',541)
INSERT INTO NutUtilizaProd values( 'CCC99',91, 541, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',256)
INSERT INTO NutUtilizaProd values( 'NNN46',92, 256, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',270)
INSERT INTO NutUtilizaProd values( 'POO47',93, 270, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',850)
INSERT INTO NutUtilizaProd values( 'CMD77',94, 850, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',777)
INSERT INTO NutUtilizaProd values( 'POO47',95, 777, @costoAplicacion)

--juego de prueba para 2.e (mantenimientoNut que usa todos los productos)
set @costoAplicacion=dbo.CostoAplicacion('CMD77',214)
INSERT INTO NutUtilizaProd values( 'CMD77',96, 214, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('AAA12',24)
INSERT INTO NutUtilizaProd values( 'AAA12',96, 24, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ABC11',14)
INSERT INTO NutUtilizaProd values( 'ABC11',96, 14, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',44)
INSERT INTO NutUtilizaProd values( 'CCC99',96, 44, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('NNN46',48)
INSERT INTO NutUtilizaProd values( 'NNN46',96, 48, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ZZZ88',410)
INSERT INTO NutUtilizaProd values( 'ZZZ88',96, 410, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XNM77',45)
INSERT INTO NutUtilizaProd values( 'XNM77',96, 45, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('JSO12',87)
INSERT INTO NutUtilizaProd values( 'JSO12',96, 87, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('YTO55',24)
INSERT INTO NutUtilizaProd values( 'YTO55',96, 24, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XML56',67)
INSERT INTO NutUtilizaProd values( 'XML56',96, 67, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('POO47',99)
INSERT INTO NutUtilizaProd values( 'POO47',96, 99, @costoAplicacion)

----------------------------------
DECLARE @costoAplicacion decimal
set @costoAplicacion=dbo.CostoAplicacion('ZZZ88',410)
INSERT INTO NutUtilizaProd values( 'ZZZ88',191, 410, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XNM77',45)
INSERT INTO NutUtilizaProd values( 'XNM77',192, 45, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('JSO12',87)
INSERT INTO NutUtilizaProd values( 'JSO12',193, 87, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('YTO55',24)
INSERT INTO NutUtilizaProd values( 'YTO55',194, 24, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('XML56',67)
INSERT INTO NutUtilizaProd values( 'XML56',195, 67, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CMD77',214)
INSERT INTO NutUtilizaProd values( 'CMD77',196, 214, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('AAA12',24)
INSERT INTO NutUtilizaProd values( 'AAA12',197, 24, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('ABC11',14)
INSERT INTO NutUtilizaProd values( 'ABC11',198, 14, @costoAplicacion)

set @costoAplicacion=dbo.CostoAplicacion('CCC99',44)
INSERT INTO NutUtilizaProd values( 'CCC99',199, 44, @costoAplicacion)
;


--- NutUtilizaProd ERRORES ---
--ERROR cantidad de producto utilizado menor a 1
--tambien devolveria costo de aplicacion 0 si la cantidad de producto es 0
DECLARE @costoAplicacion decimal
set @costoAplicacion=dbo.CostoAplicacion('OOO02',0)
INSERT INTO NutUtilizaProd VALUES ('OOO02',49, 0, @costoAplicacion)

--ERROR producto no existe
DECLARE @costoAplicacion decimal
set @costoAplicacion=dbo.CostoAplicacion('ooo12',50)
INSERT INTO NutUtilizaProd VALUES ('ooo12',49, 50, @costoAplicacion)
--- NutUtilizaProd ERRORES ---