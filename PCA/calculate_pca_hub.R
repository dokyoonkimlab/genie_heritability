library(stats)
library(PCAmixdata)

phe = read.csv(file = "../phenotype_imputation/phe_imputed.csv")
#write.csv(phe[,-1], file = "phe_imputed.csv", quote = F, row.names = F)
categories = read.csv(file = "genie_disease_disease_list.csv", stringsAsFactors = F, header = F, na.strings = "")
final_pca_data = data.frame()
cnames  = c()

for (i in 1:ncol(categories)) {
  category = categories[,i]
  category = category[c(-2)]
  category = category[!is.na(category)]
  if (length(category) > 5) {
    name = category[1]
    
    phe_cat = phe[,colnames(phe) %in% category]
    binary_phe_cols = apply(phe_cat, 2, function(x){length(unique(x)) == 2})
    pcs_S = c()
    if (!any(binary_phe_cols)) {
      pca = prcomp(scale(phe_cat), center = TRUE)
      pcs_S = data.frame(pca$x[,1:2])
    } else {
      quantitative = phe_cat[,!binary_phe_cols]
      qulitative = data.frame(sapply(phe_cat[,binary_phe_cols], as.factor))
      pca = PCAmix(X.quanti = quantitative, X.quali = qulitative , ndim = 2, rename.level = T, graph = F)
      pca_S = data.frame(pca$ind$coord)
    }
    cnames = c(cnames, paste(name, 1, sep = "_"), paste(name, 2, sep = "_"))
    if (length(final_pcs_data) == 0) {
      final_pca_data = pca_S
    } else {
      final_pca_data = cbind(final_pca_data, pca_S)
    }
  }
}

final_pca_data = cbind(phe[,1:2], final_pca_data)
colnames(final_pca_data) = c(colnames(phe)[1:2], cnames)

write.table(final_pca_data, file = "hub_phe_PCA.tsv", quote = F, row.names = F, sep = '\t')
