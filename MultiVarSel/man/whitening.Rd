\name{whitening}
\alias{whitening}
\title{
Whitening function.
}
\description{
This function provides an estimation of the inverse of the square 
root of the covariance matrix of each line of the
residuals matrix.
}
\usage{
whitening(residuals, typeDep, pAR = 1, qMA = 0)
}
\arguments{
  \item{residuals}{
Residuals of the classical linear model without taking into account 
the dependence between the columns of the observations matrix.
}
  \item{typeDep}{
Dependence type which can be: "AR1", 
"no_whitening", "nonparam", "ARMA".
}
  \item{pAR}{
In the case where typeDep="ARMA" it corresponds to the parameter 
p of the ARMA(p,q) modelling.
}
  \item{qMA}{
In the case where typeDep="ARMA" it corresponds to the parameter 
q of the ARMA(p,q) modelling.
}
}

\value{
It returns the estimation of the inverse of the square root of the 
covariance matrix of each line of residuals.
}
\references{
M. Perrot-Dockes et al. "A multivariate variable selection approach 
for analyzing LC-MS metabolomics data", arXiv:1704.00076
}
\author{
M. Perrot-Dockes, C. Levy-Leduc, J. Chiquet
}

\examples{
data(copals_camera)
copals = copals_camera[copals_camera$Include == 1, -1]
Y  <- as.matrix(copals[, -(1:2)])
X1 <- copals[,   1]
X2 <- copals[,   2]
rm <- which(is.element(X1,c("1155","1551")))
Y <- Y[-rm, ]  
X1 <- X1[-rm]
X1 <- factor(as.character(X1))
X2 <- X2[-rm]
X2 <- factor(as.character(X2))
X <- model.matrix(lm(Y ~ X2 + 0))
Yscaled=scale(Y)
Y=Yscaled[,1:100]
residuals=lm(as.matrix(Y)~X-1)$residuals
square_root_inv_hat_Sigma=whitening(residuals,"AR1",
                            pAR=1,qMA=0)
}
