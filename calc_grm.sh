#!/bin/bash

inpgeno=$1
outgeno=$2

echo " "
echo "... using GMATRIX package from ' Guosheng Su and Per Madsen (Aarhus university)' ..."
echo '... read about the software from "http://dmu.agrsci.dk/Gmatrix/Doc/Previous/Gmatrix-User-Guide.pdf" ...'
echo ""

cat ${inpgeno}.ped | cut -d' ' -f2,7- | awk '{$1=NR; print}' > marker.dat
cat ${inpgeno}.ped | cut -d' ' -f2 | awk '{$2=NR; print}' >  grm.orig_codedIDs
cp ${inpgeno}.map map.dat

echo "... files prepared for gmatix ..."
./gmatrix par.dat > ${outgeno}.output

mv gmatrix.dat ${outgeno}.grm
cat ${outgeno}.grm | awk '{print $2,$1,$3}' | sort -n -k1 -n -k2 > ${outgeno}_asreml.grm
cat igmatrix.dat | awk 'NR>1' > ${outgeno}.giv
cat ${outgeno}.giv | awk '{print $2,$1,$3}' | sort -n -k1 -n -k2 > ${outgeno}_asreml.giv
rm map.dat igmatrix.dat marker.dat

echo "... Analysis finished ..."

