import pandas as pd

print(snakemake.input[0])
print(snakemake.output[0])

# ONE LIIIIIIINNNNNEEEEEER

pd.concat(
    [pd.read_csv(tsv, sep='\t') for tsv in snakemake.input]
    ).to_csv(snakemake.output[0], sep='\t', index=False)