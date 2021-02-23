#!/usr/bin/env nextflow
/*
========================================================================================
                                    ORSON workflow                                     
========================================================================================
 Workflow for prOteome and tRanScriptome functiOnal aNnotation.
 #### Homepage / Documentation
 https://github.com/ifremer-bioinformatics/xxx
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl=2

def helpMessage() {
    // Add to this help message with new command line parameters
    log.info SeBiMERHeader()
    log.info"""

    Usage:

    The typical command for running the pipeline after filling the conf/custom.config file is as follows:

	nextflow run main.nf -profile custom,singularity

	Mandatory arguments:
        --fasta [file]			Path to the fasta file to annotate.
	-profile [str]			Configuration profile to use. Can use multiple (comma separated). Available: test, custom, singularity.

	Generic:
	--query_type [str]		Type of input data. Can be "n" (nucleic acid sequences) or "p" (protein sequences).
	--hit_tool [str]		Tool used for the sequence comparison. Can be "PLAST", "BLAST" or "diamond".
	--chunk_size [str]			Number of sequences in each FASTA chunks.

	Other options:
	--outdir [path]			The output directory where the results will be saved.
	-w/--workdir [path]		The temporary directory where intermediate data will be saved.
	-name [str]			Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.
	--projectName [str]		Name of the project.

	PLAST search:
	--plast_db [path]		Path to a PLAST formatted database.

	BLAST search:
	--blast_db [path]		Path to a BLAST formatted database.

	diamond search:
	--diamond_db [path]		Path to a diamond formatted database.

	InterProScan analysis:
	--iprscan_enable [bool]		Active InterProScan analysis (default = true).

	BeeDeeM annotation:
	--beedeem_annot_enable [bool]	Active BeeDeeM annotation (default = true).
	--annot_type [str]		Type of BeeDeeM annoation. Can be "bco" or "full".

	""".stripIndent()
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

/*
 * SET UP CONFIGURATION VARIABLES
 */

// Has the run name been specified by the user?
//  this has the bonus effect of catching both -name and --name
custom_runName = params.name
if (!(workflow.runName ==~ /[a-z]+_[a-z]+/)) {
    custom_runName = workflow.runName
}

//Copy config files to output directory for each run
paramsfile = file("$baseDir/conf/base.config", checkIfExists: true)
paramsfile.copyTo("$params.outdir/00_pipeline_conf/base.config")

if (workflow.profile.contains('test')) {
   testparamsfile = file("$baseDir/conf/test.config", checkIfExists: true)
   testparamsfile.copyTo("$params.outdir/00_pipeline_conf/test.config")
}
if (workflow.profile.contains('custom')) {
   customparamsfile = file("$baseDir/conf/custom.config", checkIfExists: true)
   customparamsfile.copyTo("$params.outdir/00_pipeline_conf/custom.config")
}

/*
 * PIPELINE INFO
 */

// Header log info
log.info SeBiMERHeader()
def summary = [:]
if (workflow.revision) summary['Pipeline Release'] = workflow.revision
summary['Run Name'] = custom_runName ?: workflow.runName
summary['Project Name'] = params.projectName
summary['Output dir'] = params.outdir
summary['Launch dir'] = workflow.launchDir
summary['Working dir'] = workflow.workDir
summary['Script dir'] = workflow.projectDir
summary['User'] = workflow.userName
summary['Profile'] = workflow.profile
summary['FASTA File'] = params.fasta
if (params.query_type == "n") {
    summary['Data Type'] = "Nucleotide"
} else {
    summary['Data Type'] = "Protein"
}
summary['Tool used'] = params.hit_tool
if (params.iprscan_enable) {
    summary['IPRScan'] = "InterProScan analysis activated"
} else {
    summary['IPRScan'] = "InterProScan analysis disabled"
}
if (params.beedeem_annot_enable) {
    summary['BeeDeeM annotation'] = "BeeDeeM annotation activated"
} else {
    summary['BeeDeeM annotation'] = "BeeDeeM annotation disabled"
}
summary['Annotation type'] = params.annot_type

log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[91m--------------------------------------------------\033[0m-"

// Check the hostnames against configured profiles
checkHostname()

/*
 * SET UP WORKFLOW VARIABLES
 */

if (workflow.profile.contains('custom')) {
  channel
    .fromPath( params.fasta )
    .ifEmpty { error "Cannot find any fasta file matching: ${params.fasta}" }
    .splitFasta( by: params.chunk_size, file: true)
    .set { fasta_files }
}

include { get_test_data } from './modules/get_test_data.nf'
include { plast } from './modules/plast.nf'
include { blast } from './modules/blast.nf'
include { diamond } from './modules/diamond.nf'
include { interpro } from './modules/interpro.nf'
include { beedeem_annotation } from './modules/beedeem_annotation.nf'

/*
 * RUN MAIN WORKFLOW
 */

workflow {
    if (workflow.profile.contains('test')) {
        get_test_data()
        ready = get_test_data.out.test_ready
        fasta_files = get_test_data.out.query.splitFasta( by: params.chunk_size, file: true)
    } else {
        ready = Channel.value("none")
    }
    if (params.hit_tool == 'PLAST') {
        plast(ready,fasta_files)
        ch_xml = plast.out.hit_files
    }
    if (params.hit_tool == 'BLAST') {
        blast(ready,fasta_files)
        ch_xml = blast.out.hit_files
    }
    if (params.hit_tool == 'diamond') {
        diamond(ready,fasta_files)
        ch_xml = diamond.out.hit_files
    }
    if (params.iprscan_enable) {
        interpro(ready,fasta_files)
    }
    if (params.beedeem_annot_enable) {
        beedeem_annotation(ch_xml)
    }
}

/*
 * Completion notification
 */

workflow.onComplete {
    c_green = params.monochrome_logs ? '' : "\033[0;32m";
    c_purple = params.monochrome_logs ? '' : "\033[0;35m";
    c_red = params.monochrome_logs ? '' : "\033[0;31m";
    c_reset = params.monochrome_logs ? '' : "\033[0m";

    if (workflow.success) {
        log.info "-${c_purple}[Annotation workflow]${c_green} Pipeline completed successfully${c_reset}-"
    } else {
        checkHostname()
        log.info "-${c_purple}[Annotation workflow]${c_red} Pipeline completed with errors${c_reset}-"
    }
}

/*
 * Other functions
 */

def SeBiMERHeader() {
    // Log colors ANSI codes
    c_red = params.monochrome_logs ? '' : "\033[0;91m";
    c_blue = params.monochrome_logs ? '' : "\033[1;94m";
    c_reset = params.monochrome_logs ? '' : "\033[0m";
    c_yellow = params.monochrome_logs ? '' : "\033[1;93m";
    c_Ipurple = params.monochrome_logs ? '' : "\033[0;95m" ;

    return """    -${c_red}--------------------------------------------------${c_reset}-
    ${c_blue}    __  __  __  .       __  __  ${c_reset}
    ${c_blue}   \\   |_  |__) | |\\/| |_  |__)  ${c_reset}
    ${c_blue}  __\\  |__ |__) | |  | |__ |  \\  ${c_reset}
                                            ${c_reset}
    ${c_yellow}  ORSON workflow (version ${workflow.manifest.version})${c_reset}
                                            ${c_reset}
    ${c_Ipurple}  Homepage: ${workflow.manifest.homePage}${c_reset}
    -${c_red}--------------------------------------------------${c_reset}-
    """.stripIndent()
}

def checkHostname() {
    def c_reset = params.monochrome_logs ? '' : "\033[0m"
    def c_white = params.monochrome_logs ? '' : "\033[0;37m"
    def c_red = params.monochrome_logs ? '' : "\033[1;91m"
    def c_yellow_bold = params.monochrome_logs ? '' : "\033[1;93m"
    if (params.hostnames) {
        def hostname = "hostname".execute().text.trim()
        params.hostnames.each { prof, hnames ->
            hnames.each { hname ->
                if (hostname.contains(hname) && !workflow.profile.contains(prof)) {
                    log.error "====================================================\n" +
                            "  ${c_red}WARNING!${c_reset} You are running with `-profile $workflow.profile`\n" +
                            "  but your machine hostname is ${c_white}'$hostname'${c_reset}\n" +
                            "  ${c_yellow_bold}It's highly recommended that you use `-profile $prof${c_reset}`\n" +
                            "============================================================"
                }
            }
        }
    }
}
