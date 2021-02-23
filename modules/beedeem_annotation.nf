process beedeem_annotation {
    label 'beedeem'
    publishDir "${params.outdir}/${params.beedeem_dirname}", mode: 'copy', pattern: '*.zml'
    publishDir "${params.outdir}/${params.report_dirname}", mode: 'copy', pattern : 'beedeem_annotation.cmd', saveAs : { beedeem_annotation_cmd -> "cmd/${task.process}_complete.sh" }

    input:
      path(xml)

    output:
      path("*.zml"), emit: zml_files
      path "beedeem_annotation.cmd", emit: beedeem_annot_cmd

    script:
    """
    beedeem_annotation.sh ${xml} beedeem_annotation.zml ${params.annot_type} beedeem_annotation.cmd >& beedeem_annotation.log 2>&1
    """
}
