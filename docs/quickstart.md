# ORSON: Quickstart guide

## Input file requirements

### FASTA file

The FASTA file contains all the sequences to annotate. Sequences can be nucleic acids or proteins.

This file will be chunked according to the size specified by the user.

## Process parameters

The `custom.config` file control each process and it's parameters, **so it's very important to fulfill this file very carefully**. Otherwise, it's can lead to computational errors or misinterpretation of biological results.

In this section, we will describe the most important parameters for each process.

```projectName```: the name of your project, **without space, tabulation or accented characters**.

```outdir```: the path to save your results.

```fasta```: the full path to your FASTA file. 

```query_type```: the type of your data ; "n" (nucleic acids) or "p" (proteins).

```chunk_size```: number of sequences in each fasta chunk.

```hit_tool```: tool used for the sequence comparison ; "PLAST", "BLAST" or "diamond".

```annot_type```: type of annotation perform made by BeeDeeM ; "bco" or "full".
