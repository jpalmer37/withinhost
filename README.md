# Within-host HIV indel analysis

> **Archived research repository.** This repository preserves partial analysis code from graduate research and is no longer maintained. It is retained for historical and methodological context, not as a supported workflow or a current portfolio project.

## Research Context

The project investigated insertion and deletion mutations in HIV-1 gp120 within hosts. The broader analysis processed roughly 25,000 genetic sequences, reconstructed evolutionary histories with phylogenetic and Bayesian methods, and modelled indel rates with hierarchical Stan models.

## Repository Scope

This is not a complete reproducible package. It contains selected Python, R, shell, BEAST, and Stan scripts plus final figures retained from the original research period. Input data, complete environments, execution metadata, and some intermediate steps are not included.

```text
sequence preparation
      │
      ▼
alignment and screening
      │
      ▼
phylogenetic reconstruction
      │
      ▼
ancestral-state / indel inference
      │
      ▼
hierarchical rate models and figures
```

## Ownership and Attribution

John Palmer authored these scripts as part of his master's research. The surrounding scientific study, supervision, data generation, and interpretation involved a broader academic context that is not fully represented by this code snapshot. Third-party methods and tools retain their own authorship and licenses.

## Preservation Changes

- Removed draft plots and compiled Python cache files from the current tree.
- Retained final figures and source scripts that help explain the historical analysis.
- Added this archival description so readers do not mistake partial research code for maintained production software.

## Limitations

- Original machine-specific paths in the current scripts have been replaced with explicit `/path/to/...` placeholders; operators would still need to reconstruct the missing environment.
- Dependency versions and input datasets are not available.
- The code has not been rerun or validated against current toolchains.
- No license is granted by this repository; contact the relevant rights holders before reuse.
