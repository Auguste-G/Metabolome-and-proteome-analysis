\name{whitening_test}
\alias{whitening_test}

\title{
Whitening test function.
}
\description{
This function provides the p-value of an adaptation of the Portmanteau 
statistic to test if there is some dependence in the
rows of the residuals matrix given as an argument of the function.
}
\usage{
whitening_test(residuals)
}

\arguments{
  \item{residuals}{
Residuals of the classical linear model or whitened residuals.
}
}

\value{
p-value
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
pvalue=whitening_test(residuals)
}

