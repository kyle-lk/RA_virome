#!bin/bash

$THREADS=??
$output=??


###  1. Quality control
#############################

## removing adaptor and trimming
cutadapt --g file:adaptor.fa -a file:adaptor.fa -n 3 -O 13 -o seq_1.cleaned.fq.gz seq_1.cleaned.fq.gz 
cutadapt --g file:adaptor.fa -a file:adaptor.fa -n 3 -O 13 -o seq_2.cleaned.fq.gz seq_2.cleaned.fq.gz 


## remove low quality sequence and human contamination
kneaddata -v -t $THREADS -o $output -i seq_1.cleaned.fq.gz -i seq_2.cleaned.fq.gz --remove-intermediate-output --trimmomatic  --trimmomatic-options "SLIDINGWINDOW:4:20 MINLEN:50" --bowtie2-options "--very-sensitive --dovetail" -db hg19


#### 2. de novo assembly 
##############################
megahit -1 $output/seq_1.cleaned_decontamination.fq  -2 $output/seq_2.cleaned_decontamination.fq --presets meta-sensitive -o $output/megahit  -t $THREADS
                                                                                                                                
cat $output/megahit/final.contigs.fa |sed 's/ /~/g' |awk 'BEGIN{RS=">"}NR>1{sub("\n","\t");gsub("\n","");if(length($NF)>=1000) printf "%s\n%s\n", ">"$
1,$2}'|sed 's/~/ /g' > $output/merged/merged_contigs_lt1000.fasta
                                                                  
#### 3. non-redundant contigs set 
##############################

vsearch --cluster_fast  $output/merged/merged_contigs_lt1000.fasta --maxseqlength 10000000000  --sizein --sizeout --centroid $output/merged/vsearch/Non_redundant_contigs.fa  --id 0.95 --relabel contigs_cluasted --threads $THREADS


#### 4. Candidate viral contigs selection
##############################
blastn -query  $output/merged/vsearch/Non_redundant_contigs.fa  -evalue 1e-8   -task megablast  -num_alignments 50 -out $output/merged/vsearch/Non_redundant_contigs_blastn_nt.out   -outfmt 6   -num_threads 15    -db nt_database

CAT contigs -c $output/merged/vsearch/Non_redundant_contigs.fa -d CAT_prepare_20210107/2021-01-07_CAT_database -t CAT_prepare_20210107/2021-01-07_taxonomy  --path_to_diamond diamond
CAT add_names -i out.CAT.contig2classification.txt -o out.CAT.contig2classification_addname.txt -t 2021-01-07_taxonomy --only_official   ## add taxonomy
cat out.CAT.contig2classification_addname.txt | grep -E "Viruses|phage" > Viruses_hit.txt    ## selection

python dvf.py -i $output/merged/vsearch/candidate_virus_contigs.fa -o  $output/merged/dvf_output -l 500 -c $THREADS  ## DeepVirFinder 

virsorter run -w $output/merged/virsorter2 -i $output/merged/vsearch/candidate_virus_contigs.fa  all

#### 5. CheckV analysis
##############################

checkv end_to_end candidate_virus_contigs_selected.fna checkv_output -d $THREADS  -d checkv_database

#### 6. lytic vs lysogenic phage identification
##############################

VIBRANT_run.py -i curated_contigs.fna -f prot -t 15 -virome     ###### selecting lytic and lysogenic results

#### 7. AMGs annotation
##############################

VIBRANT_run.py -i curated_contigs.fna -f prot -t 15 -virome       ####### selecting AMG annotation results








