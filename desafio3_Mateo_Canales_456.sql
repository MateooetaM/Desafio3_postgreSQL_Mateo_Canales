-- Active: 1730336519400@@127.0.0.1@5432@desafio3_Mateo_Canales_456

-- Crear base de datos.
CREATE DATABASE "desafio3_Mateo_Canales_456"

-- Tabla usuarios:
CREATE TABLE usuarios(id SERIAL, email VARCHAR, nombre VARCHAR, apellido VARCHAR, rol VARCHAR);
--DROP TABLE usuarios;

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES 
('matias@gmail.com', 'Matias', 'Lopez', 'Administrador'),
('jeronimo@gmail.com', 'Jeronimo', 'Garcia', 'Administrador'),
('mateo@gmail.com', 'Mateo', 'Canales', 'Usuario'),
('arturo@gmail.com', 'Arturo', 'Sadini', 'Usuario'),
('tomas@gmail.com', 'Tomas', 'Gil', 'Usuario');

SELECT * FROM usuarios;

-- Tabla posts:
CREATE TABLE posts(id SERIAL, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOLEAN, usuario_id BIGINT);

INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
('Titulo 1', 'Lorem ipsu... ', '2019-02-28', '2022-09-03', TRUE, 1),
('Titulo 2', 'Lorem ipsu... ', '2012-04-23', '2019-05-14', FALSE, 2),
('Titulo 3', 'Lorem ipsu... ', '2009-12-09', '2023-03-06', TRUE, 3),
('Titulo 4', 'Lorem ipsu... ', '2018-01-13', '2023-11-29', FALSE, 5);
INSERT INTO posts(titulo, contenido, fecha_creacion, fecha_actualizacion, destacado)
VALUES('Titulo 5', 'Lorem ipsu... ', '2020-10-26', '2024-10-31', TRUE);

SELECT * FROM posts;

-- Tabla comentarios:
CREATE TABLE comentarios(id SERIAL, contenido TEXT, fecha_creacion TIMESTAMP, usuario_id BIGINT, post_id BIGINT);

INSERT INTO comentarios(contenido, fecha_creacion, usuario_id, post_id)
VALUES
('Comentario 1', '2022-09-04', 1, 1),
('Comentario 2', '2022-09-05', 2, 1),
('Comentario 3', '2022-09-07', 3, 1),
('Comentario 4', '2019-05-16', 1, 2),
('Comentario 5', '2019-05-19', 2, 2);

SELECT * FROM comentarios;

    -- REQUERIMIENTOS

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.
SELECT U.nombre, U.email, P.titulo, P.contenido
FROM usuarios U INNER JOIN posts P
ON U.id = P.id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
-- El administrador puede ser cualquier id.
SELECT P.id, P.titulo, P.contenido 
FROM posts P INNER JOIN usuarios U 
ON P.usuario_id = U.id
WHERE u.rol = 'Administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
-- La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT usuarios.id, usuarios.email, COUNT(posts.id) AS cantidad_posts
FROM usuarios LEFT JOIN posts
ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts.
-- Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT usuarios.email 
FROM usuarios JOIN posts 
ON usuarios.id = posts.usuario_id
GROUP BY usuarios.email
ORDER BY COUNT(posts.id) DESC LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.
SELECT usuarios.nombre, posts.fecha_actualizacion AS fecha_ultimo_post
FROM usuarios LEFT JOIN posts
ON usuarios.id = posts.usuario_id
GROUP BY usuarios.nombre, posts.fecha_actualizacion
ORDER BY fecha_actualizacion ASC LIMIT 4;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.
SELECT posts.titulo, posts.contenido, COUNT(comentarios.usuario_id) AS maximo_comentarios
FROM posts 
LEFT JOIN comentarios ON posts.id = comentarios.post_id
GROUP BY posts.id, posts.titulo, posts.contenido
ORDER BY maximo_comentarios DESC LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió.
SELECT posts.titulo, posts.contenido, comentarios.contenido AS comentario_contenido, comentarios.post_id, usuarios.email
FROM posts
LEFT JOIN comentarios ON posts.id = comentarios.post_id
LEFT JOIN usuarios ON comentarios.usuario_id = usuarios.id
ORDER BY posts.titulo;

-- 9. Muestra el contenido del último comentario de cada usuario.
SELECT DISTINCT ON (usuario_id) usuario_id, contenido, fecha_creacion
FROM comentarios
ORDER BY usuario_id, fecha_creacion DESC;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT usuarios.nombre AS usuarios_sin_comentarios, usuarios.email
FROM usuarios 
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
WHERE comentarios.usuario_id IS NULL;