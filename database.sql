/*CRUT*/

INSERT INTO `articles` (
"title",
"text",
"category_id",
"pub_date"
) VALUES
("Hunting of sun leopard", "Iaculis convallis netus rutrum. Cubilia ullamcorper porta ad. Tellus. Montes. Dolor.
Dis rhoncus dis condimentum ultrices cursus et class libero.", 5, NOW
());

/*Select*/
SELECT *
FROM `articles
`
 WHERE `id` = 6;
SELECT *
FROM `articles
`
 WHERE `views` < 100;

SELECT *
FROM `article
` WHERE `views` > 100 ORDER BY `views` DESC LIMIT 2,10;


/*Update*/
UPDATE `articles`
SET
`title` = "Plan for effective muscle grow" WHERE `id` = 2;

UPDATE `articles`
SET
`title` = "Plan for effective muscle grow",
`views` = `views` + 1
WHERE `id` = 2;


/*Delete*/
DELETE FROM `articles` WHERE `id` = 7 OR `id` = 8 AND `views` < 100;