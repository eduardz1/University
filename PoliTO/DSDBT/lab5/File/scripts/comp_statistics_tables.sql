REMARK
/*
Calcolo delle statistiche sulle tabelle del database: EMP, DEPT, SALGRADE
*/

ANALYZE TABLE emp COMPUTE STATISTICS;
ANALYZE TABLE dept COMPUTE STATISTICS;
ANALYZE TABLE salgrade COMPUTE STATISTICS;

ANALYZE TABLE emp COMPUTE STATISTICS FOR ALL COLUMNS;
ANALYZE TABLE dept COMPUTE STATISTICS FOR ALL COLUMNS;
ANALYZE TABLE salgrade COMPUTE STATISTICS FOR ALL COLUMNS;

