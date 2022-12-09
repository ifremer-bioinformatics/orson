process busco {
    label 'busco'
    publishDir "${params.outdir}/${params.busco_dirname}", mode: 'copy', pattern: 'busco_results*'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'busco_results*/short_summary.*'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'busco.cmd', saveAs : { busco_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)
      path(transcriptome)
      each(lineageList)
    
    output:
      path("busco_results*"), emit: busco_dir
      path "busco.cmd", emit: busco_cmd
      path("busco_results*/short_summary.*")

    script:
    """
    busco.sh ${task.cpus} ${transcriptome} busco_results ${lineageList} ${params.query_type} busco.cmd >& busco.log 2>&1
    """
}
