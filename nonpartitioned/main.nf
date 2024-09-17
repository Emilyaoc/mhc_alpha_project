nextflow.enable.dsl = 2

// Workflow definition
workflow {
    // Define input files (note this uses the path defined in the nextflow.config file)
    ch_input_seq = Channel.fromPath(params.input_seqs)

    // Run workflow
    CONVERT_IN_PRANK( ch_input_seq )
    RUN_CODONPHYML( CONVERT_IN_PRANK.out )
    HYPHY_MEME( RUN_CODONPHYML.out, ch_input_seq )
    HYPHY_FUBAR( RUN_CODONPHYML.out, ch_input_seq )
    HYPHY_BUSTED( RUN_CODONPHYML.out, ch_input_seq )
}

// Process definition
process CONVERT_IN_PRANK {
    container "quay.io/biocontainers/prank:v.170427--h9f5acd7_5" // this initiates a container with the PRANK software 
    publishDir "results/",
    mode: "copy"

    input:
    path(alignment)

    output:
    path("${alignment}.phy")

    script: // this script converts the input sequences from fasta format to phylip format (phylip is required for CodonPhyML)
    """
    prank -convert -d=${alignment} -f=paml -o=${alignment} -keep  

    """
}

process RUN_CODONPHYML {
    container "ghcr.io/emilyaoc/codonphyml:1.0" // this initiates a container with the CodonPhyML software 
    publishDir "results/",
    mode: "copy"

    input:
    path(alignment)

    output:
    path("${alignment}_codonphyml_tree.txt")

    script: // this script creates a basic codon-based gene tree from the aligned sequences  
    """
    codonphyml -i ${alignment} -q -m GY --fmodel F3X4 -t e -f empirical -w g -a e --wclasses 3

    """
}

process HYPHY_MEME {
    container "quay.io/biocontainers/hyphy-common:v2.3.14dfsg-1-deb_cv1" // this initiates a container with the HyPhy software 
    publishDir "results/",
    mode: "copy"

    input:
    path(gene_tree)
    path(alignment)

    output:
    path("${alignment}.MEME.json")

    script: // this script runs MEME using the gene tree from CodonPhyML and the aligned sequences
    """
    hyphy meme --alignment ${alignment} --tree ${gene_tree} 

    """
}

process HYPHY_FUBAR {
    container "quay.io/biocontainers/hyphy-common:v2.3.14dfsg-1-deb_cv1" // this initiates a container with the HyPhy software 
    publishDir "results/",
    mode: "copy"

    input:
    path(gene_tree)
    path(alignment)

    output:
    path("${alignment}.FUBAR.json")

    script: // this script runs FUBAR using the gene tree from CodonPhyML and the aligned sequences
    """
    hyphy fubar --alignment ${alignment} --tree ${gene_tree} 

    """
}

process HYPHY_BUSTED {
    container "quay.io/biocontainers/hyphy-common:v2.3.14dfsg-1-deb_cv1" // this initiates a container with the HyPhy software 
    publishDir "results/",
    mode: "copy"

    input:
    path(gene_tree)
    path(alignment)

    output:
    path("${alignment}.BUSTED.json")

    script: // this script runs BUSTED using the gene tree from CodonPhyML and the aligned sequences
    """
    hyphy busted --alignment ${alignment} --tree ${gene_tree} 

    """
}

