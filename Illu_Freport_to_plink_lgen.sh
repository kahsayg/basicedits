#!/bin/bash

######################################################################################
######################################################################################
####    Convert from Illumina Final report to PLINK LGEN (.lgen,.fam,.map)       #####
####              and finally to PLINK binary data (.bim,.bed,.fam)              #####
####                                                                             #####
####                                  by S.A. Boison (soloboan@yahoo.com)        #####
######################################################################################

## Input parameters
###################################################
inpfilename=$1              # names of Finalreport file
outfilename=$2              # output name
ID=$3                       # column of IDs
snpID=$4                    # column of SNP names
allele1=$5                  # column of Allele 1 (please select the Alelle1...AB)
allele2=$6                  # column of Allele 1 (please select the Alelle2...AB)
chr=$7                      # column with the chromosomes
pos=$8                      # column with the physical position
NSNPs=$9                    # the total number of SNPs genotyped (eg. 777962 or 54609)
####################################################


echo ''

###################################################################
# # Download PLINK from the web if not available
if [ ! -f plink ]; then
 echo "plink was not found in the current directory, thus it been download"
 echo " "
 wget http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-x86_64.zip
 unzip plink-1.07-x86_64.zip
 cp plink-1.07-x86_64/plink .
 ./plink --noweb --silent --file plink-1.07-x86_64/test
 rm -r plink-1.07-x86_64*
 if [ ! -f plink.log ]; then
  wget http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-i686.zip
  unzip plink-1.07-i686.zip
  cp plink-1.07-i686/plink .
  rm -r plink-1.07-i686*
  echo " "
 fi
rm plink.log
echo '........ Downloading done ...........'
fi
######################################################################


#### creating .lgen file
# The columns in the LGEN file are
#     family ID
#     individual ID
#     snp ID
#     allele 1 of this genotype
#     allele 2 of this genotype
echo ''
echo '........... Data Processing Started ..............'
echo '........ LGEN file been created ........'
 
cat $inpfilename | 
awk -v I=$ID -v E=$snpID -v A=$allele1 -v B=$allele2 -F',' 'NR>10 {print $I,$I,$E,$A,$B}' | 
awk '{if($4=="-") $4=0; else $4=$4; if($5=="-") $5=0; else $5=$5; print}' > $outfilename.lgen

echo '........ LGEN file fully created ........'

###### creating .map file
# The columns in the MAP file are
#     chromosome (0 if unplaced)
#     snp identifier
#     Genetic distance (morgans)
#     Base-pair position (bp units)
echo ''
echo '........ MAP file been created ........'

cat $inpfilename | 
awk -v P=$pos -v C=$chr -v E=$snpID -v j=$NSNPs -F',' 'NR>10 && NR<(10+j+1) {print $C,$E,0,$P}' > $outfilename.map

echo '........ MAP file fully created ........'

####### creating .fam file
# The columns in the FAM file are (1 row per record/person/$
#   family ID
#   individual ID
#   sire ID (-9 for missing)
#   dam ID (-9 for missing)
#   sex (1-male, 2-female, 0-unknown)
#   phenotype (-9 for missing)

echo '........ FAM file been created ........'

cat $inpfilename | 
awk -v I=$ID -F',' 'NR>10 {print $I}'  | uniq | 
awk '{print $1,$1,0,0,0,-9}' > $outfilename.fam

echo '........ FAM file fully created ........'

echo ''
echo '..... PLINK started ......'
echo ''

# read the data with PLINK and create binary or PED and MAP file
# binary data (.bed; .bim; .fam)
./plink --cow --noweb \
--nonfounders --allow-no-sex \
--lfile $outfilename \
--make-bed --out \
$outfilename.raw

# Remove Unmapped; X; Y; MT chromosome
cut -f1 $outfilename.raw.bim | sort | uniq | awk '{if($1 < 1 || $1>29) print $1,0,1600000000,"remchr"NR}' > remchr.txt

./plink --cow --noweb \
--nonfounders --allow-no-sex \
--bfile $outfilename.raw \
--exclude remchr.txt \
--range --make-bed --out $outfilename

rm *nosex *nof remchr.txt


echo ''
echo ''
echo '...................    Program ended successfully    .....................'
echo '................ PLINK binary data have been created ......................'
echo '.... Files with raw data (autosomes and sex + mt chromosomes) .....'$outfilename.raw.bed $outfilename.raw.bim $outfilename.raw.fam
echo '.... Files with ONLY autosomal chromosomes .....'$outfilename.bed $outfilename.bim $outfilename.fam
echo '..........................................................................'

###########################################################################################
