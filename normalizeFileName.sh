#!/bin/bash

normalize_filename() {
    # Vérifie si un argument a été passé
    if [ -z "$1" ]; then
        echo "Veuillez fournir un nom de fichier."
        return 1
    fi

    # Récupère le nom de fichier passé en paramètre
    local filename="$1"

    # Sépare le nom de fichier et l'extension
    local name="${filename%.*}"        # Nom sans extension
    local extension="${filename##*.}"   # Extension

    # On ne fait la normalisation que si le fichier contient des espaces
    if [[ "$name" == *" "* ]]; then
        # Capitalise le nom de fichier (première lettre de chaque mot)
        name=$(echo "$name" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')
        # Supprime les espaces du nom
        name=$(echo "$name" | tr -d ' ')
    fi 

    # Met l'extension en minuscule
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

    # Combine le nom et l'extension normalisés
    local normalized_filename="${name}.${extension}"

    echo "$normalized_filename"
}

# Si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Vérifie si un répertoire a été passé en argument
    if [ -z "$1" ]; then
        echo "Veuillez fournir un répertoire."
        exit 1
    fi

    # Boucle sur tous les fichiers du répertoire
    for file in "$1"/*; do
        if [ -f "$file" ]; then
            # Normalise le nom de fichier
            normalized=$(normalize_filename "$(basename "$file")")
            echo "Fichier original : $(basename "$file") -> Fichier normalisé : $normalized"
            # Renomme le fichier (décommenter pour activer)
            mv "$file" "$(dirname "$file")/$normalized"
        fi
    done
fi
