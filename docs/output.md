# ORSON: Output

This document describes the output produced by the workflow.

## Intermediate results

During the workflow, intermediate files are generated and correspond in particular:
- to the BUSCO analysis
- to the PLAST, BLAST or diamond annotation XML files for each chunk of your transcriptome or proteome
- the InterProScan analysis XML files of each chunk 

You can find these files in **`results/[projectName]/02_intermediate_data`**.

## Final results

ORSON guides you and simplifies the post-workflow analysis (annotation visualisation) in particular by merging all the XML files and giving you access via the BeeDeeM annotation to a complete annotation output.

All of these files are available in **`results/[projectName]/03_final_results`**.

For further analysis, we recommend that you download the most recent [BlastViewer-x.y.z.jar file](https://github.com/pgdurand/BlastViewer/releases) which will allow you to view all the annotation results via a graphical interface.

### How to do ?

i. Collect locally on your computer, all the files available from the **`results/[projectName]/03_final_results`** folder using Filezilla for example.
 
ii. Download [BlastViewer](https://github.com/pgdurand/BlastViewer/releases) by getting the most recent BlastViewer-x.y.z.jar file from the following page:

```bash
https://github.com/pgdurand/BlastViewer/releases
```

iii. If you have activated the BeeDeeM annotation process, you can open the ZML file in BlastViewer. And then import the XML file from the InterProScan analysis.

or if the BeeDeeM annotation has not been activated, the procedure remains the same except that you must open in BlastViewer the XML file resulting from the annotation you have chosen (PLAST, BLAST or diamond) then import the XML file resulting from of the InterProScan analysis.

Please, refer to [this documentation](https://github.com/pgdurand/BlastViewer/wiki/InterProScan-data-import) for further information on how to import BLAST results along with InterProScan predictions.
