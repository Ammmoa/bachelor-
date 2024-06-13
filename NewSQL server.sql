use carsales 

CREATE TABLE person (ID int primary key, firstname VARCHAR(50)) AS NODE;
CREATE TABLE property (start_date DATE) AS EDGE;
CREATE TABLE car (ID int primary key, brand VARCHAR(50)) AS NODE;
 
INSERT INTO person VALUES (1, 'gela'),(2, 'leqso'),(3, 'shaqro'),(4, 'nika');
INSERT INTO car VALUES (1, 'mazda'),(2, 'BMW'),(3, 'opel'),(4, 'subaru');

INSERT INTO property VALUES ((SELECT $node_id FROM person WHERE firstname = 'gela'),
       (SELECT $node_id FROM car WHERE brand = 'subaru'), '6/10/2024');

INSERT INTO property VALUES ((SELECT $node_id FROM person WHERE firstname = 'nika'),
       (SELECT $node_id FROM car WHERE brand = 'subaru'), '6/10/2024');

INSERT INTO property VALUES ((SELECT $node_id FROM person WHERE firstname = 'nika'), 
	   (SELECT $node_id FROM car WHERE brand = 'mazda'), '6/10/2024');

SELECT p.firstname, c.brand
FROM person p, property, car c
WHERE MATCH(p-(property)->c)