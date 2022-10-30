
  
AMG_enriched<-read.csv("Figure6_data.txt") 

AMG_enriched <- AMG_enriched[,c(1,8)]
AMG_enriched<-as.data.frame(table(AMG_enriched))


AMG_enriched$metabolism <- factor( AMG_enriched$metabolism,ordered = T,levels = c("Amino acid metabolism","Metabolism of cofactors and vitamins",
                                                                                  "Energy metabolism","Metabolism of other amino acids",
                                                                                  "Carbohydrate metabolism","Nucleotide metabolism",
                                                                                  "Glycan biosynthesis and metabolism","Folding, sorting and degradation"))
AMG_enriched$enrichment <- factor(AMG_enriched$enrichment,ordered = T,levels = c("RA_enriched","HC_enriched"))
table(AMG_enriched)

pdf("AMG_hits.pdf")
AMG_enriched %>%
  ggplot( aes(x=metabolism,y=Freq,fill=enrichment)) + 
  geom_bar(stat = 'identity')+
  theme(legend.position="none")+
  theme_bw()+
  theme(panel.grid=element_blank())+
  xlab("metabolism") +
  ylab("AMG hits")+
  #scale_fill_manual(values=brewer.pal(12,"Set3")[c(1:9)])+
  
  scale_fill_manual(values=rev(cbPalette_2color_2))+
  theme(axis.title =element_text(size = 10),axis.text =element_text(size = 7, color = 'black'),
        plot.title =element_text(hjust = 0.5, size = 10))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face='bold',size=14))#+

dev.off()


pdf("AMG_enrichment.pdf")
p<-AMG_enriched%>%
  ggplot(aes(x=log2FoldChange,y=metabolisom,fill=enrichment))+
  geom_bar(stat="identity")+
  
  theme(legend.position="none")+
  theme_bw()+
  theme(panel.grid=element_blank())+
  #geom_violin(alpha=0.6) +
  xlab("AMR gene") +
  ylab("Total hits")+
  #scale_fill_manual(values=c(brewer.pal(12,"Paired")[1:12],brewer.pal(8,"Set2")[1:8]))+
  scale_fill_manual(values=cbPalette_2color_2)+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 10, color = 'black'),
        plot.title =element_text(hjust = 0.5, size = 20))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face='bold',size=14))#+
p

dev.off()





