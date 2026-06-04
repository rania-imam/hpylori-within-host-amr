#!/bin/bash
#SBATCH --job-name=hpylori_prokka_pirate
#SBATCH --time=08:00:00
#SBATCH --mem=24G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=rri3@le.ac.uk
#SBATCH --output=prokka_pirate_%j.log

DATA_DIR="/home/r/rri3/hpylori_project/assemblies"

eval "$(conda shell.bash hook)"
conda activate prokka_env

GFF_DIR="${DATA_DIR}/gff_collection"
mkdir -p "$GFF_DIR"

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

echo "=== Step 1: Running Prokka annotations ==="

for ISOLATE in "${ISOLATES[@]}"; do
    FASTA="${DATA_DIR}/${ISOLATE}"

    if [[ ! -f "$FASTA" ]]; then
        echo "WARNING: File not found for ${ISOLATE} — skipping."
        continue
    fi

    echo "Annotating: ${ISOLATE}"
    prokka \
        --cpus 8 \
        --outdir "${DATA_DIR}/prokka_out_${ISOLATE}" \
        --prefix "${ISOLATE}" \
        --genus Helicobacter \
        --species pylori \
        --force \
        "$FASTA"

    cp "${DATA_DIR}/prokka_out_${ISOLATE}/${ISOLATE}.gff" "$GFF_DIR/"
    echo "  -> GFF saved to ${GFF_DIR}/${ISOLATE}.gff"
done

echo "=== Step 1 complete: $(ls ${GFF_DIR}/*.gff 2>/dev/null | wc -l) GFF files ready ==="

echo "=== Step 2: Running PIRATE pangenome analysis ==="

PIRATE \
    -i "$GFF_DIR" \
    -o "${DATA_DIR}/pirate_results" \
    -t 8 \
    -a

echo "=== Pipeline complete. Results in ${DATA_DIR}/pirate_results ==="
