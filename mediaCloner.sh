#!/bin/bash

# Quell- und Zielverzeichnisse definieren
SOURCE_DIR="./DCIM/DJI_001"
PHOTO_DEST_DIR="/Volumes/home/Photos/photo"
VIDEO_DEST_DIR="/Volumes/home/Photos/video"

# Überprüfen, ob das Zielverzeichnis gemountet ist
if [ ! -d "/Volumes/home" ]; then
    echo "Das Verzeichnis /Volumes/home ist nicht gemountet. Bitte mounten Sie es und versuchen Sie es erneut."
    exit 1
fi

# Funktion zum Kopieren und Organisieren von Dateien
organize_files() {
    local file_ext="$1"
    local dest_dir="$2"

    find "$SOURCE_DIR" -type f -iname "*.$file_ext" | while read -r file; do
        # Extrahiere das Datum aus dem Dateinamen
        BASENAME=$(basename "$file")
        if [[ $BASENAME =~ DJI_([0-9]{4})([0-9]{2})([0-9]{2}) ]]; then
            YEAR=${BASH_REMATCH[1]}
            MONTH=${BASH_REMATCH[2]}
            DATE="$YEAR/$MONTH"
            echo "Datum aus Dateiname extrahiert: $DATE"
        else
            echo "Kein gültiges Datum im Dateinamen gefunden. Überspringe Datei: $file"
            continue
        fi

        # Zielverzeichnis basierend auf Datum erstellen
        TARGET_DIR="$dest_dir/$DATE"
        mkdir -p "$TARGET_DIR"

        # Datei kopieren, Duplikate überspringen
        rsync -av --ignore-existing "$file" "$TARGET_DIR/"
    done
}

# Fotos kopieren und organisieren
organize_files "JPG" "$PHOTO_DEST_DIR"
organize_files "DNG" "$PHOTO_DEST_DIR"

# Videos kopieren und organisieren
organize_files "mp4" "$VIDEO_DEST_DIR"

echo "Kopieren und Organisieren abgeschlossen!"