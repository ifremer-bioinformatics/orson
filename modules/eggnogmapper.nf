process eggnogmapper {
    label 'eggnogmapper'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern: 'result.*'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'eggnog-mapper.cmd', saveAs : { eggnogmapper_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      val(singularity_ok)
      path(query)

    output:
      path "result.*", emit: eggnogmapper_dir
      path "eggnog-mapper.cmd", emit: eggnogmapper_cmd

    script:
    """
    eggnogmapper.sh ${task.cpus} ${params.query_type} ${query} result eggnog-mapper.cmd >& eggnog-mapper.log 2>&1
    """
}
