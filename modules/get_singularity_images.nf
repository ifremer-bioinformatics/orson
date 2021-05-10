process get_singularity_images {
    label 'internet_access'

    output:
      path("singularity_images_ok"), emit: singularity_ok

    script:
    """
    get_singularity_images.sh ${baseDir} singularity_images_ok >& get_singularity_images.log 2>&1
    """
}
