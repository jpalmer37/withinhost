# LENGTH ANALYSIS
# --------------------------------------------------------
# script to process indel lengths 


categorize <- function(seqList){
  seqs <- strsplit(seqList, ",")[[1]]
  if (identical(seqs, character(0))){
    return(c())
  }
  lengths <- nchar(seqs)
  category <- c(unname(sapply(lengths, function(x){
    if (x <3){
      "1-2"
    }else if(x == 3){
      "3"
    }else if(x == 4 | x == 5){
      "4-5"
    }else if(x == 6){
      "6"
    }else if(x == 7 | x == 8){
      "7-8"
    }else if(x == 9){
      "9"
    }else if(x > 9){
      ">9"
    }
  })))
  category
}

path <- "~/PycharmProjects/hiv-withinhost/"
#path <- "~/Lio/"
iLength <- read.csv(paste0(path,"12_lengths/all/ins-all.csv"), row.names=1, stringsAsFactors = F)
dLength <- read.csv(paste0(path,"12_lengths/all/del-all.csv"), row.names=1, stringsAsFactors = F)
 
iLength <- iLength[iLength$count>0,]
dLength <- dLength[dLength$count>0,]

iLength$Len <- sapply(iLength$indel, nchar)
dLength$Len <- sapply(dLength$indel, nchar)

iLength$Bin <- sapply(iLength$indel,categorize)
dLength$Bin <- sapply(dLength$indel,categorize)

dLength <- dLength[nchar(dLength$indel) < 200, ]

# verify that  no commas are found within the iLength and dLength data frames 
"," %in% iLength$indel
"," %in% dLength$indel

# order the iLength and dLength dataframes 
l <- c(">9","9","7-8", "6", "4-5","3", "1-2")
l <- l[length(l):1]  # TO REVERSE THE ORDER 

iLength$Bin <- factor(iLength$Bin,levels=l)
dLength$Bin <- factor(dLength$Bin,levels=l)

# table manipulation for data display
itab <- table(iLength$Bin, iLength$vloop)
dtab <- table(dLength$Bin, dLength$vloop)

require(vcd)

idf <- as.data.frame(itab)
ddf <- as.data.frame(dtab)


colnames(idf) <- c("Bin", "vloop", "count")
colnames(ddf) <- colnames(idf)


# --- Mosaic Plot -----
data <- ddf
df <- data.frame(bin=factor(rep(data$Bin, data$count),levels=c("1-2","3","4-5","6","7-8","9",">9")), vloop = rep(data$vloop, data$count))

# reorder the data frame 
df$bin <- factor(df$bin, levels=c("1-2","3","4-5","6","7-8","9",">9"))
df <- df[order(df$bin),]

require(vcd)
mosaic(~ bin + vloop,
       data = df,
       shade=T, main=NULL,
       spacing=spacing_equal(sp = unit(0.7, "lines")),
       residuals_type="Pearson", direction="v",
       margins=c(2,2,6,2),
       labeling_args = list(tl_labels = c(F,T), 
                            tl_varnames=c(F,T),
                            gp_labels=gpar(fontsize=24),
                            gp_varnames=gpar(fontsize=28),
                            set_varnames = c(vloop="Variable Loop", 
                                             bin="Indel Length (nt)"),
                            offset_labels=c(0,0,0,0),rot_labels=c(0,0,0,0), just_labels=c("center","center","center","center")),
       legend=legend_resbased(fontsize = 20, fontfamily = "",
                              x = unit(0.5, "lines"), y = unit(2,"lines"),
                              height = unit(0.8, "npc"),
                              width = unit(1, "lines"), range=c(-10,10)),
       set_labels=list(Variable.Loop=c("V1","V2","V3","V4","V5")))

# ---- Significance ---- 
# add in the significance level column
idf$Sign <- rep(2,35)
#idf$Sign[c(1,11,15,23,28,30,31,35)] <- c(2,3,3,1,3,3,3,1)
idf$Sign[c(1,7,11,15,18,28,29,30,32,35)] <- c(1,3,3,3,3,3,3,3,3,1)
ddf$Sign <- rep(2,35)
#ddf$Sign[c(7,11,13,14,15,29,30,31,35)] <- c(3,3,3,1,3,1,3,3,1)
ddf$Sign[c(1,4,7,9,11,13,14,15,16,30,31,34,35)] <- c(1,1,3,1,3,3,1,3,1,3,3,1,1)

# Proportion of frameshift indels 
x <- nchar(iLength$indel)
sum(x[x%%3 != 0]) / sum(x)

x <- nchar(dLength$indel)
sum(x[x%%3 != 0]) / sum(x)



l <- l[length(l):1]

# STACK BAR PLOT 
# -------------------------------------------
require(RColorBrewer)
pal <- c("gray28", "blue4",  'tomato', 'dodgerblue',  'red',  "skyblue", 'darkred' )
pal <- pal[length(pal):1]

data <- ddf

ymx <- 650


#png(filename="~/vindels/Figures/within-host/finalized/del-length-v2", width=1200, height=700)
par(mar=c(6,7,2,5.5), xpd=F)
ax <- 1.7
lab <- 2.1
plot(NA, xlim=c(0,5), 
     ylim=c(0,ymx), 
     xaxt="n",
     xaxs="i",
     yaxs="i",
     xlab="",
     ylab="",
     cex.lab=lab, cex.axis=ax, las=1)
axis(1,at=seq(0.5,4.5), 
     labels=c("V1", "V2", "V3", "V4", "V5"),
     cex.axis=ax)
title(ylab="Deletion Counts", cex.lab=lab, line=4.2)
title(xlab="Variable Loop", cex.lab=lab, line=3.5)
abline(v=seq(0.5,4.5)-0.3, lty=1, col="gray68")
abline(v=seq(0.5,4.5)+0.3, lty=1, col="gray68")
#abline(h=seq(0,150,50), col="gray68")


for (i in seq(0.5,4.5)){
  pos <- 0
  d <- data[data$vloop==i+0.5,]
  #data <- data[nrow(data):1,]
  
  for (j in 1:7){
    s <- d[j,"Sign"]
    n <- d[j,"count"]
    
    rect(i-0.15*s, pos, i+0.15*s, pos+n, col=pal[j])
    pos <- pos + n
  }
}
par(xpd=NA)
text(-0.5,650,"b)",cex=2)
pal <- pal[length(pal):1]
legend(5.05,450,
       legend=l,cex=1.5, 
       pch=22,pt.cex=3,pt.bg=pal,
       y.intersp=1,
       title="Lengths")


require(ggplot2)
iplot <- ggplot() + 
  geom_bar(aes(x=vloop, y=count, fill=Bin), data=idf, stat='identity') + 
  scale_fill_manual(values=rep(pal,4)) + 
  labs(x="Variable Loop", 
       y="Frequency", title="Insertion Lengths") +
  theme(panel.grid.major.y = element_line(color="black",size=0.3),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.spacing=unit(1, "mm"),
        #panel.background=element_rect(fill="gray88",colour="white",size=0),
        plot.margin =margin(t = 1.3, r = 1, b = 0.7, l = 1.5, unit = "cm"),
        axis.line = element_line(colour = "black"), 
        axis.title=element_text(size=18,margin=margin(t = 0, r = 3, b = 0, l = 12)),
        axis.text = element_text(size=16, colour="black"),
        plot.title = element_text(size=22, hjust = 0.5),
        legend.text=element_text(size=16), 
        legend.background=element_rect(colour="black"),
        legend.title=element_text(size=18))
iplot


dplot <- ggplot() + 
  geom_bar(aes(x=vloop, y=count, fill=Bin), data=ddf, stat='identity') + 
  scale_fill_manual(values=rep(pal,4)) + 
  labs(x="Variable Loop", 
       y="Frequency", title="Deletion Lengths") +
  theme(panel.grid.major.y = element_line(color="black",size=0.3),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.spacing=unit(1, "mm"),
        #panel.background=element_rect(fill="gray88",colour="white",size=0),
        plot.margin =margin(t = 1.3, r = 1, b = 0.7, l = 1.5, unit = "cm"),
        axis.line = element_line(colour = "black"), 
        axis.title=element_text(size=18,margin=margin(t = 0, r = 3, b = 0, l = 12)),
        axis.text = element_text(size=16, colour="black"),
        plot.title = element_text(size=22, hjust = 0.5),
        legend.text=element_text(size=16), 
        legend.background=element_rect(colour="black"),
        legend.title=element_text(size=18))
dplot




# TEST : ALLUVIAL PLOT
# ----------------------------------------
iplot <- ggplot(idf, aes(y=count, axis1=)) + 
  geom_bar(aes(x=vloop, y=count, fill=Bin), data=idf, stat='identity') + 







mosaic(~vloop + Bin, data=iLength,
       shade=T, main=NULL, direction="v",
       spacing=spacing_equal(sp = unit(0.7, "lines")),
       residuals_type="Pearson",
       margins=c(2,2,6,2),
       labeling_args = list(tl_labels = c(F,T), 
                            tl_varnames=c(F,T),
                            gp_labels=gpar(fontsize=20),
                            gp_varnames=gpar(fontsize=26),
                            set_varnames = c(vloop="Variable Loop", 
                                             Bin="Insertion Length (nt)"),
                            offset_labels=c(0,0,0,0),rot_labels=c(0,0,0,0), just_labels=c("center","center","center","center")),
       legend=legend_resbased(fontsize = 20, fontfamily = "",
                              x = unit(0.5, "lines"), y = unit(2,"lines"),
                              height = unit(0.8, "npc"),
                              width = unit(1, "lines"), range=c(-10,10)),
       set_labels=list(vloop=c("V1","V2","V4","V5")))


mosaic(~vloop + Bin, data=dLength,
       shade=T, main=NULL, direction="v",
       spacing=spacing_equal(sp = unit(0.7, "lines")),
       residuals_type="Pearson",
       margins=c(2,2,6,2),
       labeling_args = list(tl_labels = c(F,T), 
                            tl_varnames=c(F,T),
                            gp_labels=gpar(fontsize=20),
                            gp_varnames=gpar(fontsize=26),
                            set_varnames = c(vloop="Variable Loop", 
                                             Bin="Deletion Length (nt)"),
                            offset_labels=c(0,0,0,0),rot_labels=c(0,0,0,0), just_labels=c("center","center","center","center")),
       legend=legend_resbased(fontsize = 20, fontfamily = "",
                              x = unit(0.5, "lines"), y = unit(2,"lines"),
                              height = unit(0.8, "npc"),
                              width = unit(1, "lines"), range=c(-10,10)),
       set_labels=list(vloop=c("V1","V2","V4","V5")))



ggplot()
ggplot(all.df, aes(x=Date, y=count, group=count)) + geom_density_ridges(colour="white", fill="blue", scale=1, bandwidth=5)
