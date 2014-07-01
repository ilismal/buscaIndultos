#!/bin/bash
curl -s http://www.boe.es/robots.txt | grep "\.pdf" | grep -v \* | awk '{print $NF}' >> listaPDF.txt
for ruta in $(cat listaPDF.txt);
do
        wget http://www.boe.es$ruta -qO temp.pdf
        pdf2txt temp.pdf >> temp.txt 2>/dev/null
        echo "$(cat temp.txt | sed 's/ //g' | grep -i indulto | wc -l) referencia(s) a indultos en http://www.boe.es$ruta"
        rm temp.*
done
