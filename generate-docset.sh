DOCUMENTS_PATH="ms-sql.docset/Contents/Resources/Documents"
DB_PATH="../docSet.dsidx"
CREATE_TEXT="CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);" 
cd $DOCUMENTS_PATH;
echo $CREATE_TEXT | sqlite3 $DB_PATH;
echo "Starting: $PWD";
fd . -e html -e jpg -e png -x ruby ../../../../generate-sql.rb {} | sqlite3 $DB_PATH;
