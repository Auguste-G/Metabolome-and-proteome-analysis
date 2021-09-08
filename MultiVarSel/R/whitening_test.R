whitening_test <-
function (residuals)
{
  n=dim(residuals)[1]
  q=dim(residuals)[2]
  ## Portmanteau test on each row of the residuals
  recup_stat<-function(k){
    acf_vect=acf(as.vector(residuals[k,]),type="correlation",plot=FALSE,lag.max=floor(sqrt(q)))$acf
    return(q*sum(acf_vect[2:length(acf_vect)]^2))
  }
  Stat<-sapply(1:n,recup_stat)
  pvalue=pchisq(sum(Stat),df=(floor(sqrt(q))*n),lower.tail=FALSE)
                
  return(pvalue) 
}
