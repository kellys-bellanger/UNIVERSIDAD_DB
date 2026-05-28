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
)
go

create table Academico.Estudiante(
	EstudianteID int identity(1,1) constraint PK_EstudianteID primary key, --Agrego constraint de clave primaria
	CIF varchar(8) not null constraint uq_Estudiante_CIF unique, --Agrego constraint de unique para asegurar que el CIF sea unico en la tabla
	Nombres nvarchar(60) not null,
	Apellidos nvarchar(60) not null,
	FechaNacimiento datetime null,
	Email nvarchar(255) null constraint ck_Estudiante_Email check (Email like '%@%.%'), --Agrego constraint de check para validar que el email tenga un formato correcto
	Telefono varchar(20) null,
	Carrera_ID int constraint fk_Estudiante_Carrera foreign key references Academico.Carrera(CarreraID), --Agrego constraint de foreign key para relacionar con la tabla Carrera
)
go

create table Seguridad.Cargo(
	CargoID int identity(1,1) constraint PK_CargoID primary key, --Agrego constraint de clave primaria
	Nombres nvarchar(60) not null,
	CreatedAt datetime default getdate(),
	UpdatedAt datetime null,
	DeletedAt datetime
)
go

create table Seguridad.Usuario(
	UsuarioID int identity(1,1) constraint PK_UsuarioID primary key, --Agrego constraint de clave primaria
	CIF varchar(8) not null constraint UQ_Usuario_CIF unique, --Agrego constraint de unique para asegurar que el CIF sea unico en la tabla
	Nombres nvarchar(60) not null,
	Apellidos nvarchar(60) not null,
	FechaNacimiento datetime null,
	pw varbinary(64) not null,
	Email nvarchar(255) null constraint CK_Usuario_Email check (Email like '%@%.%'), --Agrego constraint de check para validar que el email tenga un formato correcto
	Cargo_ID int constraint FK_Usuario_Cargo foreign key references Seguridad.Cargo(CargoID), --Agrego constraint de foreign key para relacionar con la tabla Cargo
	CreatedAt datetime default getdate(),
	UpdatedAt datetime null,
	DeletedAt datetime
)
go

-- Primero insertamos un Cargo obligatorio (Requisito por la nueva FK que agregamos para cumplir las reglas)
INSERT INTO Seguridad.Cargo (Nombres) VALUES (N'Administrador');

INSERT INTO Academico.Carrera(nombres, precio) VALUES('Ingenieria de Software', 1500);
GO 

SELECT * FROM Academico.Carrera;
GO

UPDATE Academico.Carrera SET Precio = 2000, UpdatedAt = getdate() WHERE CarreraID = 1;
GO

-- Insert de Usuario usando el HASHBYTES
INSERT INTO Seguridad.Usuario(cif, nombres, apellidos, FechaNacimiento, pw, Email, Cargo_ID)
VALUES('401', 'an', 'Perez', '1995-10-20', HASHBYTES('SHA2_256', 'Temp2026'), 'admin@universidad.edu.ni', 1);
GO

-- Select final de usuarios para verificar la clave encriptada
SELECT * FROM Seguridad.Usuario;
GO