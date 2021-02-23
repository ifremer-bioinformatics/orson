process plast {
    label 'plast'
    publishDir "${params.outdir}/${params.plast_dirname}", mode: 'copy', pattern: '*.xml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'plast.cmd', saveAs : { plast_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      path(ready)
      path(seq)

    output:
      path("*.xml"), emit: hit_files
      path "plast.cmd", emit: plast_cmd

    script:
    """
    plast.sh ${task.cpus} ${params.query_type} ${seq} ${params.plast_db} plast_hits.xml plast.cmd >& plast.log 2>&1
    """
}
