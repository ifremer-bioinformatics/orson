process hectar {
    label 'hectar'
    publishDir "${params.outdir}", mode: 'copy', pattern: '*.csv'
    input:
        path(fasta)
    output:
        path("result_hectar.csv")
    script:
        """
        hectar.pl --input ${fasta} --output result_hectar.csv --cpu ${task.cpus}
        """
}
