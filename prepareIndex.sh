#!/bin/bash
INPUT_FILE="index.txt"
INDEXE_FILE="listeIndex.txt"
LISTE_FILE="listeImage.txt"
REP_IMAGE="./images"
# Récupérer les image déjà indexées
cut -d":" -f2 "$INPUT_FILE" | sort > "$INDEXE_FILE"

# Récupérer les images du répertoire
ls "$REP_IMAGE" | sort > "$LISTE_FILE"

# Comparaison des deux fichiers
# diff "$INDEXE_FILE" "$LISTE_FILE"
comm -13 "$INDEXE_FILE" "$LISTE_FILE"

# Trouve les fichiers présents dans fichier2 mais absents dans fichier1
while IFS= read -r fichier; do
    if ! grep -Fxq "$fichier" "$INDEXE_FILE"; then
        echo "nouveau:$fichier" >> "$INPUT_FILE"
    fi
done < "$LISTE_FILE"

# Clean
rm "$INDEXE_FILE" "$LISTE_FILE"

