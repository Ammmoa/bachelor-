BEGIN;

INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
SELECT d::DATE, EXTRACT(DAY FROM d), EXTRACT(MONTH FROM d), EXTRACT(YEAR FROM d), 'MANUAL', 'MANUAL'
FROM generate_series('2010-01-01'::DATE, '2025-01-01'::DATE, '1 day') d
LEFT JOIN BL_DM.DIM_DATES t ON d::DATE = t.DATE_SURR_ID
WHERE t.DATE_SURR_ID IS NULL
RETURNING *;
 
COMMIT;

