BEGIN;

INSERT INTO BL_DM.DIM_MODELS (MODEL_SURR_ID, MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT -1, 'n. a.', 'n. a.', -1, -1, 'n. a.', 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
WHERE NOT EXISTS (SELECT * FROM BL_DM.DIM_MODELS m WHERE m.MODEL_SURR_ID = -1)
RETURNING *;

COMMIT;


