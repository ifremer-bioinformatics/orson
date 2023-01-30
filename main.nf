#!/usr/bin/env nextflow
/*
========================================================================================
                                    ORSON workflow                                     
========================================================================================
 Workflow for prOteome and tRanScriptome functiOnal aNnotation.
 #### Homepage / Documentation
 https://gitlab.ifremer.fr/bioinfo/orson
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

	Installing annotated sequence banks:
        --downloadDB_enable [bool]	Active installation of annotated sequence banks (default = false).
	--db_dir [path]			Path to annotated sequence banks.
	--bank_list [str]		List of banks to install. Accepted values are: Uniprot_SwissProt, Refseq_protein, Uniprot_TrEMBL.

	BUSCO analysis:
	--busco_enable	[bool]		Active BUSCO completness analysis (default = false).
	--lineage [path]		Path to a BUSCO lineage matching your transcriptome or proteome.

	PLAST search:
	--plast_db [path]		Path to a PLAST formatted database.

	BLAST or diamond search:
	--restricted_search [bool]      Active BLAST search against a taxonomic restricted nr database. Active only with nr BLAST search (default = false).
	--restricted_tax_id [str]	NCBI Taxonomy ID to restrict nr database for restricted BLAST search 
	--blast_db [path]		Path to a BLAST formatted database.
	--sensitivity [str]     The sensitivity mode for diamond analyse only. Values accepted : ['fast','mid-sensitive','sensitive','more-sensitive','very-sensitive','ultra-sensitive'] (defalut = 'fast').

	InterProScan analysis:
	--iprscan_enable [bool]		Active InterProScan analysis (default = true).

	eggNOG mapper annotation:
	--eggnogmapper_enable [bool]	Active eggNOG mapper annotation (default = false).

	BeeDeeM annotation:
	--beedeem_annot_enable [bool]	Active BeeDeeM annotation (default = true).
	--annot_type [str]		Type of BeeDeeM annoation. Can be "bco" or "full".

    Hectar annotation:
    --hectar_enable [bool] Active Hectar annotation (default = false).
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
summary['Chunk size'] = params.chunk_size
if (params.query_type == "n") {
    summary['Data Type'] = "Nucleotide"
} else {
    summary['Data Type'] = "Protein"
}
if (params.busco_enable) {
    summary['BUSCO'] = "BUSCO activated"
    summary['BUSCO lineage'] = params.lineage
}
if (params.downloadDB_enable) {
    summary['DB download'] = "Database download activated"
    summary['DB path'] = params.db_dir
    summary['DB installed'] = params.bank_list
} else {
    summary['DB download'] = "Database already present or provided by the user"
    summary['DB path'] = params.db_dir
}
if(params.hit_tool == 'PLAST') {
    summary['Ref database'] = params.plast_db 
}
if(params.hit_tool == 'BLAST' || params.hit_tool == 'diamond') {
    summary['Ref database'] = params.blast_db
}
if (params.iprscan_enable) {
    summary['IPRScan'] = "InterProScan analysis activated"
} else {
    summary['IPRScan'] = "InterProScan analysis disabled"
}
if (params.beedeem_annot_enable) {
    summary['BeeDeeM annotation'] = "BeeDeeM annotation activated"
    summary['Annotation type'] = params.annot_type
} else {
    summary['BeeDeeM annotation'] = "BeeDeeM annotation disabled"
}
if (params.eggnogmapper_enable) {
    summary['eggNOG mapper'] = "eggNOG mapper activated"
} else {
    summary['eggNOG mapper'] = "eggNOG mapper disabled"
}

log.info summary.collect { k,v -> "${k.padRight(18)}: $v" }.join("\n")
log.info "-\033[91m--------------------------------------------------\033[0m-"

// Check the hostnames against configured profiles
checkHostname()

/*
 * VERIFY AND SET UP WORKFLOW VARIABLES
 */

if (!params.chunk_size.toString().isNumber()) {
    log.error "No valid chunk size has been provided. Please configure the 'chunk_size' parameter in the custom.config file"
    exit 1
}

def query_type_list = ['n','p']

if (!query_type_list.contains(params.query_type) || params.query_type.isEmpty()) {
    log.error "No query type or incorrect value has been entered. Please configure the 'query_type' parameter in the custom.config file to either 'n' (nucleic sequences) or 'p' (protein sequences)"
    exit 1
}

if (params.db_dir.isEmpty()) {
    log.error "No valid path for database location is provided. Please configure the 'db_dir' parameter in the custom.config file."
    exit 1
}

def hit_tool_list = ['BLAST','PLAST','diamond']

if (!hit_tool_list.contains(params.hit_tool) || params.hit_tool.isEmpty()) {
    log.error "No valid tool has been chosen for search against the reference database. Please configure the 'hit_tool' parameter in the custom.config file to either 'PLAST', 'BLAST' or 'diamond'"
    exit 1
}

if (params.hit_tool == "PLAST" && params.plast_db.isEmpty()) {
    log.error "PLAST has been chosen to hit search but no reference database has been provided. Configure it by indicating its path in the 'plast_db' parameter in the custom.config file"
    exit 1
}

if (params.hit_tool == "BLAST" && params.blast_db.isEmpty()) {
    log.error "BLAST has been chosen to hit search but no reference database has been provided. Configure it by indicating its path in the 'blast_db' parameter in the custom.config file"
    exit 1
}

if (params.hit_tool == "diamond" && params.blast_db.isEmpty()) {
    log.error "Diamond has been chosen to hit search but no reference database has been provided. Configure it by indicating its path in the 'blast_db' parameter in the custom.config file"
    exit 1
}  

def annot_type_list = ['bco','full']

if (params.beedeem_annot_enable) {
  if (!annot_type_list.contains(params.annot_type) || params.annot_type.isEmpty()) {
        log.error "No annotation type or incorrect value has been entered for BeeDeeM process. Please configure the 'annot_type' parameter in the custom.config file to either 'bco' or 'full'"
        exit 1
  }
}

if (workflow.profile.contains('custom')) {
  if (params.lineage.isEmpty()) {
    log.error "No lineage for BUSCO analysis has been provided. Please configure the 'lineage' parameter in the custom.config file"
    exit 1
  }

def diamond_sensitivity_list = ['fast','mid-sensitive','sensitive','more-sensitive','very-sensitive','ultra-sensitive']
if (params.hit_tool == "diamond"){
    if (!diamond_sensitivity_list.contains(params.sensitivity) || params.sensitivity.isEmpty()) {
        log.error "No valid sensitivity has been chosen. Please configure the 'sensitivity' parameter in the custom.config file to either 'fast','mid-sensitive','sensitive','more-sensitive','very-sensitive' or 'ultra-sensitive'"
        exit 1
    }
}


  if (params.query_type.contains('n')) {
    channel
      .fromPath( params.fasta )
      .ifEmpty { error "Cannot find any fasta file matching: ${params.fasta}" }
      .splitFasta( by: params.chunk_size, file: true)
      .set { fasta_files }
  }

  if (params.busco_enable) {
    channel
      .from(params.lineage)
      .splitCsv(sep : ',', strip : true)
      .flatten()
      .set { lineage_list }
  }

  if (params.query_type.contains('p')) {
    def proteome = new File( params.fasta )
    def reformatproteome = proteome.text.replace('*', '')
    def proteomeok = new File("proteome_reformatted.fasta")
    proteomeok.createNewFile()
    proteomeok.text = reformatproteome
    channel
      .from ( proteomeok )
      .ifEmpty { error "Cannot find any fasta file matching: ${params.fasta}" }
      .splitFasta( by: params.chunk_size, file: true)
      .set { fasta_files }
  }

}

if (params.hectar_enable) {
  params.image = "$baseDir/containers/hectar-1.3.sif"
  if (params.image.isEmpty()) {
    log.error "No singularity image found for Hectar. Please provide one with the name 'hectar-1.3.sif' in the containers/ directory"
    exit 1
  }
}



include { get_test_data } from './modules/get_test_data.nf'
include { get_singularity_images } from './modules/get_singularity_images.nf'
include { downloadDB } from './modules/downloadDB.nf'
include { busco } from './modules/busco.nf'
include { plast } from './modules/plast.nf'
include { mergeXML_plast } from './modules/plast.nf'
include { species_taxids } from './modules/blast.nf'
include { blast } from './modules/blast.nf'
include { mergeXML_blast } from './modules/blast.nf'
include { diamond } from './modules/diamond.nf'
include { mergeXML_diamond } from './modules/diamond.nf'
include { XmlToTab_diamond } from './modules/diamond.nf'
include { XmlToTab_blast } from './modules/blast.nf'
include { interpro } from './modules/interpro.nf'
include { mergeXML_interpro } from './modules/interpro.nf'
include { mergeTSV_interpro } from './modules/interpro.nf'
include { eggnogmapper } from './modules/eggnogmapper.nf'
include { beedeem_annotation } from './modules/beedeem_annotation.nf'
include { hectar } from './modules/hectar.nf'

/*
 * RUN MAIN WORKFLOW
 */

workflow {
    if (workflow.profile.contains('test')) {
        get_test_data()
        fasta_files = get_test_data.out.query.splitFasta( by: params.chunk_size, file: true)
    }
    get_singularity_images()
    if (params.downloadDB_enable) {
        downloadDB(get_singularity_images.out.singularity_ok)
        db_ok = downloadDB.out.db_ok
    } else {
        db_ok = channel.value('database_present')
    }
    if (params.busco_enable) {
        busco(get_singularity_images.out.singularity_ok,params.fasta,lineage_list)
    }
    if (params.hit_tool == 'PLAST') {
        plast(get_singularity_images.out.singularity_ok,db_ok,fasta_files)
        mergeXML_plast(plast.out.hit_files.collect())
        ch_xml = mergeXML_plast.out.merged_plast_xml
    }
    if (params.hit_tool == 'BLAST') {
        if (params.restricted_search) {
            species_taxids(get_singularity_images.out.singularity_ok)
            txids = species_taxids.out.txids
        } else {
            txids = file(params.restricted_tax_id)
        }
        blast(get_singularity_images.out.singularity_ok,db_ok,fasta_files,txids)
        mergeXML_blast(blast.out.hit_files.collect())
        ch_xml = mergeXML_blast.out.merged_blast_xml
	XmlToTab_blast(ch_xml)
    }
    if (params.hit_tool == 'diamond') {
        diamond(get_singularity_images.out.singularity_ok,db_ok,fasta_files)
        mergeXML_diamond(diamond.out.hit_files.collect())
        ch_xml = mergeXML_diamond.out.merged_diamond_xml
	XmlToTab_diamond(ch_xml)
    }
    if (params.iprscan_enable) {
        interpro(get_singularity_images.out.singularity_ok,fasta_files)
        mergeXML_interpro(interpro.out.iprscan_files_xml.collect())
        mergeTSV_interpro(interpro.out.iprscan_files_tsv.collect())
    }
    if (params.eggnogmapper_enable) {
        eggnogmapper(get_singularity_images.out.singularity_ok,params.fasta)
    }
    if (params.beedeem_annot_enable) {
        beedeem_annotation(ch_xml)
    }
    if (params.hectar_enable) {
        hectar(params.fasta)
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
