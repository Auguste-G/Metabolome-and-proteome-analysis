\name{variable_selection}
\alias{variable_selection}

\title{
Variable selection function.
}
\description{
This function allows the user to select the most relevant variables 
thanks the estimation of their selection frequencies obtained
by the stability selection approach. 
}
\usage{
variable_selection(Y, X, square_root_inv_hat_Sigma, 
            nb_repli = 1000, parallel=FALSE, nb.cores = 1)
}

\arguments{
  \item{Y}{
Observations matrix
}
  \item{X}{
Design matrix
}
  \item{square_root_inv_hat_Sigma}{
  Estimation of the inverse of the square root of the covariance matrix 
  of each row of the residuals matrix obtained by the whitening function.
}
  \item{nb_repli}{
Number of replications used in the stability selection step. 
}
  \item{parallel}{
If TRUE, parallel computing is performed in the cv.glmnet function. 
However, it requires the R package doMC which is not available on windows.
}
  \item{nb.cores}{
Number of cores to use for parallel computing.
}
}

\value{
A data frame containing the selection frequencies of the different variables 
obtained by the stability selection, the corresponding level in the design 
matrix and the associated column of the observations matrix.
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
Freqs=variable_selection(Y,X,square_root_inv_hat_Sigma,
                    nb_repli=10,parallel=FALSE,nb.cores=1)
}

