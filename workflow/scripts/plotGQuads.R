library(ggpubr)
library(ggplot2)
library(RColorBrewer)


df <- read.table(file = snakemake@input[[1]], sep = '\t', header = TRUE)

num.inserts <- 31  # hardcode!!!!! YEEEEEAAAAAH

colors <- num.inserts
mycolors <- colorRampPalette(brewer.pal(8, "Dark2"))(colors)


library(ggplot2)
library(gridExtra)

pdf(snakemake@output[[1]], onefile = TRUE)

for (val in seq(1:num.inserts))
{

    plt.df <- subset(df, insert==val)
    print(ggplot(plt.df, aes(x=position, y=score), fill='dodgerblue') + geom_bar(stat='identity') +
          theme_pubr() + labs(title=val, x='Nucleotide Position', y='GHunter Score (1.2 cutoff)')
    )
    message(mycolors[[val]])

}

dev.off()
