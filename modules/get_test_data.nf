process get_test_data {
    label 'internet_access'

    output:
      path("query.fasta"), emit: query

    script:
    """
    get_test_data.sh ${baseDir} query.fasta >& get_test_data.log 2>&1
    """
}
