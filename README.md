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

## Usage

### On HPC with Apptainer / Singularity (recommended)

Most HPC clusters use Apptainer (formerly Singularity). Pull the container once, then use the `.sif` file for all subsequent runs.

**1. Pull the image**
```bash
apptainer pull r-bioinformatics-2026.sif docker://ghcr.io/armilner/r-bioinformatics-2026:latest
```

**2. Run a script**
```bash
apptainer exec --bind /path/to/your/project r-bioinformatics-2026.sif \
    Rscript /path/to/your/project/analysis.R
```

**3. Interactive R session**
```bash
apptainer exec --bind /path/to/your/project r-bioinformatics-2026.sif R
```

**4. Submit a SLURM job**
```bash
#!/bin/bash
#SBATCH --job-name=my-analysis
#SBATCH -N 1 -n 1 -c 16 --mem=64G --time=4:00:00

SIF=/path/to/r-bioinformatics-2026.sif
apptainer exec --bind /path/to/your/project $SIF \
    Rscript /path/to/your/project/analysis.R
```

> **Note on `--bind`:** Apptainer does not automatically mount your filesystem. Pass `--bind /path/to/data` for every directory your script needs to read or write. You can bind multiple paths: `--bind /data,/scratch,/home/user`.

---

### Locally with Docker

**Pull and run interactively**
```bash
docker pull ghcr.io/armilner/r-bioinformatics-2026:latest
docker run --rm -it ghcr.io/armilner/r-bioinformatics-2026:latest R
```

**Run a script with your project mounted**
```bash
docker run --rm \
    -v /path/to/your/project:/project \
    ghcr.io/armilner/r-bioinformatics-2026:latest \
    Rscript /project/analysis.R
```

**RStudio in the browser (via rocker)**
```bash
docker run --rm -p 8787:8787 \
    -e PASSWORD=yourpassword \
    -v /path/to/your/project:/home/rstudio/project \
    ghcr.io/armilner/r-bioinformatics-2026:latest
```
Then open `http://localhost:8787` in your browser (username: `rstudio`, password: as set above).

---

### Installing additional packages at runtime

All packages listed below are pre-installed. If you need something extra without rebuilding the container, install into a user library that persists on your mounted filesystem:

```r
# In your R script or interactively
dir.create("~/R/library", recursive = TRUE, showWarnings = FALSE)
.libPaths(c("~/R/library", .libPaths()))
install.packages("extrapackage")
# or
BiocManager::install("extrapackage")
```

As long as `~` (your home directory) is bound to persistent storage, the installed packages survive across container runs.

---

## What's Included

### Single-Cell RNA-seq
| Package | Version | Description |
|---------|---------|-------------|
| Seurat | 5.5.0 | Core single-cell analysis framework |
| harmony | 2.0.2 | Integration across batches and datasets |
| sctransform | 0.4.3 | Regularized NB normalization |
| scran | Bioc 3.19 | Bioconductor single-cell normalization |
| scater / scuttle | Bioc 3.19 | Bioconductor single-cell utilities |
| scDblFinder | Bioc 3.19 | Doublet detection |
| speckle | Bioc 3.19 | Differential cell type abundance |
| monocle3 | GitHub | Trajectory and pseudotime analysis |

### Bulk RNA-seq and Differential Expression
| Package | Version | Description |
|---------|---------|-------------|
| DESeq2 | 1.46.0 | Negative binomial DE (pseudobulk and bulk) |
| edgeR | Bioc 3.19 | Quasi-likelihood DE |
| limma | Bioc 3.19 | Linear models for microarray/RNA-seq |
| glmGamPoi | 1.18.0 | Fast GLM fitting backend for DESeq2 |
| tximport / tximeta | Bioc 3.19 | Import transcript-level quantifications |
| DEXSeq | Bioc 3.19 | Differential exon usage |
| muscat | Bioc 3.19 | Multi-sample multi-condition single-cell DE |
| variancePartition | Bioc 3.19 | Variance partitioning across covariates |

### GSEA and Pathway Analysis
| Package | Version | Description |
|---------|---------|-------------|
| clusterProfiler | Bioc 3.19 | GO, KEGG, and custom GSEA |
| fgsea | 1.32.4 | Fast preranked GSEA |
| DOSE | 4.0.1 | Disease ontology enrichment |
| ReactomePA | Bioc 3.19 | Reactome pathway analysis |
| GSVA | Bioc 3.19 | Gene set variation analysis |
| enrichplot | Bioc 3.19 | Visualization for enrichment results |
| pathview | Bioc 3.19 | KEGG pathway visualization |
| msigdbr | 26.1.0 | MSigDB gene sets (all species) |

### Methylation Analysis
| Package | Version | Description |
|---------|---------|-------------|
| minfi | Bioc 3.19 | Illumina array methylation (450k/EPIC) |
| methylKit | Bioc 3.19 | Bisulfite sequencing differential methylation |
| BSseq | Bioc 3.19 | Whole-genome bisulfite sequencing |
| DMRcate | Bioc 3.19 | Differentially methylated region detection |
| sesame | Bioc 3.19 | SeSAMe pipeline for Illumina arrays |
| ENmix | Bioc 3.19 | Array quality control and normalization |
| missMethyl | Bioc 3.19 | Methylation-aware GO/KEGG testing |

### ATAC-seq and Chromatin
| Package | Version | Description |
|---------|---------|-------------|
| Signac | Bioc 3.19 | Single-cell ATAC-seq analysis |
| chromVAR | Bioc 3.19 | TF motif accessibility |
| motifmatchr | Bioc 3.19 | TF motif scanning |
| TFBSTools / JASPAR2020 | Bioc 3.19 | JASPAR transcription factor motifs |
| DiffBind | Bioc 3.19 | Differential binding for ChIP/ATAC |
| ChIPseeker | Bioc 3.19 | Peak annotation and visualization |

### Visualization
| Package | Version | Description |
|---------|---------|-------------|
| ComplexHeatmap | Bioc 3.19 | Publication-quality heatmaps |
| EnhancedVolcano | Bioc 3.19 | Volcano plots |
| dittoSeq | Bioc 3.19 | Colorblind-friendly single-cell plots |
| Nebulosa | Bioc 3.19 | Kernel density estimation on embeddings |
| ggplot2 | 4.0.3 | Core plotting |
| patchwork | 1.3.2 | Combining plots |
| cowplot | 1.2.0 | Plot utilities |
| ggrepel | 0.9.8 | Repelled labels |
| ggridges | 0.5.7 | Ridge plots |

### Annotation Databases
| Package | Version | Description |
|---------|---------|-------------|
| org.Hs.eg.db | Bioc 3.19 | Human gene annotation |
| org.Mm.eg.db | Bioc 3.19 | Mouse gene annotation |
| org.Rn.eg.db | 3.20.0 | Rat gene annotation |
| GO.db | 3.20.0 | Gene Ontology |
| TxDb.Hsapiens.UCSC.hg38.knownGene | Bioc 3.19 | Human hg38 transcript database |
| TxDb.Mmusculus.UCSC.mm10.knownGene | Bioc 3.19 | Mouse mm10 transcript database |
| biomaRt | Bioc 3.19 | Ensembl database queries |
| AnnotationHub / ExperimentHub | Bioc 3.19 | Bioconductor annotation resources |

### Infrastructure
| Package | Version | Description |
|---------|---------|-------------|
| tidyverse | CRAN | Data manipulation and plotting |
| data.table | 1.13.6 | Fast data operations |
| future / future.apply | 1.70.0 | Parallelization |
| Matrix | 1.7.0 | Sparse matrix operations |
| BiocManager | 1.30.27 | Bioconductor package management |
| WGCNA | CRAN | Weighted gene co-expression networks |

> **Note:** "Bioc 3.19" indicates the package version is pinned to the Bioconductor 3.19 release (May 2024). Exact patch versions for all packages will be added to the [releases page](https://github.com/armilner/r-bioinformatics-2026/releases) once the container build completes.

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
