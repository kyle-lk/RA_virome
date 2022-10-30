
enrichment_analysis <- read.table("Figure3_data.txt",header = T,sep="\t")


ICTV_taxa_enrich <- enrichment_analysis[!is.na(enrichment_analysis$Enrichment),] 

order_name <- names(sort(table(ICTV_taxa_enrich$family_level_ICTV_taxonomic),decreasing = T))
ICTV_taxa_enrich$family_level_ICTV_taxonomic <- factor(ICTV_taxa_enrich$family_level_ICTV_taxonomic,ordered = T,levels = rev(order_name))

pdf("Figure3_ICTV.pdf")
p<-ICTV_taxa_enrich_fd%>%
  ggplot(aes(y=ICTV_taxa_enrich,x=log2FoldChange,col=col,fill=enrichment))+
  scale_fill_viridis(discrete = FALSE, alpha=0.6) +
  geom_jitter(size=1.5,width=0.1,show.legend=T,alpha=0.8,height=0.2)+
  theme_bw()+
  theme(panel.grid=element_blank())+
  scale_fill_manual(values=c("#DF65B0","#4EB3D3"))+
  theme(plot.title = element_text(hjust = 0.5,face='bold',size=18))+
  theme(plot.subtitle = element_text(hjust = 0.5,face='bold',size=16))+
  theme(axis.title.y = element_text(face = 'bold',size=15))+  
  theme(axis.title.x = element_text(face = 'bold',size=15))+ 
  theme(axis.text.x = element_text(face = 'bold',size=13))+   
  theme(axis.text.y = element_text(face = 'bold',size=10))   
p
dev.off()


order_name <- names(sort(table(ICTV_taxa_enrich$family_level_host),decreasing = T))
ICTV_taxa_enrich$family_level_host <- factor(ICTV_taxa_enrich$family_level_host,ordered = T,levels = rev(order_name))

pdf("Figure3_phage_host_family.pdf")
p<-ICTV_taxa_enrich_fd%>%
  ggplot(aes(y=family_level_host,x=log2FoldChange,col=col,fill=family_level_host))+
  scale_fill_viridis(discrete = FALSE, alpha=0.6) +
  geom_jitter(size=1.5,width=0.1,show.legend=T,alpha=0.8,height=0.2)+
  theme_bw()+
  theme(panel.grid=element_blank())+
  scale_fill_manual(values=c("#DF65B0","#4EB3D3"))+
  theme(plot.title = element_text(hjust = 0.5,face='bold',size=18))+
  theme(plot.subtitle = element_text(hjust = 0.5,face='bold',size=16))+
  theme(axis.title.y = element_text(face = 'bold',size=15))+  
  theme(axis.title.x = element_text(face = 'bold',size=15))+ 
  theme(axis.text.x = element_text(face = 'bold',size=13))+   
  theme(axis.text.y = element_text(face = 'bold',size=10))   
p
dev.off()

order_name <- names(sort(table(ICTV_taxa_enrich$Genus_host),decreasing = T))
ICTV_taxa_enrich$Genus_host <- factor(ICTV_taxa_enrich$Genus_host,ordered = T,levels = rev(order_name))

pdf("Figure3_phage_host_genus.pdf")
p<-ICTV_taxa_enrich_fd%>%
  ggplot(aes(y=Genus_host,x=log2FoldChange,col=col,fill=Genus_host))+
  scale_fill_viridis(discrete = FALSE, alpha=0.6) +
  geom_jitter(size=1.5,width=0.1,show.legend=T,alpha=0.8,height=0.2)+
  theme_bw()+
  theme(panel.grid=element_blank())+
  scale_fill_manual(values=c("#DF65B0","#4EB3D3"))+
  theme(plot.title = element_text(hjust = 0.5,face='bold',size=18))+
  theme(plot.subtitle = element_text(hjust = 0.5,face='bold',size=16))+
  theme(axis.title.y = element_text(face = 'bold',size=15))+  
  theme(axis.title.x = element_text(face = 'bold',size=15))+ 
  theme(axis.text.x = element_text(face = 'bold',size=13))+   
  theme(axis.text.y = element_text(face = 'bold',size=10))   
p
dev.off()





