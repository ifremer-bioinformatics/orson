process interpro {
    label 'interpro'
    publishDir "${params.outdir}/${params.interpro_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'iprscan.cmd', saveAs : { iprscan_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)
      path(query)

    output:
      path("*.xml"), emit: iprscan_files
      path "iprscan.cmd", emit: iprscan_cmd

    script:
    """
    interpro.sh ${task.cpus} ${query} ${params.query_type} iprscan_results.xml iprscan.cmd >& iprscan.log 2>&1
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
