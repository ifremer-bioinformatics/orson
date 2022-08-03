# ORSON: Usage

## Table of contents
* [Introduction](#introduction)
* [Install the pipeline](#install-the-pipeline)
  * [Local installation](#local-installation)
  * [Adding your own system config](#your-own-config)
* [Running the pipeline](#running-the-pipeline)
  * [Updating the pipeline](#updating-the-pipeline)
  * [Reproducibility](#reproducibility)
* [Main arguments](#main-arguments)
* [Mandatory arguments](#mandatory-arguments)
  * [`--fasta`](#--fasta)
  * [`-profile`](#-profile)
* [Generic arguments](#generic-arguments)
  * [`--query_type`](#--query_type)
  * [`--hit_tool`](#--hit_tool)
  * [`--chunk_size`](#--chunk_size)
  * [`--projectName`](#--projectName)
* [Installing annotated sequence banks](#installing-annotated-sequence-banks)
  * [`--downloadDB_enable`](#--downloadDB_enable)
  * [`--db_dir`](#--db_dir)
  * [`--bank_list`](#--bank_list)
* [BUSCO analysis](#busco-analysis)
  * [`--busco_enable`](#--busco_enable)
  * [`--lineage`](#--lineage)
* [PLAST search](#plast-search)
  * [`--plast_db`](#--plast_db)
* [BLAST or diamond search](#blast_diamond_search)
  * [`--restricted_search`](#--restricted_search)
  * [`--restricted_tax_id`](#--restricted_tax_id)
  * [`--blast_db`](#--blast_db)
* [InterProScan analysis](#interproscan-analysis)
  * [`--iprscan_enable`](#--iprscan_enable)
* [eggNOG mapper annotation](#eggnogmapper-annotation)
  * [`--eggnogmapper_enable`](#--eggnogmapper_enable)
* [BeeDeeM annotation](#beedeem-annotation)
  * [`--beedeem_annot_enable`](#--beedeem_annot_enable)
  * [`--annot_type`](#--annot_type)
* [Job resources](#job-resources)
* [Other command line parameters](#other-command-line-parameters)
  * [`--outdir`](#--outdir)
  * [`--email`](#--email)
  * [`--email_on_fail`](#--email_on_fail)
  * [`-name`](#-name)
  * [`-resume`](#-resume)
  * [`-c`](#-c)
  * [`--max_memory`](#--max_memory)
  * [`--max_time`](#--max_time)
  * [`--max_cpus`](#--max_cpus)
  * [`--plaintext_email`](#--plaintext_email)
  * [`--monochrome_logs`](#--monochrome_logs)

## Introduction

Nextflow handles job submissions on SLURM or other environments, and supervises running the jobs. Thus the Nextflow process must run until the pipeline is finished. We recommend that you put the process running in the background through `screen` / `tmux` or similar tool. Alternatively you can run nextflow within a cluster job submitted your job scheduler.

It is recommended to limit the Nextflow Java virtual machines memory. We recommend adding the following line to your environment (typically in `~/.bashrc` or `~./bash_profile`):

```bash
NXF_OPTS='-Xms1g -Xmx4g'
```

## Install the pipeline

### Local installation

Make sure that on your system either install [Nextflow](https://www.nextflow.io/) as well as [Docker](https://docs.docker.com/engine/installation/) or [Singularity](https://www.sylabs.io/guides/3.0/user-guide/) allowing full reproducibility

How to install orson:

```bash
git clone https://gitlab.ifremer.fr/bioinfo/orson
```

### Adding your own system config

To use this workflow on a computing cluster, it is necessary to provide a configuration file for your system. For some institutes, this one already exists and is referenced on [nf-core/configs](https://github.com/nf-core/configs#documentation). If so, you can simply download your institute custom config file and simply use `-c <institute_config_file>` in the launch command.

If your institute does not have a referenced config file, you can create it using files from [other infrastructure](https://github.com/nf-core/configs/tree/master/docs)


## Running the pipeline

The most simple command for running the pipeline is as follows:

```bash
nextflow run main.nf -profile test,singularity
```

This will launch the pipeline with the `test` configuration profile using `singularity`. See below for more information about profiles.

Note that the pipeline will create the following files in your working directory:

```bash
work            # Directory containing the nextflow working files
results         # Finished results (configurable, see below)
.nextflow_log   # Log file from Nextflow
# Other nextflow hidden files, eg. history of pipeline runs and old logs.
```

### Updating the pipeline

When you run the above command, Nextflow automatically runs the pipeline code from your git clone - even if the pipeline has been updated since. To make sure that you're running the latest version of the pipeline, make sure that you regularly update the version of the pipeline:

```bash
cd orson
git pull
```

### Reproducibility

It's a good idea to specify a pipeline version when running the pipeline on your data. This ensures that a specific version of the pipeline code and software are used when you run your pipeline. If you keep using the same tag, you'll be running the same version of the pipeline, even if there have been changes to the code since.

First, go to the [ORSON releases page](https://gitlab.ifremer.fr/bioinfo/orson/-/releases) and find the latest version number (eg. `v1.0.0`). Then, you can configure your local orson installation to use your desired version as follows:

```bash
cd orson
git checkout v1.0.0
```

## Mandatory arguments

### `-profile`

Use this parameter to choose a configuration profile. Profiles can give configuration presets for different compute environments. Note that multiple profiles can be loaded, for example: `-profile test,singularity`.

If `-profile` is not specified at all the pipeline will be run locally and expects all software to be installed and available on the `PATH`.

* `singularity`
  * A generic configuration profile to be used with [Singularity](http://singularity.lbl.gov/)
  * Pulls software from DockerHub: [`ORSON`](https://hub.docker.com/u/sebimer)

Profiles are also available to configure the workflow and can be combined with execution profiles listed above.

* `test`
  * A profile with a complete configuration for automated testing of annotation workflow
  * Includes test dataset so needs no other parameters
* `custom`
  * A profile to complete according to your dataset and experiment

### `--fasta`

Path to input FASTA file to annotate. 

Please note that the input data must not be in compressed format.

## Generic arguments

### `--query_type`

Set to "n" for nucleic acid sequences input or to "p" for protein sequences.

### `--hit_tool`

Indicates the tool of your choice for the comparison of your sequences to the reference database. Can be "PLAST", "BLAST" or "diamond".

### `--chunk_size`

Size of the  FASTA file chunks.

## Installing annotated sequence banks

### `--downloadDB_enable`

Set to true or false to active or disable automated installation of banks. (default = true)

### `--db_dir`

Path to annotated sequence banks.

### `--bank_list`

List of banks to install. 
Accepted values are: Uniprot_SwissProt, Refseq_protein, Uniprot_TrEMBL. 
This list can be completed with: NCBI_Taxonomy, Enzyme.
Multiple bank names can be set with comma separator.

## BUSCO analysis

Before annotation processes, if your input file is a transcriptome, ORSON can perform a completness analysis of your transcriptome using [BUSCO](https://busco.ezlab.org/busco_userguide.html).

### `--busco_enable`

Set to true or false to enable or disable the BUSCO completness analysis of your transcriptome (default = false).

### `--lineage`

Path to the [busco lineage](https://busco.ezlab.org/list_of_lineages.html) matching your transcriptome. Multiple lineages can be set with comma separator.

## PLAST search

If you set `--hit_tool` with "PLAST", sequence comparison will be done using [PLAST](https://doi.org/10.1186/1471-2105-10-329).

### `--plast_db`

Set the path to the PLAST formatted database of your choice. The reference database must contain protein sequences. (default = UniProt SwissProt)

## BLAST or diamond search

If you set `--hit_tool` with "BLAST" or "diamond", sequence comparison will be done using [BLAST](https://doi.org/10.1016/S0022-2836(05)80360-2) or [diamond](https://github.com/bbuchfink/diamond).

### `--restricted_search`

Active BLAST search against a taxonomic restricted nr database. Active only with nr BLAST search (default = false).

### `--restricted_tax_id`

NCBI Taxonomy ID to restrict nr database for restricted BLAST search

### `--blast_db` 

Set the path to the BLAST formatted database of your choice. The reference database must contain protein sequences. (default = UniProt SwissProt)

## InterProScan analysis 

This process is optional and use [InterProScan](https://doi.org/10.1093/bioinformatics/17.9.847) to provides functional analysis of proteins by classifying them into families and predicting domains and important sites.

### `--iprscan_enable`

Set to true or false to active or disable InterProScan analysis. (default = true)

## eggNOG mapper annotation 

This process is optional and use [eggNOG mapper](https://doi.org/10.1093/molbev/msx148) to provides fast functional annotation of novel sequences. It uses precomputed orthologous groups and phylogenies from the [eggNOG database](http://eggnog5.embl.de) to transfer functional information from fine-grained orthologs only.

### `--eggnogmapper_enable`

Set to true or false to active or disable eggNOG mapper annotation. (default = false)

## BeeDeeM annotation 

This process is optional and use [BeeDeeM](https://github.com/pgdurand/BeeDeeM) to complete annotation to previously identified hits.

### `--beedeem_annot_enable`

Set to true or false to active or disable BeeDeeM annotation. (default = true)

### `--annot_type`

Type of annotation to introduce in results. Can be "bco" or "full". Use "bco" to only retrieve biological classifications information (e.g. IDs from Gene Ontology, Enzyme, NCBI Taxonomy, Interpro, Pfam). Use "full" to retrieve full feature tables in addition to biological classifications information. 

Look at [BeeDeeM Annotator documentation](https://pgdurand.gitbook.io/beedeem/utils/cmdline-annotate) for more information.


## Job resources

Each step in the pipeline has a default set of requirements for number of CPUs, memory and time. For most of the steps in the pipeline, if the job exits with an error code of `143` (exceeded requested resources) it will automatically resubmit with higher requests (2 x original, then 3 x original). If it still fails after three times then the pipeline is stopped.

# Other command line parameters

### `--outdir`

The output directory where the results will be published.

### `-w/--work-dir`

The temporary directory where intermediate data will be written.

### `--email`

Set this parameter to your e-mail address to get a summary e-mail with details of the run sent to you when the workflow exits.

### `--email_on_fail`

Same as --email, except only send mail if the workflow is not successful.

### `-name`

Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.

### `-resume`

Specify this when restarting a pipeline. Nextflow will used cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously.

You can also supply a run name to resume a specific run: `-resume [run-name]`. Use the `nextflow log` command to show previous run names.

**NB:** Single hyphen (core Nextflow option)

### `-c`

Specify the path to a specific config file (this is a core NextFlow command).

**NB:** Single hyphen (core Nextflow option)

Note - you can use this to override pipeline defaults.

### `--max_memory`

Use to set a top-limit for the default memory requirement for each process.
Should be a string in the format integer-unit. eg. `--max_memory '8.GB'`

### `--max_time`

Use to set a top-limit for the default time requirement for each process.
Should be a string in the format integer-unit. eg. `--max_time '2.h'`

### `--max_cpus`

Use to set a top-limit for the default CPU requirement for each process.
Should be a string in the format integer-unit. eg. `--max_cpus 1`

### `--plaintext_email`

Set to receive plain-text e-mails instead of HTML formatted.

### `--monochrome_logs`

Set to disable colourful command line output and live life in monochrome.
