# **ORSON: workflow for prOteome and tRanScriptome functiOnal aNnotation**.

[![ORSON version](https://img.shields.io/badge/ORSON%20version-beta-red?labelColor=000000)](https://gitlab.ifremer.fr/bioinfo/orson)
[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A520.10.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![Run with with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![SeBiMER Docker](https://img.shields.io/badge/docker%20build-SeBiMER-yellow?labelColor=000000)](https://hub.docker.com/u/sebimer)

## Introduction

The ORSON pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It comes with docker containers making installation trivial and results highly reproducible.

## Quick Start

i. Install [`nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation)

ii. Install [`Singularity`](https://www.sylabs.io/guides/3.0/user-guide/) for full pipeline reproducibility

iii. Download the pipeline and test it on a minimal dataset with a single command

```bash
nextflow run main.nf -profile test,singularity
```

> To use this workflow on a computing cluster, it is necessary to provide a configuration file for your system. For some institutes, this one already exists and is referenced on [nf-core/configs](https://github.com/nf-core/configs#documentation). If so, you can simply download your institute custom config file and simply use `-c <institute_config_file>` in your command. This will enable either `docker` or `singularity` and set the appropriate execution settings for your local compute environment.

iv. Start running your own analysis!

```bash
nextflow run main.nf -profile custom,singularity [-c <institute_config_file>]
```

See [usage docs](docs/usage.md) for a complete description of all of the options available when running the pipeline.

## Documentation

This workflow comes with documentation about the pipeline, found in the `docs/` directory:

1. [Introduction](docs/usage.md#introduction)
2. [Pipeline installation](docs/usage.md#install-the-pipeline)
    * [Local installation](docs/usage.md#local-installation)
    * [Adding your own system config](docs/usage.md#your-own-config)
3. [Running the pipeline](docs/usage.md#running-the-pipeline)
4. [Output and how to interpret the results](docs/output.md)
5. [Troubleshooting](docs/troubleshooting.md)

Here is an overview of the many steps available in samba pipeline:

![ORSON](docs/images/ORSON_workflow.png)

## Requirements

To use ORSON, all tools are automatically installed via singularity images. However, you must have local access to the databases required for the activated steps:

- For BUSCO, please refer to the tool's documentation to [download the lineage databases](https://busco.ezlab.org/busco_userguide.html#download-and-automated-update)
- For eggNOG mapper, you need to download the databases according to the [documentation](https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2.1.0#setup). Don't forget to define the `params.eggnog_data_dir` to define the path to your databases. In the future, the databases will be automatically downloaded by the workflow (be careful, you need nodes with internet access and this may take time depending on your connection) 
- In the query annotation process, a protein database is required. This database must be formatted according to the tool used. PLAST and BLAST use [BLAST formatted databank](https://www.ncbi.nlm.nih.gov/books/NBK279688/). Diamond uses its own format for database, instructions can be found in the [diamond wiki](https://github.com/bbuchfink/diamond/wiki). Note that the automated installation and formatting of annotated banks can be performed by the workflow. See the [Installing annotated sequence banks](/docs/usage.md#installing-annotated-sequence-banks) section of the usage documentation.

  
## Credits

ORSON is written by [SeBiMER](https://ifremer-bioinformatics.github.io/), the Bioinformatics Core Facility of [IFREMER](https://wwz.ifremer.fr/en/).

## Contributions

We welcome contributions to the pipeline. If such case you can do one of the following:
* Use issues to submit your questions 
* Fork the project, do your developments and submit a pull request
* Contact us (see email below) 

## Support

For further information or help, don't hesitate to get in touch with the samba developpers: 

![sebimer email](assets/sebimer-email.png)

## Citation

<!-- If you use this workflow for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

### References 

