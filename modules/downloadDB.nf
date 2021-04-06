process downloadDB {
    label 'internet_access'

    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'downloadDB.cmd', saveAs : { downloadDB_cmd -> "cmd/${task.process}_complete.sh" }

    output:
    path "downloadDB.cmd", emit: downloadDB_cmd
    path "database_present", emit: db_ok

    script:
    """
    downloadDB.sh ${params.db_dir} ${params.steps_data} database_present downloadDB.cmd >& downloadDB.log 2>&1
    """
}