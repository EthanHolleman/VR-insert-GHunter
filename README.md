# VR-insert-GHunter

Snakemake workflow which uses the G4Hunter program to predict
G4 occurrence in VR insert sequences. 

## Parameters

G4Hunter requires you to set a threshold value when running the program.
It appears that only G4s with a abs(score) >= to this value are returned.
I set the value to 1.2 for all runs and used a window size of 10. 

The 1.2 cutoff was based off of original GHunter paper [figure 1](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4770238/figure/F1/) where it appears that G quads are
most strongly predicted beyond this score.

## Output

Most recent run output plots are in the `plots` folder. These show barplots of
GHunter scores over all positions in each VR insert sequence.