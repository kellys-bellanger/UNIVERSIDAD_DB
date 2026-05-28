/*Crear una base de datos llamada UniversidadDB la cual maneja dos modos:
academico y seguridad

Modulo academico: Carrera y Estudiante.

Modulo Seguridad: Cargo y Usuario.
*/

use master;
go

if exists(select * from sys.databases where name = 'UniversidadDB')
begin
	drop database UniversidadDB;
end
go

create database UniversidadDB;
go

use UniversidadDB;
go

--Schema: Es un contenedor logico que sirve para organizar obejto dentro de una base de datos.
create schema Academico;
go 

create schema Seguridad;
go

create table Academico.Carrera(
	CarreraID int identity(1,1) constraint PK_CarreraID primary key, --Agrego constraint de clave primaria
	Nombres nvarchar(100) not null,
	Precio decimal(10,2) constraint Precio_CK check (Precio > 0), --Agrego constraint de check para validar que el precio sea mayor a 0
	CreatedAt datetime default getdate(),
	UpdatedAt datetime null,
	DeletedAt datetime
);
go