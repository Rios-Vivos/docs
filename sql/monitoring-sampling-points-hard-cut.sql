BEGIN;

CREATE TABLE IF NOT EXISTS sample_catalogs (
  id SERIAL PRIMARY KEY,
  category TEXT NOT NULL CHECK (category IN ('water_body', 'sampling_point_type', 'water_use')),
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  UNIQUE (category, code)
);

CREATE TABLE IF NOT EXISTS sampling_points (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  community_id INTEGER NOT NULL REFERENCES communities(id) ON DELETE RESTRICT,
  water_body_id INTEGER NOT NULL REFERENCES sample_catalogs(id) ON DELETE RESTRICT,
  sampling_point_type_id INTEGER NOT NULL REFERENCES sample_catalogs(id) ON DELETE RESTRICT,
  water_use_id INTEGER NOT NULL REFERENCES sample_catalogs(id) ON DELETE RESTRICT,
  latitude DOUBLE PRECISION NULL,
  longitude DOUBLE PRECISION NULL,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

INSERT INTO sample_catalogs (category, code, name, description, sort_order, is_active)
VALUES
  ('water_body', 'unknown', 'Unknown', 'Fallback water body for legacy records', 0, TRUE),
  ('sampling_point_type', 'unknown', 'Unknown', 'Fallback point type for legacy records', 0, TRUE),
  ('water_use', 'unknown', 'Unknown', 'Fallback water use for legacy records', 0, TRUE)
ON CONFLICT (category, code) DO NOTHING;

INSERT INTO sample_catalogs (category, code, name, sort_order, is_active)
SELECT 'water_body',
       LOWER(REGEXP_REPLACE(TRIM(value), '[^a-zA-Z0-9]+', '-', 'g')),
       TRIM(value),
       10,
       TRUE
FROM (
  SELECT DISTINCT COALESCE(metadata->>'waterBody', metadata->>'water_body') AS value
  FROM samples
) src
WHERE value IS NOT NULL AND TRIM(value) <> ''
ON CONFLICT (category, code) DO NOTHING;

INSERT INTO sample_catalogs (category, code, name, sort_order, is_active)
SELECT 'sampling_point_type',
       LOWER(REGEXP_REPLACE(TRIM(value), '[^a-zA-Z0-9]+', '-', 'g')),
       TRIM(value),
       10,
       TRUE
FROM (
  SELECT DISTINCT COALESCE(metadata->>'samplingPoint', metadata->>'sampling_point') AS value
  FROM samples
) src
WHERE value IS NOT NULL AND TRIM(value) <> ''
ON CONFLICT (category, code) DO NOTHING;

INSERT INTO sample_catalogs (category, code, name, sort_order, is_active)
SELECT 'water_use',
       LOWER(REGEXP_REPLACE(TRIM(value), '[^a-zA-Z0-9]+', '-', 'g')),
       TRIM(value),
       10,
       TRUE
FROM (
  SELECT DISTINCT COALESCE(metadata->>'waterUse', metadata->>'water_use') AS value
  FROM samples
) src
WHERE value IS NOT NULL AND TRIM(value) <> ''
ON CONFLICT (category, code) DO NOTHING;

ALTER TABLE samples
  ADD COLUMN IF NOT EXISTS sampling_point_id INTEGER NULL REFERENCES sampling_points(id) ON DELETE RESTRICT,
  ADD COLUMN IF NOT EXISTS sample_code TEXT NULL,
  ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION NULL,
  ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION NULL;

UPDATE samples s
SET latitude = COALESCE(s.latitude, s.collection_latitude, s.station_latitude, st.latitude),
    longitude = COALESCE(s.longitude, s.collection_longitude, s.station_longitude, st.longitude),
    sample_code = COALESCE(
      s.sample_code,
      NULLIF(TRIM(s.metadata->>'sampleCode'), ''),
      NULLIF(TRIM(s.metadata->>'sample_code'), '')
    )
FROM stations st
WHERE s.station_id = st.id;

WITH legacy_manual AS (
  SELECT
    c.id AS community_id,
    COALESCE(NULLIF(TRIM(s.metadata->>'communityCode'), ''), NULLIF(TRIM(s.metadata->>'community_code'), '')) AS community_code,
    COALESCE(NULLIF(TRIM(s.metadata->>'waterBody'), ''), NULLIF(TRIM(s.metadata->>'water_body'), ''), 'Unknown') AS water_body_name,
    COALESCE(NULLIF(TRIM(s.metadata->>'samplingPoint'), ''), NULLIF(TRIM(s.metadata->>'sampling_point'), ''), 'Unknown') AS sampling_point_name,
    COALESCE(NULLIF(TRIM(s.metadata->>'waterUse'), ''), NULLIF(TRIM(s.metadata->>'water_use'), ''), 'Unknown') AS water_use_name,
    MIN(COALESCE(s.latitude, s.collection_latitude, s.station_latitude)) AS latitude,
    MIN(COALESCE(s.longitude, s.collection_longitude, s.station_longitude)) AS longitude
  FROM samples s
  LEFT JOIN communities c
    ON c.code_name = COALESCE(NULLIF(TRIM(s.metadata->>'communityCode'), ''), NULLIF(TRIM(s.metadata->>'community_code'), ''))
  WHERE s.station_id IS NULL
  GROUP BY 1, 2, 3, 4, 5
),
resolved AS (
  SELECT
    lm.*,
    wb.id AS water_body_id,
    spt.id AS sampling_point_type_id,
    wu.id AS water_use_id,
    LOWER(REGEXP_REPLACE(
      CONCAT_WS('-', COALESCE(lm.community_code, 'legacy'), lm.water_body_name, lm.sampling_point_name, lm.water_use_name),
      '[^a-zA-Z0-9]+',
      '-',
      'g'
    )) AS generated_code
  FROM legacy_manual lm
  LEFT JOIN sample_catalogs wb
    ON wb.category = 'water_body'
   AND wb.code = LOWER(REGEXP_REPLACE(lm.water_body_name, '[^a-zA-Z0-9]+', '-', 'g'))
  LEFT JOIN sample_catalogs spt
    ON spt.category = 'sampling_point_type'
   AND spt.code = LOWER(REGEXP_REPLACE(lm.sampling_point_name, '[^a-zA-Z0-9]+', '-', 'g'))
  LEFT JOIN sample_catalogs wu
    ON wu.category = 'water_use'
   AND wu.code = LOWER(REGEXP_REPLACE(lm.water_use_name, '[^a-zA-Z0-9]+', '-', 'g'))
  WHERE lm.community_id IS NOT NULL
)
INSERT INTO sampling_points (
  code,
  name,
  community_id,
  water_body_id,
  sampling_point_type_id,
  water_use_id,
  latitude,
  longitude,
  metadata
)
SELECT
  generated_code,
  CONCAT_WS(' / ', water_body_name, sampling_point_name),
  community_id,
  COALESCE(water_body_id, (SELECT id FROM sample_catalogs WHERE category = 'water_body' AND code = 'unknown')),
  COALESCE(sampling_point_type_id, (SELECT id FROM sample_catalogs WHERE category = 'sampling_point_type' AND code = 'unknown')),
  COALESCE(water_use_id, (SELECT id FROM sample_catalogs WHERE category = 'water_use' AND code = 'unknown')),
  latitude,
  longitude,
  jsonb_build_object(
    'migratedFromLegacySamples', TRUE,
    'communityCode', community_code,
    'waterBody', water_body_name,
    'samplingPointType', sampling_point_name,
    'waterUse', water_use_name
  )
FROM resolved
ON CONFLICT (code) DO NOTHING;

UPDATE samples s
SET sampling_point_id = sp.id
FROM communities c
JOIN sampling_points sp
  ON sp.community_id = c.id
WHERE s.station_id IS NULL
  AND s.sampling_point_id IS NULL
  AND c.code_name = COALESCE(NULLIF(TRIM(s.metadata->>'communityCode'), ''), NULLIF(TRIM(s.metadata->>'community_code'), ''))
  AND sp.code = LOWER(REGEXP_REPLACE(
    CONCAT_WS('-',
      COALESCE(NULLIF(TRIM(s.metadata->>'communityCode'), ''), NULLIF(TRIM(s.metadata->>'community_code'), ''), 'legacy'),
      COALESCE(NULLIF(TRIM(s.metadata->>'waterBody'), ''), NULLIF(TRIM(s.metadata->>'water_body'), ''), 'Unknown'),
      COALESCE(NULLIF(TRIM(s.metadata->>'samplingPoint'), ''), NULLIF(TRIM(s.metadata->>'sampling_point'), ''), 'Unknown'),
      COALESCE(NULLIF(TRIM(s.metadata->>'waterUse'), ''), NULLIF(TRIM(s.metadata->>'water_use'), ''), 'Unknown')
    ),
    '[^a-zA-Z0-9]+',
    '-',
    'g'
  ));

CREATE UNIQUE INDEX IF NOT EXISTS samples_sample_code_unique_idx
  ON samples(sample_code)
  WHERE sample_code IS NOT NULL;

DELETE FROM parameters
WHERE param_key IN (
  'community_code',
  'site_code',
  'sampling_point',
  'coord_x',
  'coord_y',
  'sampling_date'
);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM samples
    WHERE ((station_id IS NOT NULL)::int + (sampling_point_id IS NOT NULL)::int) <> 1
  ) THEN
    RAISE EXCEPTION 'Samples still violate the exactly-one-of station_id / sampling_point_id rule.';
  END IF;
END $$;

ALTER TABLE samples
  DROP COLUMN IF EXISTS station_code,
  DROP COLUMN IF EXISTS station_latitude,
  DROP COLUMN IF EXISTS station_longitude,
  DROP COLUMN IF EXISTS collection_latitude,
  DROP COLUMN IF EXISTS collection_longitude;

ALTER TABLE samples
  ADD CONSTRAINT samples_owner_xor_chk
  CHECK (((station_id IS NOT NULL)::int + (sampling_point_id IS NOT NULL)::int) = 1);

COMMIT;
