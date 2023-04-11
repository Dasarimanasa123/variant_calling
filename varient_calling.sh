# !/bin/bash

# step 1: fastqc ##

fastqc raw_data/SRR23929852/*.fastq -o raw_data/

# step :2 trimmomatic ###

trimmomatic PE -threads 4 raw_data/SRR23929852/SRR23929852_1.fastq raw_data/SRR23929852/SRR23929852_2.fastq  trimmdata/SRR23929852_1_paired.fastq trimmdata/SRR23929852_1_unpaired.fastq trimmdata/SRR23929852_2_paired.fastq trimmdata/SRR23929852_2_unpaired.fastq HEADCROP:10

fastqc trimmdata/SRR23929852_1_paired.fastq
fastqc trimmdata/SRR23929852_2_paired.fastq

#indexing the ref seq ##
bwa index ref_seq/GCF_000005845.2_ASM584v2_genomic.fna 

## alignment ##

#bwa mem ref_seq/GCF_000005845.2_ASM584v2_genomic.fna trimmdata/SRR23929852_1_paired.fastq trimmdata/SRR23929852_2_paired.fastq > results/sam/data.sam |

samtools view -s -b results/sam/data.sam > results/bam/data.bam

samtools sort -o results/bam/data.sorted.bam results/bam/data.bam


bcftools mpileup -O b -o results/bcf/data_raw.bcf / -f data/ref_seq/GCF_000005845.2_ASM584v2_genomic.fna results/bam/data.bam

bcftool call --ploidy 1 -m -v -o results/vcf/data_varients.vcf results/bcf/data_raw.bcf

vcfutils.p1 varFilter results/vcf/data_varients.vcf > results/vcf/data_fina_varients.vcf
