variable_selection <-
function(Y,X,square_root_inv_hat_Sigma,nb_repli=1000,parallel=FALSE,nb.cores=1)
{
  p<-ncol(X)
  q<-ncol(Y)
  n<-nrow(Y)
  ## Vectorization to obtain a linear model
  Yvec=as.numeric(Y%*%square_root_inv_hat_Sigma)
  Xvec=kronecker(t(square_root_inv_hat_Sigma),X)
  
  ## 10-fold Cross-Validation method to choose lambda
  resultat_cv=cv.glmnet(Xvec,Yvec,family="gaussian",alpha=1,parallel=parallel)
  lambda_min=resultat_cv$lambda.min
  
  ## Stability Selection (it may take time if the number of replications is chosen very large and the number of
  ## core is not chosen high enough but it depends on your computer)
  stabsel.glmnet <- function(i) 
  { 
    b_sort <- sort(sample(1:(n*q),floor((n*q)/2)))
    resultat_glmnet=glmnet(Xvec[b_sort,],Yvec[b_sort],family="gaussian",alpha=1,lambda=lambda_min)
    ind_glmnet=which(resultat_glmnet$beta!=0)
    return(tabulate(ind_glmnet,(p*q)))
  }
  
  res.cum <- Reduce("+", mclapply(1:nb_repli, stabsel.glmnet, mc.cores=nb.cores))
  
  freq=res.cum/nb_repli
  if(is.null(colnames(Y))){colnames(Y)<-1:ncol(Y)}
  if(is.null(colnames(X))){colnames(X)<-1:ncol(X)}
  Freqs<-cbind(rep(colnames(Y),each=p),rep(colnames(X),q),as.data.frame(freq))
  names(Freqs) <- c('Names of the Columns of Y','Levels of the qualitative variable','frequency')
  
  return(Freqs)
}
