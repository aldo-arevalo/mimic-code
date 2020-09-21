-- ------------------------------------------------------------------
-- Title: Retrieves all glucose readings.
-- Description: This script extracts all the glucose readings that 
-- are stored both in CHARTEVENTS and LABEVENTS.
-- ------------------------------------------------------------------

WITH chart AS(  -- Import data stored in CHARTEVENTS table
    SELECT ce.subject_id, ce.hadm_id, ce.icustay_id, ce.charttime, ce.storetime
    , (CASE
            WHEN itemid IN (811,1529,3745,3744,220621,226537,807,225664)
            AND ce.valuenum > 0 THEN valuenum            
            ELSE null END) AS Glu_Chart
    , ce.itemid, 1 AS idi
    FROM `physionet-data.mimiciii_clinical.chartevents` ce
    WHERE ce.itemid IN(807,     --  Fingerstick Glucose
                        811,    --	Glucose (70-105)
                        1529,   --	Glucose
                        3745,   --	BloodGlucose
                        3744,   --	Blood Glucose
                        225664, --	Glucose finger stick
                        220621, --	Glucose (serum)
                        226537  --	Glucose (whole blood)
                        )
    AND (ce.error IS null OR ce.error <> 1)
)
, labv AS( -- Import data stored in LABEVENTS table
    SELECT le.SUBJECT_ID, le.HADM_ID, le.CHARTTIME 
    , (CASE
            WHEN itemid IN (50809,50931) AND valuenum > 0
            THEN valuenum ELSE null END) AS Glu_Labv
    , itemid, 2 AS idi
    FROM `physionet-data.mimiciii_clinical.labevents` le	 
    WHERE le.itemid IN(50931     -- GLUCOSE | CHEMISTRY | BLOOD 
                        , 50809) -- GLUCOSE | BLOOD GAS | BLOOD)
)
-- Join both tables/sources

SELECT pt.SUBJECT_ID, pt.HADM_ID, pt.ICUSTAY_ID
    , CAST(pt.CHARTTIME AS TIMESTAMP) AS CHARTTIME
    , CAST(pt.STORETIME AS TIMESTAMP) AS STORETIME
    , pt.glucose
    , COALESCE(pt.CH, pt.LB) AS ITEM_GLC
FROM (
    -- Call the temporary table LABV
    SELECT subject_id, hadm_id, null AS icustay_id, charttime
    , null AS storetime, glu_labv AS glucose, itemid AS LB, null AS CH 
    FROM labv AS le

    UNION DISTINCT

    -- Call the temporary table CHART                    
    SELECT subject_id, hadm_id, icustay_id, charttime, storetime, Glu_Chart, null
    , itemid FROM chart as ce
) pt
WHERE pt.glucose IS NOT null
GROUP BY pt.subject_id,pt.hadm_id,pt.ICUSTAY_ID,pt.charttime,pt.STORETIME,glucose,pt.CH,pt.LB
ORDER BY subject_id,hadm_id,ICUSTAY_ID,charttime 
