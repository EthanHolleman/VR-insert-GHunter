# Takes in output of Ghunter and expands in a way
# that is easier to show for boxplots
import pandas as pd


g4_occupied_positions = set([])
g4_table = []

try:
    merged_output = pd.read_csv(
        snakemake.input['g4hunter_merged'], sep='\t', skiprows=1
    )

    for i, row in merged_output.iterrows():
        
        # Add score for all positions even those without
        # predicted G quads. We know length of all inserts
        # is the same and is 281
        for j in range(row['Start'], row['End']):
            g4_table.append(
                {
                    'position': j,
                    'score': row['Score'],
                    'insert': snakemake.params['insert_num']
                }
            )
            g4_occupied_positions.add(j)

except pd.errors.EmptyDataError:
    # Dataframe was empty fill everything up with 0s
    pass

for i in range(0, 281):
    if i not in g4_occupied_positions:
        g4_table.append(
            {
                'position': i,
                'score': 0,
                'insert': snakemake.params['insert_num']
            } 
        )

pd.DataFrame(g4_table).to_csv(
    snakemake.output[0],
    sep='\t', index=False
    )