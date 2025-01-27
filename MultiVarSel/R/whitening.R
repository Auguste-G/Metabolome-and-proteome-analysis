whitening <-
function(residuals,typeDep,pAR=1,qMA=0)
{
  n=dim(residuals)[1]
  q=dim(residuals)[2]
  
  if (typeDep=="no_whitening")
  {
    return (Diagonal(q,1))
  } 
  
  if (typeDep=="AR1")
  {
    phi_hat=c()
    for (i in 1:n)
    {
      phi_hat[i]=arima(residuals[i,],order=c(1,0,0))$coef[1]
    }
    phi_hat_final=mean(phi_hat)
    
    phi_hat_vect=rep(-phi_hat_final,(q-1))
    square_root_inv_hat_Sigma=bandSparse(q,k=c(1,0),diagonals=list(phi_hat_vect,c(sqrt(1-phi_hat_final^2),rep(1,(q-1)))))
    return (square_root_inv_hat_Sigma)  
  }
  
  if (typeDep=="ARMA")
  {
    phi_hat=matrix(0,n,max(pAR,1));theta_hat=matrix(0,n,max(qMA,1))
    if ((pAR>=1)&&(qMA>=1))
    {
      for (i in 1:n)
      {
        phi_hat[i,]=arima(residuals[i,],order=c(pAR,0,qMA))$coef[1:pAR]
        theta_hat[i,]=arima(residuals[i,],order=c(pAR,0,qMA))$coef[(pAR+1):(pAR+qMA)]
      }
    }
    if ((pAR>=1)&&(qMA==0))
    {
      for (i in 1:n)
      {
        phi_hat[i,]=arima(residuals[i,],order=c(pAR,0,qMA))$coef[1:pAR]
      }
    }
    if ((pAR==0)&&(qMA>=1))
    {
      for (i in 1:n)
      {
        theta_hat[i,]=arima(residuals[i,],order=c(pAR,0,qMA))$coef[(pAR+1):(pAR+qMA)]
      }
    }
    phi_hat_final=colMeans(phi_hat);theta_hat_final=colMeans(theta_hat)
  
    acf_theo_hat=ARMAacf(ar=phi_hat_final,ma=theta_hat_final,lag.max=(q-1))  ### autocorrelation function
    psi_hat=ARMAtoMA(ar=phi_hat_final,ma=theta_hat_final,1000)  ### computation of the (psi_k)_{k>=1} coefficients to compute the variance : 1+sum(psi_k^2)
    variance_hat=1+sum(psi_hat^2)
    Sigma_hat=toeplitz(acf_theo_hat)*variance_hat
    square_root_inv_hat_Sigma=Matrix(round(solve(chol(Sigma_hat)),digits=6))
    return (square_root_inv_hat_Sigma)
  }
  
  if(typeDep=="nonparam")
  {   
    vector_cov=matrix(0,n,q)
    for (i in 1:n)
    {
      vector_cov[i,]=acf(residuals[i,],type="covariance",plot=FALSE,lag.max=(q-1))$acf
    }
    vector_cov_estim=colMeans(vector_cov)
    cov_matrix=toeplitz(vector_cov_estim)
    square_root_inv_hat_Sigma=Matrix(round(solve(chol(cov_matrix)),digits=6))
    return (square_root_inv_hat_Sigma)
  }
  
}
