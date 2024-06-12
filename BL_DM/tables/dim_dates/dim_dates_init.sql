BEGIN;

INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
SELECT '1-1-1900', -1, -1, -1, 'MANUAL', 'MANUAL'
WHERE NOT EXISTS (
SELECT * FROM BL_DM.DIM_DATES d WHERE d.DATE_SURR_ID = '1-1-1900'
)
RETURNING *;

COMMIT;