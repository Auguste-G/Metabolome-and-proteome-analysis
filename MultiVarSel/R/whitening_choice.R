whitening_choice <-
function (residuals,typeDeps='AR1',pAR=1,qMA=0)
{
  get_pvalue <- function(typeDep){
    
    
    square_root_inv_hat_Sigma=whitening(residuals,typeDep,pAR=pAR,qMA=qMA)
    whitened_residuals=residuals%*%square_root_inv_hat_Sigma
    pvalue=whitening_test(whitened_residuals)
    return(pvalue)
  }
  
  Pvals<-sapply(typeDeps,get_pvalue)
  Decision<-ifelse(Pvals<0.05,"NO WHITE NOISE","WHITE NOISE")
  names(Pvals)[which(names(Pvals)=='ARMA')]<-paste('ARMA',pAR,qMA,sep=' ')
  Result<-as.data.frame(cbind(Pvalue=round(Pvals,3),Decision))
  
  return(Result)
  
}
