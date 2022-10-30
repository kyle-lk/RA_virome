
alpha_diversity <- read.table("Figure4_data1.txt")

diversity_merged <- merge(alpha_diversity,Group_info.txt,by="SampleID")

diversity_merged_RA <- diversity_merged[diversity_merged$Group2=="RA",2:7]
diversity_merged_HC <- diversity_merged[diversity_merged$Group2=="HC",2:7]
diversity_merged_RA.cor<-corr.test(diversity_merged_RA, use = "complete", method = "spearman", adjust = "none")
diversity_merged_HC.cor<-corr.test(diversity_merged_HC, use = "complete", method = "spearman", adjust = "none")


pdf("pahge_16s_cor_plot(RA).pdf")
corrplot(diversity_merged_RA.cor$r,p.mat =diversity_merged_RA.cor$p,type="lower",mar=c(1,1,1,1),
         insig = 'label_sig',sig.level = c(.001, .01, .05), pch.cex = .1, pch.col = 'black')
dev.off()
pdf("phage_16s_HC_plot(HC).pdf")
corrplot(diversity_merged_HC.cor$r,p.mat = diversity_merged_HC.cor$p,type="lower",mar=c(1,1,1,1),
         insig = 'label_sig',sig.level = c(.001, .01, .05), pch.cex = .1, pch.col = 'black')
dev.off()


family_level <- read.table("Figure4_data2.txt")


family_level_merged <- merge(family_level,Group_info.txt,by="SampleID")

family_level_merged_RA <- family_level_merged[family_level_merged$Group2=="RA",]  ## select virus 
family_level_merged_HC <- family_level_merged[family_level_merged$Group2=="HC",]    ## select virus 
family_level_merged_RA.cor<-corr.test(family_level_merged_RA, use = "complete", method = "spearman", adjust = "none")
family_level_merged_HC.cor<-corr.test(family_level_merged_HC, use = "complete", method = "spearman", adjust = "none")


pdf("pahge_16s_cor_plot_family_level(RA).pdf")
corrplot(family_level_merged_RA.cor$r,p.mat =family_level_merged_RA.cor$p,type="lower",mar=c(1,1,1,1),
         insig = 'label_sig',sig.level = c(.001, .01, .05), pch.cex = .1, pch.col = 'black')
dev.off()
pdf("phage_16s_HC_plot_family_level(HC).pdf")
corrplot(family_level_merged_HC.cor$r,p.mat = family_level_merged_HC.cor$p,type="lower",mar=c(1,1,1,1),
         insig = 'label_sig',sig.level = c(.001, .01, .05), pch.cex = .1, pch.col = 'black')
dev.off()
