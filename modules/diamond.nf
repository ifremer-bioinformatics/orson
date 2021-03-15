process diamond {
    label 'diamond'
    publishDir "${params.outdir}/${params.diamond_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'diamond.cmd', saveAs : { diamond_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(ready)
      path(chunks)

    output:
      path("*.xml"), emit: hit_files
      path "diamond.cmd", emit: diamond_cmd

    script:
    """
    diamond.sh ${task.cpus} ${params.query_type} ${chunks} ${params.diamond_db} diamond_hits.xml diamond.cmd >& diamond.log 2>&1
    """
}

process mergeXML_diamond {
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'merged_diamond.xml'

    input:
      path(diamondXML)

    output:
      path "merged_diamond.xml", emit: merged_diamond_xml

    script:
    """
    BlastXMLmerge.py merged_diamond.xml ${diamondXML} >& merged_diamond_xml.log 2>&1
    """
}
