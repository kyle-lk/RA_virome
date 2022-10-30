

Taxa <- read.csv("Figure1_data.txt",header=T,row.names=1)


Taxa_phage<- Taxa[Taxa$viral_type=="Bacteriophage",]

ICTV_genome<- table(Taxa_phage$family_ICTV_taxonomic)

ICTV_genome <- as.data.frame(ICTV_genome)
ICTV_genome$Var1 <- as.character(ICTV_genome$Var1)
ICTV_genome <- ICTV_genome[order(ICTV_genome$Freq,decreasing = T),]
ICTV_genome$Freq <- as.numeric(ICTV_genome$Freq)
ICTV_genome$fraction = ICTV_genome$Freq / sum(ICTV_genome$Freq)
# Compute the cumulative percentages (top of each rectangle)
ICTV_genome$ymax = cumsum(ICTV_genome$fraction)
# Compute the bottom of each rectangle
ICTV_genome$ymin = c(0, head(ICTV_genome$ymax, n=-1))

ICTV_genome$labelPosition <- ((ICTV_genome$ymax + ICTV_genome$ymin) / 2) .
ICTV_genome$Var1 <- factor(ICTV_genome$Var1,ordered = T,levels = c("Siphoviridae","Microviridae","Myoviridae","Podoviridae",
                                                                   "Inoviridae","crAss-like phage","Herelleviridae","Straboviridae"))

ICTV_genome$label <- ICTV_genome$Var1

pdf("Figure1c_bacteriophage.pdf")
ggplot(ICTV_genome, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
  geom_rect() +
  scale_fill_manual(values=c(brewer.pal(4,"Set2"),brewer.pal(8,"Paired")))+
  coord_polar(theta="y") + # Try to remove that to understand how the chart is built initially
  xlim(c(2, 4)) # Try to remove that to see how to make a pie chart
dev.off()


Taxa_eukaryotic<- Taxa[Taxa$viral_type=="Eukaryotic virus",]

ICTV_genome<- table(Taxa_eukaryotic$viral_type)

ICTV_genome <- as.data.frame(ICTV_genome)
ICTV_genome <- ICTV_genome[order(ICTV_genome$Freq,decreasing = T),]
order_eukary2 <- c("Genomoviridae","Circoviridae","CRESS virus","Anelloviridae","Polyomaviridae","Papillomaviridae","Redondoviridae","Virgaviridae","Geminiviridae")

ICTV_genome$fraction = ICTV_genome$Freq / sum(ICTV_genome$Freq)
# Compute the cumulative percentages (top of each rectangle)
ICTV_genome$ymax = cumsum(ICTV_genome$fraction)
# Compute the bottom of each rectangle
ICTV_genome$ymin = c(0, head(ICTV_genome$ymax, n=-1))

ICTV_genome$Var1 <-factor(ICTV_genome$Var1,ordered = T,levels =order_eukary2 )

pdf("Figure1c_eukaryotic.pdf")
ggplot(ICTV_genome, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
  geom_rect() +
  scale_fill_manual(values=c(brewer.pal(4,"Set2"),brewer.pal(8,"Paired")))+
  coord_polar(theta="y") + # Try to remove that to understand how the chart is built initially
  xlim(c(2, 4)) # Try to remove that to see how to make a pie chart
dev.off()



ICTV_genome<- table(Taxa_phage$phylum_host,Taxa_phage$Family_host)
ICTV_genome <- as.data.frame(ICTV_genome)
ICTV_genome <- ICTV_genome[order(ICTV_genome$Freq,decreasing = T),]
ICTV_genome <- ICTV_genome[ICTV_genome$Freq!=0,]
ICTV_genome <- ICTV_genome[-1,]
ICTV_genome <-ICTV_genome[order(ICTV_genome$Var1,decreasing = T),]
ICTV_genome$Var1<- factor(ICTV_genome$Var1,ordered = T,levels = c("Firmicutes","Bacteroidetes","Actinobacteria","Proteobacteria","Chlamydiae","Verrucomicrobia"))

ICTV_genome2<-ICTV_genome %>% arrange(Var1,desc(Freq))

ICTV_genome2$Var2 <- factor(ICTV_genome2$Var2,ordered = T,levels = rev(ICTV_genome2$Var2))

pdf("Figure1d_bacteriophage.pdf")

ICTV_genome2 %>%
  ggplot( ) + 
  geom_bar(aes(y=Var2,x=Freq,fill=Var1,col=Var1),stat="identity",width=0.9,size=0.25)+
  theme(legend.position="none")+
  theme_bw()+
  theme(panel.grid=element_blank())+
  #geom_violin(alpha=0.6) +
  ylab("Host bacteria (family level)") +
  xlab("Number of Hits")+
  xlim(0,60)+
  scale_fill_manual(values=brewer.pal(8,"Set2")[c(1:5,7)])+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 10, color = 'black'),
        plot.title =element_text(hjust = 0.5, size = 20))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face='bold',size=14))


dev.off()
