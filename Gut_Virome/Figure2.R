abundance <- read.csv("Figure2_data.txt",header=T,row.names=1)
abundance <- as.data.frame(abundance)
abundance_t <- t(abundance)


abundance_t_R <- vegan::rrarefy(abundance_t,min(rowSums(abundance_t)))
Shannon.wiener <- vegan::diversity(abundance_t_R, "shannon")
Simpson <- vegan::diversity(abundance_t_R,"simpson")
Inverse.Simpson <- vegan::diversity(abundance_t_R, index = "inv")
S <- vegan::specnumber(abundance_t_R)
J <- Shannon.wiener / log(S)
ca <- data.frame(vegan::estimateR(abundance_t_R))
diversity_num <- NULL
diversity_num <-cbind(Shannon=Shannon.wiener,Simpson,Inverse.Simpson,Species_number=S,Evenness=J,t(ca)[,c(2,4)])
head(diversity_num)
diversity_num <- as.data.frame(diversity_num)
diversity_num$SampleID <- row.names(diversity_num)
diversity_num_all_merged <- merge(diversity_num,Group_info,by="SampleID")
dim(diversity_num_all_merged)
head(diversity_num_all_merged)
diversity_num_all_merged <- diversity_num_all_merged[,-1]
write.table(diversity_num_all_merged, "alpha_index.txt", append = FALSE, sep="\t", quote=F)


diversity_num_all_merged$Group_RA <- factor(diversity_num_all_merged$Group_RA, ordered = TRUE, levels = c("HC","RA"))

cbPalette_2color_2 <- c("#4EB3D3","#DF65B0")

pdf("Shannon_index_RA_vs_HC.pdf")
diversity_num_all_merged %>%
  ggplot( aes(x=Group_RA, y=Shannon,fill=Group_RA)) + 
  geom_boxplot(size=1)+
  xlab("Group") +
  theme(legend.position="none")+
  labs(y="Shannon Index")+
  theme_bw()+
  theme(panel.grid = element_blank())+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 15,color = 'black'),
        plot.title =element_text(hjust = 0.5, size = 20))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face='bold',size=14))+
  stat_compare_means()
dev.off()

pdf("Richness_RA_vs_HC.pdf")

diversity_num_all_merged %>%
  ggplot( aes(x=Group_RA, y=species,fill=Group_RA)) + 
  geom_boxplot(size=1)+
  geom_line(aes(group=SampleID),size=0.5,color="#9C9C9C",alpha=0.8)+
  xlab("Group") +
  theme(legend.position="none")+
  labs(y="Richness")+
  theme_bw()+
  theme(panel.grid=element_blank())+
  #scale_fill_manual(values = brewer.pal(12,"Set3")[c(1,4)])+
  theme_bw()+
  theme(panel.grid = element_blank())+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 15,color = 'black'),
        plot.title =element_text(hjust = 0.5, size = 20))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,face='bold',size=14))+
  stat_compare_means()
dev.off()


distance.bray2<-vegdist(log1p(phages_rpm_t),method = "bray")

distance.bray.pcoA2 <-cmdscale(distance.bray2,k=3,eig=T)
points2 <- as.data.frame(distance.bray.pcoA2$points)
colnames(points2)<- c("x","y","z")
eig2 <- distance.bray.pcoA2$eig
points2$SampleID <- row.names(points2)
points_merge2 <- merge(points2,Group_info,by="SampleID")
points_merge2 <- as.data.frame(points_merge2)
row.names(points_merge2) <- points_merge2$SampleID
points_merge2[,-1]
points_merge2$Group_RA <- factor(points_merge2$Group_RA,ordered = TRUE, levels = c("HC","RA"))
points_merge2 <- points_merge2[order(points_merge2$Group_RA),]

pdf("PCoA_beta_diversity_RA_HC.pdf")
p <- ggplot(points_merge2, aes(x=x, y=y,color=Group_RA)) +
  geom_point(aes(shape=Group_RA),size=3,stroke=1) + 
  labs(x=paste("PCoA 1 (", format(100 * eig2[1] / sum(eig2), digits=4), "%)", sep=""),
       y=paste("PCoA 2 (", format(100 * eig2[2] / sum(eig2), digits=4), "%)", sep=""),
       title="bray_curtis PCoA")+
  theme_bw()+
  theme(panel.grid=element_blank())+
  scale_fill_manual(values=points_merge2$Group_RA)+
  labs(colour="group",shape="group")#+

p
dev.off()

distance.bray2_table <- as.dist(distance.bray2, diag = FALSE, upper = FALSE)
adonis_table = adonis(distance.bray2_table~Group_RA,data=Group_info, permutations = 10000) 
adonis_pvalue = adonis_table$aov.tab$`Pr(>F)`[1]
adonis_pvalue



