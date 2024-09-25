nextflow.enable.dsl = 2

// Workflow definition
workflow {
    // Define input files (note this uses the path defined in the nextflow.config file)
    ch_input_seq = Channel.fromPath(params.input_seqs)
    ch_input_tree = Channel.fromPath(params.input_tree)
    ch_busted_ph = Channel.fromPath(params.busted_ph_bf)

    // Run workflow
    HYPHY_BUSTED_PH ( ch_input_seq, ch_input_tree, ch_busted_ph.collect() )
    HYPHY_RELAX ( ch_input_seq, ch_input_tree )
}

// Process definition
process HYPHY_BUSTED_PH {
    container "quay.io/biocontainers/hyphy:2.5.50--h91ae1e9_1" // this initiates a container with the HyPhy software 
    publishDir "results/",
    mode: "copy"

    input:
    path(alignment)
    path(gene_tree)
    path(batch_file)
    

    output:
    path("${alignment}.BUSTED.json")

    script: // this script runs BUSTED-PH batch file using the input tree (gene tree produced ny CodonPhyML previously & annotated) and the aligned sequences
    """
    hyphy ${batch_file} --alignment ${alignment} --tree ${gene_tree} --branches P --comparison NP 

    """
}

process HYPHY_RELAX {
    container "quay.io/biocontainers/hyphy:2.5.50--h91ae1e9_1" // this initiates a container with the HyPhy software 
    publishDir "results/",
    mode: "copy"

    input:
    path(alignment)
    path(gene_tree)

    output:
    path("${alignment}.RELAX.json")

    script: // this script runs MEME using the gene tree from CodonPhyML and the aligned sequences
    """

    hyphy relax --alignment ${alignment} --tree ${gene_tree} --test P --reference NP

    """
}