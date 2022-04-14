# ////////////////////////////////////////////////////////////////////////////
# FILE: import_vcfs.sh
# AUTHOR: David Ruvolo
# CREATED: 2020-11-18
# MODIFIED: 2021-02-19
# PURPOSE: script organizing and importing vcfs
# DEPENDENCIES: mcmd (molgenis commander); RScript
# COMMENTS: NA
# ////////////////////////////////////////////////////////////////////////////

# download compressed files to ~/Downloads (or your default location) and
# then move them into molgenis-go-nl/vcfs/
mv ~/Downloads/gonl.* vcfs/
mkdir vcfs/gzip/

# batch unpack gz files keep original
for v in vcfs/*; do echo "Unpacking: $v"; gunzip -k $v; done

# keep gz files, but move into gzip folder
mv vcfs/*.vcf.gz vcfs/gzip/

# push source data
# a shell script could be written, but it's probably just as easy to
# import the files 1-by-1 to make sure they are all imported correctly
cd vcfs/
mcmd import -p gonl.chr1.snps_indels.r5.vcf --in gonl --as gonl_chr1 # done
mcmd import -p gonl.chr2.snps_indels.r5.vcf --in gonl --as gonl_chr2 # done
mcmd import -p gonl.chr3.snps_indels.r5.vcf --in gonl --as gonl_chr3 # done
mcmd import -p gonl.chr4.snps_indels.r5.vcf --in gonl --as gonl_chr4 # done
mcmd import -p gonl.chr5.snps_indels.r5.vcf --in gonl --as gonl_chr5 # done
mcmd import -p gonl.chr6.snps_indels.r5.vcf --in gonl --as gonl_chr6 # done
mcmd import -p gonl.chr7.snps_indels.r5.vcf --in gonl --as gonl_chr7 # done
mcmd import -p gonl.chr8.snps_indels.r5.vcf --in gonl --as gonl_chr8 # done
mcmd import -p gonl.chr9.snps_indels.r5.vcf --in gonl --as gonl_chr9 # done
mcmd import -p gonl.chr10.snps_indels.r5.vcf --in gonl --as gonl_chr10 # done
mcmd import -p gonl.chr11.snps_indels.r5.vcf --in gonl --as gonl_chr11 # done
mcmd import -p gonl.chr12.snps_indels.r5.vcf --in gonl --as gonl_chr12 # done
mcmd import -p gonl.chr13.snps_indels.r5.vcf --in gonl --as gonl_chr13 # done
mcmd import -p gonl.chr14.snps_indels.r5.vcf --in gonl --as gonl_chr14 # done
mcmd import -p gonl.chr15.snps_indels.r5.vcf --in gonl --as gonl_chr15 # done
mcmd import -p gonl.chr16.snps_indels.r5.vcf --in gonl --as gonl_chr16 # done
mcmd import -p gonl.chr17.snps_indels.r5.vcf --in gonl --as gonl_chr17 # done
mcmd import -p gonl.chr18.snps_indels.r5.vcf --in gonl --as gonl_chr18 # done
mcmd import -p gonl.chr19.snps_indels.r5.vcf --in gonl --as gonl_chr19 # done
mcmd import -p gonl.chr20.snps_indels.r5.vcf --in gonl --as gonl_chr20 # done
mcmd import -p gonl.chr21.snps_indels.r5.vcf --in gonl --as gonl_chr21 # done
mcmd import -p gonl.chr22.snps_indels.r5.vcf --in gonl --as gonl_chr22 # done