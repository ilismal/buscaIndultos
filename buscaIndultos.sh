#!/bin/bash
curl -s http://www.boe.es/robots.txt | grep "\.pdf" | grep -v \* | awk '{print $NF}' >> listaPDF.txt
totalFicheros=$(cat listaPDF.txt | wc -l)
echo "$totalFicheros ficheros a analizar"
conIndulto=0
sinIndulto=0
contador=0
for ruta in $(cat listaPDF.txt);
do
        echo -ne "Analizando a $contador de $totalFicheros [http://www.boe.es$ruta]"\\r
        wget http://www.boe.es$ruta -qO temp.pdf
        pdf2txt temp.pdf >> temp.txt 2>/dev/null
        referencias=$(cat temp.txt | sed 's/ //g' | grep -i "indult|conmuta" | wc -l)
        if [ "$referencias" = "0" ]
        then
                sinIndulto=$(( sinIndulto + 1 ))
        else
                conIndulto=$(( conIndulto + 1 ))
                echo "http://www.boe.es$ruta" >> pdfConIndultos.txt
        fi
        #echo "$referencias referencia(s) a indultos en http://www.boe.es$ruta"
        rm temp.*
        contador=$(( contador + 1 ))
done
echo "$totalFicheros analizados"
echo "$conIndulto con referencias a indultos"
echo "$sinIndulto sin referencias a indultos"
