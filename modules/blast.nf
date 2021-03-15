process blast {
    label 'blast'
    publishDir "${params.outdir}/${params.blast_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'blast.cmd', saveAs : { blast_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(ready)
      path(sequences)

    output:
      path("*.xml"), emit: hit_files
      path "blast.cmd", emit: blast_cmd

    script:
    """
    blast.sh ${task.cpus} ${params.query_type} ${sequences} ${params.blast_db} blast_hits.xml blast.cmd >& blast.log 2>&1
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

