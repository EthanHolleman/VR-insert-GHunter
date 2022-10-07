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


# Plot G4 probs for comparable G clustered sequences


g1 <- c(18, 15, 16, 17)  # AT skew = 0.1 
g2 <- c(22, 19, 20, 21)  # ... = 0.2
g3 <- c(26, 23, 24, 25)  # ... = 0.4

plotClusteredGQuads <- function(df, groupMembers){

    df.group <- df[df$insert %in% groupMembers, ]
    ggplot(df.group, aes(x=position, y=score, color=as.factor(insert))) + 
            stat_smooth(method = "lm", formula = y ~ poly(x, 21), se = FALSE) +
            theme_pubr() +
            geom_hline(yintercept=1.2, linetype="dashed", color = "black") + 
            geom_hline(yintercept=-1.2, linetype="dashed", color = "black") +
            labs(x='Position (bp)', y='G4Hunter score', color='Insert')
}

for (group in list(g1, g2, g3)){
    print('GROUP=====================')
    print(group)
    gclust.plot <- plotClusteredGQuads(df, group)
    print(gclust.plot)
    message("CLUSTERED PLOT")
    message(group)


}


# Plot G4 prediction scores for each insert and output each to a different plot
# save as a pdf file.

for (val in seq(1:num.inserts))
{

    plt.df <- subset(df, insert==val)
    print(ggplot(plt.df, aes(x=position, y=score), fill='dodgerblue') + geom_bar(stat='identity') +
          theme_pubr() + labs(title=val, x='Nucleotide Position', y='GHunter Score (1.2 cutoff)')
    )
    message(mycolors[[val]])

}

dev.off()






