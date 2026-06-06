# r-bioinformatics-2026

[![Build and Push Container](https://github.com/armilner/r-bioinformatics-2026/actions/workflows/build.yml/badge.svg)](https://github.com/armilner/r-bioinformatics-2026/actions/workflows/build.yml)
[![R](https://img.shields.io/badge/R-4.4.1-blue)](https://www.r-project.org/)
[![Bioconductor](https://img.shields.io/badge/Bioconductor-3.19-green)](https://bioconductor.org/)
[![Seurat](https://img.shields.io/badge/Seurat-v5-blueviolet)](https://satijalab.org/seurat/)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Apptainer](https://img.shields.io/badge/Apptainer-compatible-orange)](https://apptainer.org/)

---

A comprehensive, ready-to-use R container for bioinformatics analysis built for 2026. Designed for use on HPC clusters via Apptainer/Singularity or locally via Docker. Covers single-cell RNA-seq, bulk RNA-seq, methylation, ATAC-seq, trajectory analysis, and pathway enrichment — no setup required.

Built on [rocker/r-ver:4.4.1](https://rocker-project.org/) with pre-compiled binaries from [Posit Package Manager](https://packagemanager.posit.co/) for fast, reproducible builds.

---

## Quick Start

### Docker
```bash
docker pull ghcr.io/armilner/r-bioinformatics-2026:latest
docker run --rm -it ghcr.io/armilner/r-bioinformatics-2026:latest R
```

### Apptainer / Singularity (HPC)
```bash
apptainer pull r-bioinformatics-2026.sif docker://ghcr.io/armilner/r-bioinformatics-2026:latest
apptainer exec r-bioinformatics-2026.sif Rscript your_script.R
```

### Apptainer with bound filesystem (recommended on HPC)
```bash
apptainer exec --bind /your/project r-bioinformatics-2026.sif Rscript /your/project/script.R
```

---

## What's Included

### Single-Cell RNA-seq
| Package | Description |
|---------|-------------|
| Seurat v5 | Core single-cell analysis framework |
| harmony | Integration across batches and datasets |
| sctransform | Regularized NB normalization |
| scran / scater / scuttle | Bioconductor single-cell utilities |
| scDblFinder | Doublet detection |
| speckle | Differential cell type abundance |
| monocle3 | Trajectory and pseudotime analysis |

### Bulk RNA-seq and Differential Expression
| Package | Description |
|---------|-------------|
| DESeq2 | Negative binomial DE (pseudobulk and bulk) |
| edgeR | Quasi-likelihood DE |
| limma | Linear models for microarray/RNA-seq |
| glmGamPoi | Fast GLM fitting backend for DESeq2 |
| tximport / tximeta | Import transcript-level quantifications |
| DEXSeq | Differential exon usage |
| muscat | Multi-sample multi-condition single-cell DE |
| variancePartition | Variance partitioning across covariates |

### GSEA and Pathway Analysis
| Package | Description |
|---------|-------------|
| clusterProfiler | GO, KEGG, and custom GSEA |
| fgsea | Fast preranked GSEA |
| DOSE | Disease ontology enrichment |
| ReactomePA | Reactome pathway analysis |
| GSVA | Gene set variation analysis |
| enrichplot | Visualization for enrichment results |
| pathview | KEGG pathway visualization |
| msigdbr | MSigDB gene sets (all species) |

### Methylation Analysis
| Package | Description |
|---------|-------------|
| minfi | Illumina array methylation (450k/EPIC) |
| methylKit | Bisulfite sequencing differential methylation |
| BSseq | Whole-genome bisulfite sequencing |
| DMRcate | Differentially methylated region detection |
| sesame | SeSAMe pipeline for Illumina arrays |
| ENmix | Array quality control and normalization |
| missMethyl | Methylation-aware GO/KEGG testing |

### ATAC-seq and Chromatin
| Package | Description |
|---------|-------------|
| Signac | Single-cell ATAC-seq analysis |
| chromVAR | TF motif accessibility |
| motifmatchr | TF motif scanning |
| TFBSTools / JASPAR2020 | JASPAR transcription factor motifs |
| DiffBind | Differential binding for ChIP/ATAC |
| ChIPseeker | Peak annotation and visualization |

### Visualization
| Package | Description |
|---------|-------------|
| ComplexHeatmap | Publication-quality heatmaps |
| EnhancedVolcano | Volcano plots |
| dittoSeq | Colorblind-friendly single-cell plots |
| Nebulosa | Kernel density estimation on embeddings |
| ggplot2 / patchwork / cowplot | General plotting |
| pheatmap / ggrepel / ggridges | Supplementary visualization |

### Annotation Databases
| Package | Description |
|---------|-------------|
| org.Hs.eg.db | Human gene annotation |
| org.Mm.eg.db | Mouse gene annotation |
| org.Rn.eg.db | Rat gene annotation |
| GO.db | Gene Ontology |
| TxDb.Hsapiens.UCSC.hg38.knownGene | Human hg38 transcript database |
| TxDb.Mmusculus.UCSC.mm10.knownGene | Mouse mm10 transcript database |
| biomaRt | Ensembl database queries |
| AnnotationHub / ExperimentHub | Bioconductor annotation resources |

### Infrastructure
| Package | Description |
|---------|-------------|
| tidyverse | Data manipulation and plotting |
| data.table | Fast data operations |
| future / future.apply | Parallelization |
| BiocManager | Bioconductor package management |
| WGCNA | Weighted gene co-expression networks |

---

## Usage on SLURM / HPC

```bash
#!/bin/bash
#SBATCH --job-name=my-analysis
#SBATCH -N 1 -n 1 -c 16 --mem=64G

SIF=/path/to/r-bioinformatics-2026.sif
apptainer exec --bind /your/project $SIF Rscript /your/project/analysis.R
```

---

## Build Details

- **Base image:** rocker/r-ver:4.4.1 (Ubuntu 22.04 Jammy)
- **R version:** 4.4.1
- **Bioconductor:** 3.19
- **CRAN binaries:** Posit Package Manager (Ubuntu Jammy)
- **Built:** June 2026

Container images are built automatically via GitHub Actions and pushed to the GitHub Container Registry on every commit to `main`.

---

## License

MIT License — free to use, modify, and distribute with attribution.
