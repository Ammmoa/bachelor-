BEGIN;
INSERT INTO BL_3NF.CE_COLORS (COLOR_ID, COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT -1, 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
WHERE NOT EXISTS (
SELECT * FROM BL_3NF.CE_COLORS c WHERE c.COLOR_ID = -1
)
RETURNING *;
COMMIT;