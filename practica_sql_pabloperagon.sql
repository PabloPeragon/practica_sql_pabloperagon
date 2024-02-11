create schema if not exists videoclub;

set schema 'videoclub';

create table socio(
	id_socio serial primary key,
	dni varchar(9) not null,
	nombre varchar(10) not null,
	apellidos varchar(30) not null,
	fecha_nacimiento date not null,
	telefono varchar(9) not null
	);
	
create table direccion_correspondencia(
	id_direccion serial primary key,
	codigo_postal varchar(5),
	calle varchar(50),
	numero varchar(4),
	piso varchar(4),
	id_socio serial
);

create table prestamo(
	id_prestamo serial primary key,
	id_socio serial not null,
	fecha_reserva date not null,
	fecha_entrega date,
	id_copia serial not null
);

create table copia_pelicula(
	id_copia serial primary key,
	titulo_pelicula varchar(50) not null
);


create table pelicula(
	titulo varchar(50) primary key,
	año_publicacion varchar(4) not null,
	genero varchar(25) not null,
	director varchar(50) not null,
	sipnosis varchar(100) not null
);

alter table direccion_correspondencia add constraint fk_socio_direccion_correspondencia
foreign key (id_socio) references socio (id_socio);


alter table prestamo add constraint fk_prestamo_socio
foreign key (id_socio) references socio (id_socio);

alter table prestamo add constraint fk_copia_prestamo
foreign key (id_copia) references copia_pelicula (id_copia);

alter table copia_pelicula add constraint fk_pelicula_copia
foreign key (titulo_pelicula) references pelicula (titulo);

alter table socio add constraint unique_dni
unique (dni);


insert into socio (dni, nombre, apellidos, fecha_nacimiento, telefono) values
('000000001', 'Pablo', 'Peragón Garrido', '1979-08-28', '600100100'),
('000000002', 'Sandy', 'Liébana Liébana', '1978-10-23', '600200200'),
('000000003', 'María', 'Peragón Liébana', '2006-12-08', '600300300'),
('000000004', 'Pablo', 'Peragón Liébana', '2009-07-24', '600400400'),
('000000005', 'Amparo', 'Liébana Liébana', '1990-10-23', '600500500'),
('000000006', 'Domingo', 'Cazalla Angita', '1990-10-23', '600500500');

insert into direccion_correspondencia (codigo_postal, calle, numero, piso) values
('23658', 'av. Madrid', '3','1'),
('23658', 'av. Granada', '1','5'),
('23658', 'av. Jaén', '8','10'),
('23658', 'av. Martos', '4','3'),
('23658', 'av. Cordoba', '9','5'),
('23658', 'av. Sevilla', '5','3');

insert into pelicula (titulo, año_publicacion, genero, director, sipnosis) values
('Amélie', '2001', 'Romance', 'Jean-Pierre', 'Narra la historia de una niña que nace aislada'),
('Star Wars: El retorno del Jedi', '1983', 'Blocbuster', 'Richard Marquand', 'En una galaxia muy lejana...'),
('Vengadores Endgame', '2019', 'Superhéroes', 'Anthony y Joe Russo', 'Días despues del chasquido de Thanos...'),
('Braveheart', '1985', 'Drama historico', 'Mel Gibson', 'En 1280, el rey Eduardo I invade Escocia.'),
('Coco', '2017', 'Animación', 'Adrian Molina', 'La trama tiene lugar en un pueblo Mexicano.');


insert into copia_pelicula (titulo_pelicula) values
('Amélie'),
('Amélie'),
('Star Wars: El retorno del Jedi'),
('Star Wars: El retorno del Jedi'),
('Star Wars: El retorno del Jedi'),
('Star Wars: El retorno del Jedi'),
('Vengadores Endgame'),
('Vengadores Endgame'),
('Vengadores Endgame'),
('Braveheart'),
('Coco'),
('Coco'),
('Coco');


insert into prestamo (id_socio, fecha_reserva, id_copia) values
('3', '2024-01-10', '13'),
('6', '2024-01-12', '10'),
('4', '2024-01-12', '7'),
('1', '2024-01-20', '3'),
('2', '2024-01-21', '12'),
('5', '2024-01-21', '11');


/*
/* contar el numero de copias de cada pelicula */
select cp.titulo_pelicula, count(*) as num_copy_peliculas
from copia_pelicula cp
group by cp.titulo_pelicula;
*/



/* Me dice las copias disponibles que hay de cada pelicula */ 
select cp.titulo_pelicula, count(*) as numero_copias
from (select id_copia from copia_pelicula where id_copia not in 
(select id_copia from prestamo where fecha_reserva is not null or fecha_entrega is not null)) as cd
join copia_pelicula cp on cd.id_copia = cp.id_copia
group by cp.titulo_pelicula;


/*
/* Cuenta los generos favoritos de cada socio*/
SELECT
    s.id_socio,
    s.nombre,
    s.apellidos,
    p.genero AS genero_favorito
FROM
    socio s
JOIN
    prestamo pr ON s.id_socio = pr.id_socio
JOIN
    copia_pelicula cp ON pr.id_copia = cp.id_copia
JOIN
    pelicula p ON cp.titulo_pelicula = p.titulo
GROUP BY
    s.id_socio, p.genero
having COUNT(*) = (
        SELECT
            MAX(cnt)
        FROM
            (SELECT
                s.id_socio,
                p.genero,
                COUNT(*) AS cnt
            FROM
                socio s
            JOIN
                prestamo pr ON s.id_socio = pr.id_socio
            JOIN
                copia_pelicula cp ON pr.id_copia = cp.id_copia
            JOIN
                pelicula p ON cp.titulo_pelicula = p.titulo
            GROUP BY
                s.id_socio, p.genero) AS subquery
        WHERE
            subquery.id_socio = s.id_socio
    );
    
    */
