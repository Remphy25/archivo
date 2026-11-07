#!/bin/bash
set -e

FOTO="$1"
TEXTO="$2"
FECHA="${3:-$(date '+%d/%m/%Y — %H:%M')}"

if [ -z "$FOTO" ] || [ -z "$TEXTO" ]; then
  echo "Uso: ./add_photo.sh <ruta_foto> \"texto\" [\"fecha\"]"
  exit 1
fi
if [ ! -f "$FOTO" ]; then
  echo "No existe: $FOTO"
  exit 1
fi

NOMBRE="$(date +%s)-$(basename "$FOTO" | tr ' ' '_')"
cp "$FOTO" "$NOMBRE"

python3 - "$NOMBRE" "$TEXTO" "$FECHA" << 'PYEOF'
import sys
nombre, texto, fecha = sys.argv[1], sys.argv[2], sys.argv[3]
texto = texto.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;').replace('"','&quot;')
with open('index.html','r',encoding='utf-8') as f:
    html = f.read()
bloque = f'''<div class="foto">
  <span class="fecha">{fecha}</span>
  <img src="{nombre}" alt="">
  <p>{texto}</p>
</div>

<div id="fotos"></div>'''
html = html.replace('<div id="fotos"></div>', bloque, 1)
with open('index.html','w',encoding='utf-8') as f:
    f.write(html)
PYEOF

git add .
git commit -m "nueva foto: $NOMBRE"
git push

echo ""
echo "✓ Foto añadida."
echo "  En 1 minuto: https://remphy25.github.io/archivo/"
