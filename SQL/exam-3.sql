-- 1. Lister tous les plats avec un prix inférieur à 20 €.
SELECT *
FROM dishes
WHERE price < 20;

-- 2. Lister tous les plats des restaurants de cuisine Française et de cuisine Italienne en utilisant IN.
SELECT d.*
FROM dishes d
JOIN chefs c ON d.chef_id = c.id
JOIN restaurants r ON c.restaurant_id = r.id
WHERE r.cuisine_type IN ('Française', 'Italienne');

-- 3. Lister tous les ingrédients du Bœuf Bourguignon.
SELECT i.name
FROM ingredients i
JOIN dishes d ON i.dish_id = d.id
WHERE d.name = 'Bœuf Bourguignon';

-- 4. Lister tous les chefs (leur nom uniquement) et leurs restaurants (leur nom uniquement).
SELECT c.name AS chef_name, r.name AS restaurant_name
FROM chefs c
JOIN restaurants r ON c.restaurant_id = r.id;

-- 5. Lister les chefs et le nombre de plats qu'ils ont créés.
SELECT c.name AS chef_name, COUNT(d.id) AS nombre_plats
FROM chefs c
LEFT JOIN dishes d ON c.id = d.chef_id
GROUP BY c.name;

-- 6. Lister les chefs qui ont créé plus d'un plat.
SELECT c.name AS chef_name, COUNT(d.id) AS nombre_plats
FROM chefs c
JOIN dishes d ON c.id = d.chef_id
GROUP BY c.name
HAVING COUNT(d.id) > 1;

-- 7. Calculez le nombre de chefs ayant créé un seul plat.
SELECT COUNT(*) AS nombre_chefs_un_plat
FROM (
    SELECT chef_id
    FROM dishes
    GROUP BY chef_id
    HAVING COUNT(*) = 1
) AS chefs_un_plat;

-- 8. Calculez le nombre de plats pour chaque type de cuisine.
SELECT r.cuisine_type, COUNT(d.id) AS nombre_plats
FROM restaurants r
JOIN chefs c ON r.id = c.restaurant_id
JOIN dishes d ON c.id = d.chef_id
GROUP BY r.cuisine_type;

-- 9. Calculez le prix moyen des plats par type de cuisine.
SELECT r.cuisine_type, AVG(d.price) AS prix_moyen
FROM restaurants r
JOIN chefs c ON r.id = c.restaurant_id
JOIN dishes d ON c.id = d.chef_id
GROUP BY r.cuisine_type;

-- 10. Trouver le prix moyen des plats créés par chaque chef, en incluant seulement les chefs ayant créé plus de 2 plats
SELECT c.name AS chef_name, AVG(d.price) AS prix_moyen
FROM chefs c
JOIN dishes d ON c.id = d.chef_id
GROUP BY c.name
HAVING COUNT(d.id) > 2;
