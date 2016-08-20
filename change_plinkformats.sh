#!/bin/bash

######################################
inpfile=$1
outfile=$2
oldformat=$3
newformat=$4
species=$5
#######################################

if [ $inpfile = help ]; then
 echo "---------------------------------------------------"
 echo "---------- Input argument are as follows ----------"
 echo " 1. input file name "
 echo " 2. output file name "
 echo " 3. PLINK format of input file "
 echo " 4. Intended PLINK format of output file "
 echo " 5. species "
 echo " "
 echo "----------------------------------------------------"
exit
fi


if [ $oldformat = bin ] && [ $newformat = ped ]; then
 echo ".........converting from binary format to linkage file (ped+map) format.........."
 plink1.90 --silent --${species} --noweb --nonfounders --bfile $inpfile --recode --out $outfile
  
 if [ ! -f ${outfile}.ped ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi
 
elif [ $oldformat = bin ] && [ $newformat = tped ]; then
 echo ".........converting from binary format to tranposed file (tped+tfam) format.........."
 plink1.90 --silent --${species} --noweb --nonfounders --bfile $inpfile --recode transpose --out $outfile

 if [ ! -f ${outfile}.tped ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi

elif [ $oldformat = ped ] && [ $newformat = bin ]; then
 echo ".........converting from linkage format to binary file (bed+bim+fam) format.........."
 plink1.90 --silent --${species} --noweb --nonfounders --file $inpfile --make-bed --out $outfile

 if [ ! -f ${outfile}.bed ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi

elif [ $oldformat = ped ] && [ $newformat = tped ]; then
 echo ".........converting from linkage format to transposed file (tped+tfam) format.........."
 plink1.90 --silent --${species} --noweb --nonfounders --file $inpfile --recode transpose --out $outfile

 if [ ! -f ${outfile}.tped ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi

elif [ $oldformat = tped ] && [ $newformat = bin ]; then
 echo ".........converting from transposed format to binary file (bed+bim+fam) format.........."
 plink1.90 --silent --cow --noweb --nonfounders --tfile $inpfile --make-bed --out $outfile

 if [ ! -f ${outfile}.bed ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi

elif [ $oldformat = tped ] && [ $newformat = ped ]; then
 echo ".........converting from transposed format to linkage file (ped+map) format.........."
 plink1.90 --silent --${species} --noweb --nonfounders --tfile $inpfile --recode --out $outfile

 if [ ! -f ${outfile}.ped ]; then
  echo "....... errors with recoding ........."
  cat $outfile.log
 else
 echo "...... recoding finished ..........."
 fi

fi
