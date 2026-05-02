-- ====================================================================
-- Parte A: Construcción [En lab05.doc afterRide.sql]
-- ====================================================================

-- 1. Consulten la información que actualmente está en la tabla. ¿Cuántos datos tiene?
SELECT * FROM mbda.data;

-- 2. Inclúyanse como participantes (usen sus correos). Capturen una pantalla de esta información en DATA.
INSERT INTO mbda.DATA (NUMERO, PAIS, CORREO, NOMBRE, APELLIDO, NACIMIENTO, CATEGORIA)
VALUES ('1053442983', 'Colombia', 'oscar.lasso-m@mail.escuelaing.edu.co', 'Oscar', 'Lasso', '2005-08-10', '5');

COMMIT;

-- 3. Traten de modificarse o borrarse. ¿qué pasa?
UPDATE mbda.DATA SET APELLIDO = 'Martinez' WHERE NUMERO = '1053442983';
DELETE FROM mbda.DATA WHERE NUMERO = '1021312556';

-- 4. Escriban la instrucción necesaria para otorgar los permisos que actualmente tiene esa tabla. ¿quién la escribió?
SELECT GRANTOR, GRANTEE, PRIVILEGE, GRANTABLE
FROM ALL_TAB_PRIVS
WHERE TABLE_NAME = 'DATA' AND OWNER = 'MBDA';

GRANT SELECT, INSERT, UPDATE, DELETE ON mbda.DATA TO "oscar.lasso-m";

-- 5. Escriban las instrucciones necesarias para importar los datos de esa tabla a su base de datos como participantes. Los datos deben insertados en las tablas de su base de datos, considerando: Todos los participantes se identifican por la cédula de ciudadanía. Las categorías mayores a 5 se convierten en categoría 5 y las menores a 1 en categoría 1.
INSERT INTO PARTICIPANTES (NUMERO, PAIS, CORREO, NOMBRE, APELLIDO, NACIMIENTO, CATEGORIA)
SELECT 
    NUMERO,
    PAIS,
    CORREO,
    NOMBRE,
    APELLIDO,
    NACIMIENTO,
    CASE 
        WHEN CATEGORIA > 5 THEN 5
        WHEN CATEGORIA < 1 THEN 1
        ELSE CATEGORIA
    END
FROM MBDA.DATA;
