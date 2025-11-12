#!/bin/bash

URLS=$1
compteur=0
SORTIE="sortie.html"

if [ $# -eq 0 ]; then
    echo "Le script attend exactement un argument"
    exit 1
fi

echo "<!DOCTYPE html>" > "$SORTIE"
echo "<html><head><meta charset=\"UTF-8\"><title>Résultats</title>" >> "$SORTIE"


echo "<style>
body {
    font-family: 'Segoe UI', Roboto, sans-serif;
    background-color: #f8f9fc;
    color: #333;
    margin: 40px;
}

h1 {
    text-align: center;
    color: #7b2cbf;
    font-size: 2.2em;
    margin-bottom: 30px;
    text-shadow: 1px 1px 3px rgba(123, 44, 191, 0.2);
}

table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

th {
    background-color: #7b2cbf;
    color: white;
    text-align: left;
    padding: 12px 15px;
    font-size: 1em;
}

td {
    padding: 10px 15px;
    border-bottom: 1px solid #eee;
}

tr:nth-child(even) {
    background-color: #f6f3fa;
}

tr:hover {
    background-color: #ece0f8;
    transition: background-color 0.2s ease-in-out;
}

a {
    color: #5a189a;
    text-decoration: none;
    font-weight: 500;
}
a:hover {
    text-decoration: underline;
}
</style>" >> "$SORTIE"

echo "</head><body>" >> "$SORTIE"
echo "<h1>Projet PPE</h1>" >> "$SORTIE"
echo "<table>" >> "$SORTIE"
echo "<tr><th>ID</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Nombre de mots</th></tr>" >> "$SORTIE"

while read -r line; do
    code_http=$(curl -s -o /dev/null -w "%{http_code}" "$line")
    encodage=$(curl -sI "$line" | grep -i "Content-Type" | sed -n 's/.*charset=\([^ ;]*\).*/\1/p' | tr -d '\r\n')
    if [ -z "$encodage" ]; then
        encodage="inconnu"
    fi
    contenu=$(curl -s "$line")
    nb_mots=$(echo "$contenu" | sed 's/<[^>]*>//g' | wc -w)

    echo "<tr><td>${compteur}</td><td><a href=\"$line\" target=\"_blank\">${line}</a></td><td>${code_http}</td><td>${encodage}</td><td>${nb_mots}</td></tr>" >> "$SORTIE"

    compteur=$((compteur + 1))
done < "$URLS"

echo "</table></body></html>" >> "$SORTIE"

echo "Fichier HTML généré : $SORTIE"
