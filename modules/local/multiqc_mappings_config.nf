
process MULTIQC_MAPPINGS_CONFIG {

    conda (params.enable_conda ? "conda-forge::python=3.9.5" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.9--1' :
        'quay.io/biocontainers/python:3.9--1' }"

    input:
    path csv

    output:
    path "*yml"        , emit: yml
    path "versions.yml", emit: versions

    script:
    """
    multiqc_mappings_config.py \\
        $csv \\
        multiqc_config.yml

    cat <<-END_VERSIONS > versions.yml
    ${task.process.tokenize(':').last()}:
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
