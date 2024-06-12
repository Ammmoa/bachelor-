BEGIN;
INSERT INTO BL_3NF.CE_BRANDS (BRAND_ID, BRAND, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT -1, 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
WHERE NOT EXISTS (
SELECT * FROM BL_3NF.CE_BRANDS c WHERE c.BRAND_ID = -1
)
RETURNING *;
COMMIT;