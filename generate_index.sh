#!/bin/bash

# Chemin vers les fichiers HTML
HEADER="header.html"
FOOTER="footer.html"
INDEX="index.html"
INDEX_TXT="index.txt"
IMAGES_DIR="images"
THUMBNAILS_DIR="thumbnails"

# Créer le répertoire pour les vignettes s'il n'existe pas
mkdir -p $THUMBNAILS_DIR

# Générer le fichier HTML
cat $HEADER > $INDEX

# Lire le fichier d'index et générer la galerie
while IFS= read -r line; do
    # Extraire le libellé et le nom du fichier
    label=$(echo $line | cut -d ':' -f 1 | sed 's/^ *- *//')
    filename=$(echo $line | cut -d ':' -f 2 | sed 's/^ *//')

    # Convertir l'image en vignette avec ImageMagick
    thumbnail="${filename%.jpg}-thumbnail.jpg"
    convert "$IMAGES_DIR/$filename" -resize 320 -density 72 "$THUMBNAILS_DIR/$thumbnail"

    # Ajouter l'entrée HTML pour l'image
    cat >> $INDEX <<EOL
    <figure>
        <a href="images/$filename" download>
            <img src="thumbnails/$thumbnail" alt="$label">
        </a>
        <figcaption>$label</figcaption>
    </figure>
EOL
done < $INDEX_TXT

# Ajouter le pied de page
cat $FOOTER >> $INDEX

