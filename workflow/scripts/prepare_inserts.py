from Bio import SeqIO
import requests
from pathlib import Path

# Download VR inserts file

VR_fa = requests.get(
    'https://github.com/EthanHolleman/plasmid-VR-design/releases/download/v2.0/complete_inserts.fa',
    allow_redirects=True)
with open(snakemake.params['inserts_path'], 'wb') as handle:
    handle.write(VR_fa.content)


# Separate into individual files
record_dir = Path(snakemake.params['inserts_dir'])
record_dir.mkdir(exist_ok=True)

record_paths = []

VR_records = SeqIO.parse(snakemake.params['inserts_path'], 'fasta')

for each_insert in VR_records:
    name = each_insert.description.split('_')[-1]
    fp = str(record_dir.joinpath(name).with_suffix('.fa'))
    SeqIO.write([each_insert], fp, 'fasta')
    record_paths.append(Path(fp))
