process plast {
    label 'plast'
    publishDir "${params.outdir}/${params.plast_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'plast.cmd', saveAs : { plast_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(ready)
      val(buscoOk)
      path(seq)

    output:
      path("*.xml"), emit: hit_files
      path "plast.cmd", emit: plast_cmd

    script:
    """
    plast.sh ${task.cpus} ${params.query_type} ${seq} ${params.plast_db} plast_hits.xml plast.cmd >& plast.log 2>&1
    """
}

process mergeXML_plast {
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_plast.xml'

    input:
      path(plastXML)

    output:
      path "merged_plast.xml", emit: merged_plast_xml

    script:
    """
    BlastXMLmerge.py merged_plast.xml ${plastXML} >& merged_plast_xml.log 2>&1
    """
}
