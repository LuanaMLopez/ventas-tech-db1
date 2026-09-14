-- =====================================================
-- ENTREGA M5 - CONSULTAS CON JOINS
-- Proyecto: RetailPro
-- Base de datos: Ventas_Tech_DB
-- Motor: SQL Server
-- =====================================================


-- =====================================================
-- CONSULTA 1
-- Vista base del proyecto - INNER JOIN
-- =====================================================

SELECT
    v.fecha_venta AS fecha,
    c.id_cliente AS identificacion_cliente,
    c.nombre AS nombre_cliente,
    c.region AS region,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- =====================================================
-- CONSULTA 2
-- Clientes sin ventas - LEFT JOIN
-- =====================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- =====================================================
-- CONSULTA 3
-- Productos sin ventas - LEFT JOIN
-- =====================================================

SELECT
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- =====================================================
-- CONSULTA 4
-- Consolidado por canal - UNION ALL
-- =====================================================
-- Nota: el canal es creado artificialmente para el ejercicio.
-- Ventas hasta el 10/03/2024 = Online
-- Ventas posteriores al 10/03/2024 = Presencial

WITH ventas_por_canal AS (
    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
)
SELECT
    canal,
    SUM(total) AS total_facturado
FROM ventas_por_canal
GROUP BY canal;