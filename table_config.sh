# Use this file to fix errors and insert data in the tables

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Drop existing tables
echo $($PSQL "DROP TABLE elements, properties;")
echo $($PSQL "DROP TABLE IF EXISTS types;")

# Rebuild database
psql -U postgres < periodic_table.sql
 
# Create a types table
echo $($PSQL "CREATE TABLE types(type_id SERIAL PRIMARY KEY, type VARCHAR(50) NOT NULL);")

# Insert into types
echo $($PSQL "INSERT INTO types(type) VALUES('metal'), ('nonmetal'), ('metalloid');")

# In properties create a column type_id INT 
echo $($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")

# Insert into properties.type_id the correct value corresponding to the properties.type column
echo $($PSQL "UPDATE properties SET type_id = 1 WHERE type = 'metal';")
echo $($PSQL "UPDATE properties SET type_id = 2 WHERE type = 'nonmetal';")
echo $($PSQL "UPDATE properties SET type_id = 3 WHERE type = 'metalloid';")

# Set properties.type_id to NOT NULL
echo $($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")

# Set properties.type_id as reference of types.type_id
echo $($PSQL "ALTER TABLE properties ADD CONSTRAINT fk_type_id FOREIGN KEY (type_id) REFERENCES types(type_id);")

# Drop column type from properties
echo $($PSQL "ALTER TABLE properties DROP COLUMN type;")

# Delete row from the 2 tables with atomic_number 1000
echo $($PSQL "DELETE FROM properties WHERE atomic_number = 1000;")
echo $($PSQL "DELETE FROM elements WHERE atomic_number = 1000;")

# Insert into elements element_9 & element_10
echo $($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');")
echo $($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES(9, 18.998, -220, -188.1, 2), (10, 20.18, -248.6, -246.1, 2);")

# Update : capitalize symbol column in elements
echo $($PSQL "UPDATE elements SET symbol = INITCAP(symbol);")

# Update: remove trailing zeroes in atomic mass . maybe adjust to DECIMAL . check atomic_mass.txt
echo $($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;")
echo $($PSQL "UPDATE properties SET atomic_mass = CAST(atomic_mass AS FLOAT);")
