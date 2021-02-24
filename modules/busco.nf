process busco {
    label 'busco'
    publishDir "${params.outdir}/${params.busco_dirname}", mode: 'copy', pattern: 'busco_results*'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'busco.cmd', saveAs : { busco_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(ready)
      path(transcriptome)

    output:
      path("busco_results*"), emit: busco_dir
      path "busco.cmd", emit: busco_cmd

    script:
    """
    busco.sh ${task.cpus} ${transcriptome} busco_results ${params.lineage} busco.cmd >& busco.log 2>&1
    """
}