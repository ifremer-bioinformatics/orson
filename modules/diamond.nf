process diamond {
    label 'diamond'
    publishDir "${params.outdir}/${params.diamond_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'diamond.cmd', saveAs : { diamond_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      path(ready)
      path(chunks)

    output:
      path("*.xml"), emit: hit_files
      path "diamond.cmd", emit: diamond_cmd

    script:
    """
    diamond.sh ${task.cpus} ${params.query_type} ${chunks} ${params.diamond_db} diamond_hits.xml diamond.cmd >& diamond.log 2>&1
    """
}
