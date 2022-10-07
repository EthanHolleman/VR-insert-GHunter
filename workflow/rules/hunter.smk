rule download_vr_sequences:
    conda:
        '../envs/py.yml'
    output:
        vr_insert=expand(
            'output/seperatedInserts/VR-{i}.fa',
            i=range(1, 32)
        )
    params:
        inserts_dir='output/seperatedInserts',
        inserts_path='output/seperatedInserts/complete_inserts.fa'
    script:'../scripts/prepare_inserts.py'


rule download_g4_hunter:
    output:
        'output/software/G4Hunter/G4Hunter.py'
    shell:'''
    mkdir -p output/software
    cd output/software
    git clone https://github.com/AnimaTardeb/G4Hunter
    '''

# python G4Hunter.py -i <inputfile> -o <outputrepository> -w <window> -s <score threshold>
rule hunt_g4s:
    conda:
        '../envs/py2.yml'
    input:
        g4_exe = 'output/software/G4Hunter/G4Hunter.py',
        vr_insert='output/seperatedInserts/VR-{i}.fa',
    output:
        output_dir='output/Results_VR-{i}/VR-{i}-Merged.txt'
    params:
        threshold=0.5,  # ???
        window=10
    shell:'''
    python {input.g4_exe} -i {input.vr_insert} -o output -w {params.window} -s 1.5
    '''

rule expand_merged_output:
    conda:
        '../envs/py.yml'
    input:
        g4hunter_merged='output/Results_VR-{i}/VR-{i}-Merged.txt'
    output:
        'output/G4HunterMergedExpanded/VR-{i}.merged.expand.g4.tsv'
    params:
        insert_num=lambda wildcards: wildcards.i
    script:'../scripts/expand_results.py'

rule merge_expanded_data:
    conda:
        '../envs/py.yml'
    input:
        expand(
            'output/G4HunterMergedExpanded/VR-{i}.merged.expand.g4.tsv',
            i=range(1, 32)
        )
    output:
        'output/concat.VR.G4Hunter.plot.data.tsv'
    script:'../scripts/concat_dfs.py'
    


rule plot_g_quads:
    conda:
        '../envs/R.yml'
    input:
        'output/concat.VR.G4Hunter.plot.data.tsv'
    output:
        'output/G4Hunter.predictions.VR.plot.pdf'
    script:'../scripts/plotGQuads.R'


rule copy_output_to_plots_dir:
    input:
        'output/G4Hunter.predictions.VR.plot.pdf'
    output:
        'plots/G4Hunter.predictions.VR.plot.pdf'
    shell:'''
    cp {input} {output}
    '''






