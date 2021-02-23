process interpro {
    label 'interpro'
    publishDir "${params.outdir}/${params.interpro_dirname}", mode: 'copy', pattern: '*iprscan_results'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'iprscan.cmd', saveAs : { iprscan_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      path(ready)
      path(query)

    output:
      path("*iprscan_results"), emit: iprscan_dir
      path "iprscan.cmd", emit: iprscan_cmd

    script:
    """
    interpro.sh ${task.cpus} ${query} ${params.query_type} iprscan_results iprscan.cmd >& iprscan.log 2>&1
    """
}
