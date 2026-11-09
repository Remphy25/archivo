#!/bin/bash
set -e

FOTO="$1"
if [ -z "$FOTO" ]; then
  echo "Uso: ./del_photo.sh <nombre_de_la_foto>"
  exit 1
fi

# 1. Borrar el archivo físico
if [ -f "$FOTO" ]; then
  rm "$FOTO"
fi

# 2. Borrar el bloque HTML
python3 - "$FOTO" << 'PYEOF'
import sys
filename = sys.argv[1]
with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

parts = html.split('<div class="foto">')
new_parts = [parts[0]]
for part in parts[1:]:
    if f'<img src="{filename}"' in part:
        continue 
    else:
        new_parts.append('<div class="foto">' + part)

with open('index.html', 'w', encoding='utf-8') as f:
    f.write(''.join(new_parts))
PYEOF

# 3. Subir a GitHub
git add .
git commit -m "eliminar foto: $FOTO" || echo "No hay cambios para hacer commit."
git push

echo "✓ Foto $FOTO eliminada."
