# Script per convertire i dati variabili dal formato vecchio al nuovo
$oldFile = Get-Content "barbera_development_may_30_2010.sql" -Raw

# Estrai la sezione variabili
$start = $oldFile.IndexOf("INSERT INTO ``variabili`` VALUES")
$end = $oldFile.IndexOf("/*!40000 ALTER TABLE ``variabili`` ENABLE KEYS */;", $start)
$varSection = $oldFile.Substring($start, $end - $start)

# Estrai solo i VALUES
$varSection -match "VALUES\s+(.+);" | Out-Null
$allValues = $matches[1]

# Rimuovi i due NULL centrali (position, valori_possibili che non esistevano nel 2010)
# Formato: ...,decimali,NULL,NULL,created_at,... → ...,decimali,created_at,...
$allValues = $allValues -replace ",NULL,NULL,'2010", ",'2010"

# Header SQL con colonne esplicite
$newSQL = @"
-- Conversione variabili dal formato vecchio al nuovo
-- Formato vecchio: id,matrice_id,udm_item_id,nome,nome_esteso,simbolo,funzione,tipo,min,max,decimali,?,?,created_at,updated_at
-- Formato nuovo: id,nome,udm_item_id,tipo,simbolo,funzione,nome_esteso,min,max,decimali,matrice_id,created_at,updated_at

LOCK TABLES ``variabili`` WRITE;
/*!40000 ALTER TABLE ``variabili`` DISABLE KEYS */;

INSERT INTO ``variabili`` (id, matrice_id, udm_item_id, nome, nome_esteso, simbolo, funzione, tipo, min, max, decimali, created_at, updated_at) VALUES 
$allValues;

/*!40000 ALTER TABLE ``variabili`` ENABLE KEYS */;
UNLOCK TABLES;
"@

# Salva il nuovo file
$newSQL | Out-File -Encoding UTF8 "import_variabili_converted.sql"

Write-Host "File converted successfully!"
Write-Host "Output: import_variabili_converted.sql"

