FROM rocker/r-ver:4.4.1

LABEL maintainer="Andrew Milner <andrewmilner12@gmail.com>"
LABEL description="Comprehensive R bioinformatics container — single-cell, bulk RNA-seq, methylation, ATAC-seq, and pathway analysis (2026)"
LABEL org.opencontainers.image.source="https://github.com/armilner/r-bioinformatics-2026"

# Posit Package Manager provides pre-compiled Linux binaries for CRAN packages,
# dramatically reducing build time vs compiling from source.
ENV CRAN=https://packagemanager.posit.co/cran/__linux__/jammy/latest
ENV BIOCONDUCTOR_VERSION=3.19

# ── System dependencies ───────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    # HDF5 (single-cell data formats)
    libhdf5-dev \
    # XML / web (AnnotationDbi, biomaRt, httr)
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    # Math libraries
    libgsl-dev \
    libfftw3-dev \
    libglpk-dev \
    # Graphics
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    # Compression
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    # Spatial (required by terra/sf for monocle3)
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    # Build tools
    cmake \
    git \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# ── Package manager setup ─────────────────────────────────────────────────────
RUN R -e "install.packages(c('BiocManager', 'remotes'), repos = Sys.getenv('CRAN'))" && \
    R -e "BiocManager::install(version = Sys.getenv('BIOCONDUCTOR_VERSION'), ask = FALSE)"

# ── Core CRAN: data, parallelism, visualization ───────────────────────────────
RUN R -e "install.packages(c( \
    'tidyverse', 'data.table', 'Matrix', \
    'future', 'future.apply', 'parallelly', \
    'Rcpp', 'RcppArmadillo', 'RcppEigen', \
    'scales', 'viridis', 'RColorBrewer', \
    'ggrepel', 'patchwork', 'cowplot', \
    'pheatmap', 'ggridges', 'gridExtra', 'ggpubr', \
    'msigdbr', 'WGCNA' \
), repos = Sys.getenv('CRAN'))"

# ── Bioconductor core infrastructure ─────────────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'BiocGenerics', 'S4Vectors', 'IRanges', \
    'GenomicRanges', 'GenomicFeatures', \
    'SummarizedExperiment', 'SingleCellExperiment', \
    'Biobase', 'BiocParallel', \
    'AnnotationDbi', 'biomaRt', \
    'rtracklayer', 'Rsamtools', 'GenomicAlignments', \
    'AnnotationHub', 'ExperimentHub' \
), ask = FALSE, update = FALSE)"

# ── Annotation databases (human, mouse, rat) ──────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'org.Hs.eg.db', 'org.Mm.eg.db', 'org.Rn.eg.db', 'GO.db', \
    'TxDb.Hsapiens.UCSC.hg38.knownGene', \
    'TxDb.Mmusculus.UCSC.mm10.knownGene' \
), ask = FALSE, update = FALSE)"

# ── Bulk RNA-seq and differential expression ──────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'DESeq2', 'edgeR', 'limma', 'glmGamPoi', \
    'tximport', 'tximeta', \
    'DEXSeq', 'muscat', \
    'variancePartition' \
), ask = FALSE, update = FALSE)"

# ── GSEA and pathway analysis ─────────────────────────────────────────────────
# ggtree must precede enrichplot/clusterProfiler — enrichplot depends on it
RUN R -e "BiocManager::install('ggtree', ask = FALSE, update = FALSE)"
RUN R -e "BiocManager::install(c( \
    'clusterProfiler', 'DOSE', 'enrichplot', \
    'fgsea', 'ReactomePA', 'pathview', \
    'GSEABase', 'GSVA', 'qvalue', \
    'multtest' \
), ask = FALSE, update = FALSE)"

# metap (p-value combination; required by Seurat FindConservedMarkers)
# Depends on qqconf which needs libgsl-dev + libfftw3-dev (already installed above)
RUN R -e "install.packages('metap', repos = Sys.getenv('CRAN'))"

# ── Single-cell RNA-seq ───────────────────────────────────────────────────────
RUN R -e "install.packages(c('Seurat', 'harmony', 'sctransform'), \
    repos = Sys.getenv('CRAN'))"
RUN R -e "BiocManager::install(c( \
    'scran', 'scater', 'scuttle', \
    'scDblFinder', 'bluster', 'batchelor', \
    'speckle' \
), ask = FALSE, update = FALSE)"

# ── ATAC-seq and chromatin accessibility ──────────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'Signac', 'chromVAR', 'motifmatchr', \
    'TFBSTools', 'JASPAR2020', \
    'DiffBind', 'ChIPseeker' \
), ask = FALSE, update = FALSE)"

# ── Methylation analysis ──────────────────────────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'minfi', 'methylKit', 'BSseq', \
    'DMRcate', 'sesame', 'ENmix', 'missMethyl' \
), ask = FALSE, update = FALSE)"

# ── Visualization ─────────────────────────────────────────────────────────────
RUN R -e "BiocManager::install(c( \
    'ComplexHeatmap', 'EnhancedVolcano', \
    'dittoSeq', 'Nebulosa' \
), ask = FALSE, update = FALSE)"

# ── Trajectory analysis — monocle3 (GitHub only) ─────────────────────────────
RUN R -e "install.packages(c('terra', 'sf', 'leidenbase'), \
    repos = Sys.getenv('CRAN'))" && \
    R -e "remotes::install_github('cole-trapnell-lab/monocle3', upgrade = 'never')"

# ── Print installed versions to stdout at build time ─────────────────────────
RUN R -e " \
pkgs <- c('Seurat','DESeq2','edgeR','limma','clusterProfiler', \
          'minfi','methylKit','BSseq','DMRcate','sesame', \
          'Signac','monocle3','muscat','speckle','GSVA', \
          'ComplexHeatmap','EnhancedVolcano','harmony','sctransform'); \
for (p in pkgs) { \
  v <- tryCatch(as.character(packageVersion(p)), error = function(e) 'MISSING'); \
  cat(sprintf('%-25s %s\n', p, v)) \
}"
