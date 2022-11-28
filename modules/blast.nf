process species_taxids {
    label 'internet_access'
    publishDir "${params.outdir}/${params.blast_dirname}", mode: 'copy', pattern: '.txids'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'txids.cmd', saveAs : { txids_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)

    output:
      path("*.txids"), emit: txids
      path("txids.cmd"), emit: txids_cmd

    script:
    """
    extract_species_taxids.sh ${params.restricted_tax_id} txids.cmd >& txids.log 2>&1
    """
}

process blast {
    label 'blast'
    publishDir "${params.outdir}/${params.blast_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'blast.cmd', saveAs : { blast_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)
      val(db_ok)
      path(sequences)
      path(taxids)

    output:
      path("*.xml"), emit: hit_files
      path "blast.cmd", emit: blast_cmd

    script:
    """
    blast.sh ${task.cpus} ${params.query_type} ${sequences} ${params.blast_db} blast_hits.xml ${params.restricted_search} ${taxids} blast.cmd >& blast.log 2>&1
    """
}

process mergeXML_blast {
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_blast.xml'

    input:
      path(blastXML)

    output:
      path "merged_blast.xml", emit: merged_blast_xml

    script:
    """
    BlastXMLmerge.py merged_blast.xml ${blastXML} >& merged_blast_xml.log 2>&1
    """
}

process XmlToTab_blast {

        publishDir "${params.outdir}/${params.blast_dirname}", mode: 'copy', pattern: '*.tab'
        publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_blast.tab'

        input:
                path(blastXML)

        output:
                path "merged_blast.tab", emit: merged_blast_tab

        script:
        """
        blastxml_to_tabular.py ${blastXML} > merged_blast.tab >& merged_blast_tab.log 2>&1
        """



}

