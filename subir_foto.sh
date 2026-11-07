#!/bin/bash

cd "$(dirname "$0")"

# 1. Elegir la foto
FOTO=$(zenity --file-selection \
  --title="Elegir foto para el archivo" \
  --file-filter="Imágenes | *.jpg *.jpeg *.png *.gif *.webp" \
  --filename="$HOME/Descargas/")

if [ -z "$FOTO" ]; then
  zenity --info --title="Cancelado" --text="No se eligió ninguna foto." --width=300
  exit 0
fi

# 2. Escribir el pie de foto
TEXTO=$(zenity --entry \
  --title="Pie de foto" \
  --text="Escribe el texto que irá debajo de la imagen:" \
  --width=500)

if [ -z "$TEXTO" ]; then
  zenity --info --title="Cancelado" --text="No se escribió ningún texto." --width=300
  exit 0
fi

# 3. Fecha (opcional)
FECHA=$(zenity --entry \
  --title="Fecha (opcional)" \
  --text="Escribe la fecha/hora a mostrar (ej: 12/03/2024 — 23:47).\nSi lo dejas vacío, se usará la fecha y hora actual." \
  --width=500)

if [ -z "$FECHA" ]; then
  FECHA=$(date '+%d/%m/%Y — %H:%M')
fi

# 4. Subir la foto
SALIDA=$(./add_photo.sh "$FOTO" "$TEXTO" "$FECHA" 2>&1)
CODIGO=$?

if [ $CODIGO -eq 0 ]; then
  zenity --info \
    --title="Foto añadida" \
    --text="La foto se ha subido correctamente.\n\nEn 1-2 minutos estará visible en:\nhttps://remphy25.github.io/archivo/" \
    --width=450
else
  zenity --error \
    --title="Error" \
    --text="Algo falló al subir la foto:\n\n$SALIDA" \
    --width=500
fi
