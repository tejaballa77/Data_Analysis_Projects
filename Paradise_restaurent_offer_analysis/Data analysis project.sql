SELECT VERSION() AS mysql_version;

CREATE DATABASE IF NOT EXISTS antenna_analysis
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

USE antenna_analysis;

SELECT COUNT(*) AS total_rows FROM antenna_parameters;

ALTER TABLE antenna_parameters
ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT * FROM antenna_parameters ORDER BY id LIMIT 10 ;

SELECT
  SUM(CASE WHEN FreqGHz <= 0 THEN 1 ELSE 0 END) AS freq_nonpositive,
  SUM(CASE WHEN lengthofpatchmm <= 0 THEN 1 ELSE 0 END) AS length_nonpositive,
  SUM(CASE WHEN widthofpatchmm <= 0 THEN 1 ELSE 0 END) AS width_nonpositive,
  SUM(CASE WHEN Slotlengthmm < 0 THEN 1 ELSE 0 END) AS slotlength_negative,
  SUM(CASE WHEN slotwidthmm < 0 THEN 1 ELSE 0 END) AS slotwidth_negative,
  SUM(CASE WHEN s11dB IS NULL THEN 1 ELSE 0 END) AS missing_s11
FROM antenna_parameters;

ALTER TABLE antenna_parameters
ADD CONSTRAINT chk_physical_values CHECK (FreqGHz > 0 AND lengthofpatchmm >= 0 AND widthofpatchmm >= 0 AND Slotlengthmm >= 0 AND slotwidthmm >= 0);

CREATE INDEX idx_s11 ON antenna_parameters (s11dB);
CREATE INDEX idx_freq ON antenna_parameters (FreqGHz);

SELECT
  COUNT(*) AS n,
  MIN(s11dB) AS min_s11,
  MAX(s11dB) AS max_s11,
  ROUND(AVG(s11dB),3) AS avg_s11,
  ROUND(STDDEV_POP(s11dB),3) AS std_s11,
  ROUND(MIN(FreqGHz),3) AS min_freq,
  ROUND(MAX(FreqGHz),3) AS max_freq,
  ROUND(AVG(lengthofpatchmm),3) AS avg_length,
  ROUND(AVG(widthofpatchmm),3) AS avg_width
FROM antenna_parameters;




