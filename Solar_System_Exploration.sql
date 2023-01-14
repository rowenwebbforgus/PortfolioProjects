/*Skills used: Create, Insert Into, Aggregate Functions, Joins, Subqueries, Nested Queries*/

/* 
Solar system objects
Adapted from: http://en.wikipedia.org/wiki/List_of_Solar_System_objects_by_size
Collected by: https://www.khanacademy.org/profile/patrick809/programs
*/

CREATE TABLE solar_system_objects(
  body TEXT
, mean_radius NUMERIC         /* km */
, mean_radius_rel NUMERIC     /* relative to earth */
, volume NUMERIC              /* 10^9 km^3 */
, volume_rel NUMERIC          /* relative to earth */
, mass NUMERIC                /* 10^21 kg */
, mass_rel NUMERIC            /* relative to earth */
, density NUMERIC             /* g/cm^3 */
, surface_gravity NUMERIC     /* m/s^2 */
, surface_gravity_rel NUMERIC /* relative to earth */
, type_of_object TEXT
, shape TEXT
);

INSERT INTO solar_system_objects(body,mean_radius,mean_radius_rel,volume,volume_rel,mass,mass_rel,density,surface_gravity,surface_gravity_rel,type_of_object,shape)
VALUES 
	('Sun',696342,109.3,1414300000,1305700,1988550000,333000,1.408,274,28.02,'star','round'),
	('Jupiter',69911,10.97,1431280,1321,1898600,317.83,1.326,24.79,2.535,'planet (gas giant) has rings','round'),
	('Saturn',58232,9.14,827130,764,568460,95.159,0.687,10.445,1.06,'planet (gas giant) has rings','round'),
	('Uranus',25362,3.98,68340,63.1,86832,14.536,1.27,8.87,0.9,'planet (ice giant) has rings','round'),
	('Neptune',24622,3.86,62540,57.7,102430,17.147,1.638,11.15,1.14,'planet (ice giant) has rings','round'),
	('Earth',6371,1,1083.21,1,5973.60,1,5.514,9.78033,0.99732,'planet (terrestrial)','round'),
	('Venus',6051.8,0.95,928.43,0.857,4868.50,0.815,5.243,8.872,0.905,'planet (terrestrial)','round'),
	('Mars',3389.5,0.532,163.18,0.151,641.85,0.107,3.9335,3.7,0.38,'planet (terrestrial)','round'),
	('Ganymede',2634.1,0.413,76.3,0.0704,148.2,0.0248,1.936,1.428,0.15,'satellite of Jupiter','round'),
	('Titan ',2576,0.404,71.52,0.066,134.5,0.0225,1.8798,1.354,0.14,'satellite of Saturn','round'),
	('Mercury',2439.7,0.383,60.83,0.0562,330.2,0.0553,5.427,3.7,0.38,'planet (terrestrial)','round'),
	('Callisto',2410.3,0.378,58.65,0.0541,107.6,0.018,1.8344,1.23603,0.126,'satellite of Jupiter','round'),
	('Io',1821.6,0.286,25.32,0.0234,89.3,0.015,3.528,1.797,0.183,'satellite of Jupiter','round'),
	('Moon',1737.1,0.273,21.958,0.0203,73.5,0.0123,3.3464,1.625,0.166,'satellite of Earth','round'),
	('Europa',1560.8,0.245,15.93,0.0147,48,0.00803,3.013,1.316,0.134,'satellite of Jupiter','round'),
	('Triton ',1353.4,0.212,10.38,0.0096,21.5,0.00359,2.061,0.782,0.0797,'satellite of Neptune','round'),
	('PlutoR',1184,0.185,7,0.0066,13.105,0.0022,2.03,0.61,0.062,'dwarf planet plutino multiple','round'),
	('ErisR',1163,0.182,7,0.007,16.7,0.0027,2.52,0.662,0.0677,'dwarf planet SDO binary','round'),
	('Titania ',788.4,0.124,2.06,0.0019,3.526,0.00059,1.711,0.378,0.0385,'satellite of Uranus','round'),
	('Rhea ',763.8,0.12,1.87,0.0017,2.3166,0.00039,1.236,0.26,0.027,'satellite of Saturn','round'),
	('Oberon ',761.4,0.12,1.85,0.0017,3.014,0.0005,1.63,0.347,0.035,'satellite of Uranus','round'),
	('Iapetus ',734.5,0.113,1.55,0.0014,1.9739,0.00033,1.088,0.223,0.0227,'satellite of Saturn','round (not in technical HE)'),
	('MakemakeR',715,NULL,1.7,NULL,NULL,NULL,2.3,NULL,NULL,'dwarf planet cubewano','round'),
	("2007 OR10",640,0.1,1.0981,0.00101,NULL,NULL,NULL,NULL,NULL,'resonant KBO (3:10)','unknown'),
	('HaumeaR',620,0.117,1.3,0.001,4.006,0.00069,2.55,0.44,0.045,'dwarf planet resonant KBO (7:12) trinary','round (scalene ellipsoid)'),
	('Charon ',603.5,0.095,0.87,0.0008,1.52,0.00025,1.65,0.279,0.028,'satellite of Pluto','round'),
	('Umbriel ',584.7,0.092,0.84,0.0008,1.2,0.0002,1.39,0.234,0.024,'satellite of Uranus','round'),
	('Ariel  ',578.9,0.091,0.81,0.0008,1.35,0.00022,1.66,0.269,0.027,'satellite of Uranus','round'),
	('Dione ',561.4,0.088,0.73,0.0007,1.096,0.000183,1.478,0.232,0.0236,'satellite of Saturn','round (not in technical HE)'),
	('Quaoar',555,NULL,NULL,NULL,1.4,0.0003,2.2,0.125,NULL,'cubewano binary','unknown'),
	('Tethys ',531.1,0.083,0.624,0.0006,0.6173,0.000103,0.984,0.145,0.015,'satellite of Saturn','round'),
	('Ceres ',476.2,0.076,0.437,0.0004,0.95,0.000159,2.077,0.27,0.0275,'dwarf planet belt asteroid','round');

/*which body is larger than Earth but less dense? */
SELECT 
    body
FROM
    solar_system_objects
WHERE
    density < 1 AND mass_rel > 1;

/*which bodies are more than 100 larger than Earth, in terms of radius, volume, or mass? */
SELECT 
    body
FROM
    solar_system_objects
WHERE
    mean_radius_rel > 100
        OR volume_rel > 100
        OR mass_rel > 100;

/*what's the number of objects for each type of shape?*/ 
SELECT 
    shape, COUNT(*)
FROM
    solar_system_objects
GROUP BY shape;

/*which solar system objects aren't round?*/
SELECT 
    *
FROM
    solar_system_objects
WHERE
    shape NOT LIKE 'round';


/* find the average, minimum, and maximum values based on type of solar system object. 
Excluding types where there's only one body*/
SELECT 
    type_of_object,
    COUNT(*) AS num_bodies,
    ROUND(AVG(mean_radius), 2) AS avg_radius,
    ROUND(AVG(mass), 2) AS avg_mass,
    ROUND(AVG(volume), 2) AS avg_volume,
    ROUND(AVG(density), 2) AS avg_density,
    ROUND(AVG(surface_gravity), 2) AS avg_surface_gravity
FROM
    solar_system_objects
GROUP BY type_of_object
HAVING COUNT(*) > 1
ORDER BY avg_density;

SELECT 
    type_of_object,
    COUNT(*) AS num_bodies,
    ROUND(MIN(mean_radius), 2) AS min_radius,
    ROUND(MIN(mass), 2) AS min_mass,
    ROUND(MIN(volume), 2) AS min_volume,
    ROUND(MIN(density), 2) AS min_density,
    ROUND(MIN(surface_gravity), 2) AS min_surface_gravity
FROM
    solar_system_objects
GROUP BY type_of_object
HAVING COUNT(*) > 1
ORDER BY min_density;

SELECT 
    type_of_object,
    COUNT(*) AS num_bodies,
    ROUND(MAX(mean_radius), 2) AS max_radius,
    ROUND(MAX(mass), 2) AS max_mass,
    ROUND(MAX(volume), 2) AS max_volume,
    ROUND(MAX(density), 2) AS max_density,
    ROUND(MAX(surface_gravity), 2) AS max_surface_gravity
FROM
    solar_system_objects
GROUP BY type_of_object
HAVING COUNT(*) > 1
ORDER BY max_density;

/* as expected, satelites have the lowest masses over all, followed by terrestrial planets, ice giants, 
and lastly gas giants. This is true for mean radius, volume and surface gravity.  gas giants had the lowest 
density, followed ice giants, satellites, and then terrestrial planets. for avg_density and min_density, 
satelites of saturn actual have a lower density than ice giants.*/

SELECT 
    CASE
        WHEN type_of_object LIKE '%satellite%' THEN 'satellite'
        WHEN type_of_object LIKE '%dwarf%' THEN 'dwarf planet'
        ELSE type_of_object
    END AS type,
    COUNT(*) AS num_bodies,
    ROUND(AVG(mean_radius), 2) AS avg_radius,
    ROUND(AVG(mass), 2) AS avg_mass,
    ROUND(AVG(volume), 2) AS avg_volume,
    ROUND(AVG(density), 2) AS avg_density,
    ROUND(AVG(surface_gravity), 2) AS avg_surface_gravity
FROM
    solar_system_objects
GROUP BY type
HAVING COUNT(*) > 1
ORDER BY avg_density;

SELECT 
    CASE
        WHEN type_of_object LIKE '%satellite%' THEN 'satellite'
        WHEN type_of_object LIKE '%dwarf%' THEN 'dwarf planet'
        ELSE type_of_object
    END AS type,
    COUNT(*) AS num_bodies,
    ROUND(MIN(mean_radius), 2) AS min_radius,
    ROUND(MIN(mass), 2) AS min_mass,
    ROUND(MIN(volume), 2) AS min_volume,
    ROUND(MIN(density), 2) AS min_density,
    ROUND(MIN(surface_gravity), 2) AS min_surface_gravity
FROM
    solar_system_objects
GROUP BY type
HAVING COUNT(*) > 1
ORDER BY min_density;

SELECT 
    CASE
        WHEN type_of_object LIKE '%satellite%' THEN 'satellite'
        WHEN type_of_object LIKE '%dwarf%' THEN 'dwarf planet'
        ELSE type_of_object
    END AS type,
    COUNT(*) AS num_bodies,
    ROUND(MAX(mean_radius), 2) AS max_radius,
    ROUND(MAX(mass), 2) AS max_mass,
    ROUND(MAX(volume), 2) AS max_volume,
    ROUND(MAX(density), 2) AS max_density,
    ROUND(MAX(surface_gravity), 2) AS max_surface_gravity
FROM
    solar_system_objects
GROUP BY type
HAVING COUNT(*) > 1
ORDER BY max_density;

/*now we see that dwarf planets have the lowest average radius, followed by satellites, terrestrial planets, 
ice giants, and gas giants. This is also true for mass, volume, and surface gravity. like before, gas giants 
have the lowest density, followed by ice giants, satellites, then dwarf planets and terrestrial planets. 
This changes if we look at the minimum values, as some  of saturn's satelites have a very low density.*/

SELECT 
    body, density, type_of_object
FROM
    solar_system_objects
ORDER BY density;

/*Using a case statement to categorize bodies as having weaker or stronger surface gravity. 
Interestingly, in this data set Earth's relative gravity is lighter than Earth's gravity, 
so I used a special case for Earth and placed it first in the sequence. 
Most bodies in the solar system have weaker surface than Earth*/

SELECT 
    CASE
        WHEN body = 'Earth' THEN 'Welcome home'
        WHEN surface_gravity_rel < 1 THEN 'You\'ll feel light'
        WHEN surface_gravity_rel > 1 THEN 'You\'ll feel heavy'
    END AS apparent_gravity,
    COUNT(*)
FROM
    solar_system_objects
GROUP BY apparent_gravity;

/* create a list of objects you can see without a telescope using a subquery and IN statement */

create table naked_eye_astronomy (body TEXT, apparent_magnitude NUMERIC);
INSERT into naked_eye_astronomy (body, apparent_magnitude) 
VALUES 
	('Mercury',0.23),
	('Venus',-4.14),
	('Mars',-2.91),
	('Jupiter',-2.2),
	('Saturn',-0.24),
    ('Uranus',5.68);
/*In dark skies we can see objects with an apparent magnitude up to 7, but in light polluted areas 
we can only see objects with an apparent magnitude of 4 or less. Note, apparent magnitude is measured in reverse 
so the smaller the apparent_magnitude, the brighter the object  */

SELECT 
    *
FROM
    solar_system_objects
WHERE
    body IN (SELECT 
            body
        FROM
            naked_eye_astronomy
        WHERE
            apparent_magnitude < 4);

