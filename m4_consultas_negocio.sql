USE Ventas_Tech_DB;

-- =====================================================
-- ENTREGA 4 - CONSULTAS SQL DE NEGOCIO
-- Proyecto: RetailPro
-- Base de datos: Ventas_Tech_DB
-- Motor: SQL Server
-- =====================================================

-- =====================================================
-- CONSULTA 1
-- Resumen ejecutivo mensual
-- =====================================================

SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);

-- =====================================================
-- CONSULTA 2
-- Ranking de los 5 productos con mayor facturación
-- =====================================================

SELECT TOP 5
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- =====================================================
-- CONSULTA 3
-- Clientes recurrentes
-- Clientes con más de un pedido
-- =====================================================

SELECT
id_cliente,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- =====================================================
-- CONSULTA 4
-- Comparación de la facturación mensual
-- contra el promedio mensual general
-- =====================================================

WITH ventas_mensuales AS (
SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY MONTH(fecha_venta)
)
SELECT
mes,
total_facturado,
CASE
WHEN total_facturado > AVG(total_facturado) OVER ()
THEN 'Por encima'
WHEN total_facturado < AVG(total_facturado) OVER ()
THEN 'Por debajo'
ELSE 'Igual al promedio'
END AS comparacion_promedio
FROM ventas_mensuales
ORDER BY mes;

-- =====================================================
-- HALLAZGOS
-- =====================================================

-- Hallazgo 1: La facturación total registrada es de $6.444
-- correspondientes a 10 pedidos y 29 unidades vendidas.

-- Hallazgo 2: El producto 1 es el que genera la mayor
-- facturación, con un total de $3.600, aproximadamente
-- el 55,9% de la facturación total.

-- Hallazgo 3: Los 5 clientes registrados realizaron más
-- de un pedido, por lo que todos son clientes recurrentes.
