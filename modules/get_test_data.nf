process get_test_data {
    label 'internet_access'

    output:
      path("test_data_is_ready"), emit: test_ready
      path("query.fasta"), emit: query

    script:
    """
    get_test_data.sh ${baseDir} test_data_is_ready query.fasta >& get_test_data.log 2>&1
    """
}
