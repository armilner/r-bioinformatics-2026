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
| harmony | 2.0.4 | Integration across batches and datasets |
| sctransform | 0.4.3 | Regularized NB normalization |
| scran | 1.32.0 | Bioconductor single-cell normalization |
| scater | 1.32.1 | Bioconductor single-cell utilities |
| scuttle | 1.14.0 | Bioconductor single-cell utilities |
| scDblFinder | 1.18.0 | Doublet detection |
| speckle | 1.4.0 | Differential cell type abundance |
| monocle3 | 1.4.27 | Trajectory and pseudotime analysis |

### Bulk RNA-seq and Differential Expression
| Package | Version | Description |
|---------|---------|-------------|
| DESeq2 | 1.44.0 | Negative binomial DE (pseudobulk and bulk) |
| edgeR | 4.2.2 | Quasi-likelihood DE |
| limma | 3.60.6 | Linear models for microarray/RNA-seq |
| tximport | 1.32.0 | Import transcript-level quantifications |
| tximeta | 1.22.1 | Import transcript-level quantifications with metadata |
| DEXSeq | 1.50.0 | Differential exon usage |
| muscat | 1.18.0 | Multi-sample multi-condition single-cell DE |
| variancePartition | 1.34.0 | Variance partitioning across covariates |

### GSEA and Pathway Analysis
| Package | Version | Description |
|---------|---------|-------------|
| clusterProfiler | 4.12.6 | GO, KEGG, and custom GSEA |
| fgsea | 1.30.0 | Fast preranked GSEA |
| DOSE | 3.30.5 | Disease ontology enrichment |
| ReactomePA | 1.48.0 | Reactome pathway analysis |
| enrichplot | 1.24.4 | Visualization for enrichment results |
| pathview | 1.44.0 | KEGG pathway visualization |
| msigdbr | 26.1.0 | MSigDB gene sets (all species) |

### Methylation Analysis
| Package | Version | Description |
|---------|---------|-------------|
| minfi | 1.50.0 | Illumina array methylation (450k/EPIC) |
| DMRcate | 3.0.10 | Differentially methylated region detection |
| sesame | 1.22.2 | SeSAMe pipeline for Illumina arrays |
| ENmix | 1.40.2 | Array quality control and normalization |
| missMethyl | 1.38.0 | Methylation-aware GO/KEGG testing |

### ATAC-seq and Chromatin
| Package | Version | Description |
|---------|---------|-------------|
| Signac | 1.14.0 | Single-cell ATAC-seq analysis |
| TFBSTools | 1.42.0 | Transcription factor binding site analysis |
| JASPAR2020 | 0.99.10 | JASPAR transcription factor motifs |
| DiffBind | 3.14.0 | Differential binding for ChIP/ATAC |
| ChIPseeker | 1.40.0 | Peak annotation and visualization |

### Visualization
| Package | Version | Description |
|---------|---------|-------------|
| ComplexHeatmap | 2.20.0 | Publication-quality heatmaps |
| EnhancedVolcano | 1.22.0 | Volcano plots |
| dittoSeq | 1.16.0 | Colorblind-friendly single-cell plots |
| Nebulosa | 1.14.0 | Kernel density estimation on embeddings |
| ggplot2 | 4.0.3 | Core plotting |
| patchwork | 1.3.2 | Combining plots |
| cowplot | 1.2.0 | Plot utilities |
| ggrepel | 0.9.8 | Repelled labels |
| ggridges | 0.5.7 | Ridge plots |

### Annotation Databases
| Package | Version | Description |
|---------|---------|-------------|
| org.Hs.eg.db | 3.19.1 | Human gene annotation |
| org.Mm.eg.db | 3.19.1 | Mouse gene annotation |
| org.Rn.eg.db | 3.19.1 | Rat gene annotation |
| GO.db | 3.19.1 | Gene Ontology |
| TxDb.Hsapiens.UCSC.hg38.knownGene | 3.18.0 | Human hg38 transcript database |
| TxDb.Mmusculus.UCSC.mm10.knownGene | 3.10.0 | Mouse mm10 transcript database |
| biomaRt | 2.60.1 | Ensembl database queries |
| AnnotationHub | 3.12.0 | Bioconductor annotation resources |
| ExperimentHub | 2.12.0 | Bioconductor experiment data resources |

### Infrastructure
| Package | Version | Description |
|---------|---------|-------------|
| tidyverse | 2.0.0 | Data manipulation and plotting |
| data.table | 1.18.4 | Fast data operations |
| future | 1.70.0 | Parallelization |
| future.apply | 1.20.2 | Parallelization helpers |
| Matrix | 1.7-5 | Sparse matrix operations |
| BiocManager | 1.30.27 | Bioconductor package management |

---

## Build Details

- **Base image:** rocker/r-ver:4.4.1 (Ubuntu 22.04 Jammy)
- **R version:** 4.4.1
- **Bioconductor:** 3.19
- **CRAN binaries:** Posit Package Manager (Ubuntu Jammy)
- **Built:** June 2026

Container images are built automatically via GitHub Actions and pushed to the GitHub Container Registry on every commit to `main`.

---

## Citation

If you use this container in your work, please cite it. GitHub will display a **"Cite this repository"** button on the repo page (top right of the About panel) with auto-formatted citations in APA, BibTeX, and other styles.

```
Milner, A. (2026). r-bioinformatics-2026 (v1.0.0). GitHub.
https://github.com/armilner/r-bioinformatics-2026
```

---

## License

MIT License — free to use, modify, and distribute with attribution.
