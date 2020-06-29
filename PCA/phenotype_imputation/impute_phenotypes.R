library(mice)

set.seed(12345)

discrete_phe = read.table(file = "../data/discrete.phe", header = T)
continous_phe = read.table(file = "../data/continous.phe", header = T, stringsAsFactors = F)

keep_phes = read.csv(file = "../data/Reducted phenotypes for Hudson plot.csv")

discrete_phe = discrete_phe[,c(1,2,which(colnames(discrete_phe) %in% keep_phes$Variable.naming))]
continous_phe = continous_phe[,c(1,2,which(colnames(continous_phe) %in% keep_phes$Variable.naming))]

missingness = apply(discrete_phe, 2, function(x){sum(is.na(x)) / length(x) * 100})
colnames(discrete_phe)[!missingness < 60]
discrete_phe = discrete_phe[, missingness < 60]
missingness = apply(continous_phe, 2, function(x){sum(is.na(x)) / length(x) * 100})
colnames(continous_phe)[!missingness < 60]
continous_phe = continous_phe[, missingness < 60]

all_phes = c(colnames(discrete_phe), colnames(continous_phe))

replace_miss_phe_with_NA = function(x) {
  ret_phes = rep(NA, length(x) - 3)
  for (i in 4:length(x)) {
    if (x[i] %in% all_phes) {
      ret_phes[i - 3] = x[i]
    }
  }
  ret_phes = c(x[1], sum(!is.na(ret_phes)), x[3], ret_phes[order(ret_phes)])
  return(ret_phes)
}

input_m = continous_phe[,3:ncol(continous_phe)]
input_m = apply(continous_phe , 2, as.numeric) 
dm = mice(input_m, m = 1)
cd = complete(dm)

discrete_phe[,3:ncol(discrete_phe)] = discrete_phe[,3:ncol(discrete_phe)] - 1
input_m = discrete_phe[,3:ncol(discrete_phe)]
input_m = apply(input_m, 2, as.factor)
dm = mice(input_m, m = 1, maxit = 10)
dd = complete(dm)

phe = data.frame(cbind(discrete_phe[,1:2], cd, dd))
missingness = apply(phe, 2, function(x){sum(is.na(x)) / length(x) * 100})
phe = phe[,missingness == 0]

write.csv(phe, file = "phe_imputed.csv", quote = F, row.names = F)
