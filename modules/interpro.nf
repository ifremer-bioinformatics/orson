process interpro {
    label 'interpro'
    publishDir "${params.outdir}/${params.interpro_dirname}", mode: 'copy', pattern: '*.???'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'iprscan.cmd', saveAs : { iprscan_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)
      path(query)

    output:
      path("*.xml"), emit: iprscan_files_xml
      path("*.tsv"), emit: iprscan_files_tsv
      path "iprscan.cmd", emit: iprscan_cmd

    script:
    """
    interpro.sh ${task.cpus} ${query} ${params.query_type} iprscan.cmd >& iprscan.log 2>&1
    """
}

process mergeXML_interpro {
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_iprscan.xml'

    input:
      path(iprscanXML)

    output:
      path "merged_iprscan.xml", emit: merged_iprscan_xml

    script:
    """
    IPRScanXMLmerge.sh merged_iprscan.xml ${params.query_type} >& merged_iprscan_xml.log 2>&1
    """
}

process mergeTSV_interpro {
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_iprscan.tsv'

    input:
      path(iprscanTSV)

    output:
      path "merged_iprscan.tsv", emit: merged_iprscan_tsv

    script:
    """
    IPRScanTSVmerge.sh merged_iprscan.tsv >& merged_iprscan_tsv.log 2>&1
    """
}

