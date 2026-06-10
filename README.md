# hpylori-within-host-amr
This project investigates antimicrobial resistance (AMR) differences between Helicobacter pylori isolates collected from the same individuals. The isolates share the same strain origin but differ in resistance phenotype, suggesting that mutations and/or horizontal gene transfer (HGT) drive AMR evolution within a single host.
## Isolates 
12 isolates from 6 patients: 
HPL018, HPL249, HPL326, HPL538, HPL608, HPL819
## Pipeline
## Step 1 - Genome Annotation (Prokka)
Each isolate assembly is annotated using Prokka to identify genes, tRNAs, rRNAs and coding sequences.
## Step 2 - Pan-genome Analysis (PIRATE)
All 12 annotated genomes are compared using PIRATE to identify core genes (shared by all isolates) and accessory genes (present in only some isolates, candidates for HGT).
## Software Used
[Prokka](https://github.com/tseemann/prokka) v1.15.6
[PIRATE](https://github.com/SionBayliss/PIRATE)
[AMRFinder+](https://github.com/ncbi/amr) — NCBI tool for AMR gene and mutation detection
SnpEff (in progress)
HPC: University of Leicester ALICE cluster
## Usage
Scripts are located in '/scripts'. Run on an HPC cluster with SLURM. 
'''bash
sbatch scripts/prokka_pirate.sh
'''
## Results Summary
2,408 gene families identified across 12 isolates
1,295 core genes (shared by 95–100% of isolates)
649 accessory genes (potential HGT candidates)
pbp1a beta-lactam resistance mutations identified in 8/12 isolates
  (S543R in HPL018, HPL326, HPL538; T438M unique to HPL608)
copP copper stress gene present in all 12 isolates (core genome)
Full results in `/results`

