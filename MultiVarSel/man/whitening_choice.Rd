\name{whitening_choice}
\alias{whitening_choice}

\title{
Whitening choice function.
}
\description{
This function helps to choose the best whitening strategy among the following 
types of dependence modellings: AR1, ARMA, non parametric and without any whitening.
}
\usage{
whitening_choice(residuals, typeDeps = "AR1", pAR = 1, qMA = 0)
}

\arguments{
  \item{residuals}{
Residuals of the classical linear model without taking into account the dependence 
between the columns of the observations matrix.
}
  \item{typeDeps}{
Dependence type which can be: "AR1", 
"no_whitening", "nonparam", "ARMA".
}
  \item{pAR}{
In the case where typeDep="ARMA" it corresponds to the parameter p of 
the ARMA(p,q) modelling.
}
  \item{qMA}{
In the case where typeDep="ARMA" it corresponds to the parameter q of 
the ARMA(p,q) modelling.
}
}

\value{
It provides a table given the p-values for the different whitening tests. When the 
p-value is smaller than 0.05 it means that
the white noise hypothesis of the test is rejected.
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
result=whitening_choice(residuals,c("AR1","nonparam","ARMA"),
                              pAR=1,qMA=1)
}

