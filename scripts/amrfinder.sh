#!/bin/bash
#SBATCH --job-name=hpylori_amrfinder
#SBATCH --time=04:00:00
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=rri3@le.ac.uk
#SBATCH --output=amrfinder_%j.log
DATA_DIR="/home/r/rri3/hpylori_project/assemblies"
AMR_DIR="${DATA_DIR}/amrfinder_results"
mkdir -p "$AMR_DIR"
eval "$(conda shell.bash hook)"
conda activate amrfinder_env
ISOLATES=(
    HPL018C1R3
    HPL249C14R6
    HPL326C2R4
    HPL538C2R5
    HPL608C2R7
    HPL819C2R2
    HPL018C2R3
    HPL249C7R4
    HPL326PR4C1
    HPL538C3R3
    HPL608C3R7
    HPL819C4R2
)
echo "=== Running AMRFinder+ on all isolates ==="
for ISOLATE in "${ISOLATES[@]}"; do
    FASTA="${DATA_DIR}/${ISOLATE}"
    GFF="${DATA_DIR}/prokka_out_${ISOLATE}/${ISOLATE}.gff"
    if [[ ! -f "$FASTA" ]]; then
        echo "WARNING: FASTA not found for ${ISOLATE} — skipping."
        continue
   fi
   echo "Running AMRFinder+ on: ${ISOLATE}"
   amrfinder \
        -n "$FASTA" \
        --gff "$GFF" \
        --organism Helicobacter_pylori \
        --plus \
        --threads 8 \
        --name "${ISOLATE}" \
        -o "${AMR_DIR}/${ISOLATE}_amrfinder.tsv"
   echo "  -> Results saved to ${AMR_DIR}/${ISOLATE}_amrfinder.tsv"
done
echo "=== All isolates complete ==="
# Combine all results into one summary table
echo "=== Merging all results into combined_amrfinder_results.tsv
# Write header from first output file
FIRST="${AMR_DIR}/${ISOLATES[0]}_amrfinder.tsv"
head -1 "$FIRST" > "${AMR_DIR}/combined_amrfinder_results.tsv"
# Append data rows from all files
for ISOLATE in "${ISOLATES[@]}"; do
    FILE="${AMR_DIR}/${ISOLATE}_amrfinder.tsv"
    if [[ -f "$FILE" ]]; then
        tail -n +2 "$FILE" >> "${AMR_DIR}/combined_amrfinder_results.tsv"
    fi
done
echo "=== Pipeline complete. Combined results in ${AMR_DIR}/combined_amrfinder_results.tsv ==="
