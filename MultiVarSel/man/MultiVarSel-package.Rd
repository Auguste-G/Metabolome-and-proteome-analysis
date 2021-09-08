\name{MultiVarSel-package}
\alias{MultiVarSel-package}
\alias{MultiVarSelect}
\docType{package}
\title{Package}
\description{
MultiVarSel consists of four functions: "whitening.R", "whitening_test.R",
"whitening_choice.R" and "variable_selection.R".
For further information on how to use these functions, 
we refer the reader to the vignette of the package.
}
\details{
This package consists of four functions: "whitening.R", "whitening_test.R",
"whitening_choice.R" and "variable_selection.R".
For further information on how to use these functions, 
we refer the reader to the vignette of the package.
}
\author{
Marie Perrot-Dockes, Celine Levy-Leduc, Julien Chiquet

Maintainer: Marie Perrot-Dockes <marie.perrocks@gmail.com>
}
\references{
M. Perrot-Dockes et al. "A multivariate variable selection approach 
for analyzing LC-MS metabolomics data", arXiv:1704.00076
}
\keyword{ package }

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
result=whitening_choice(residuals,c("AR1","nonparam","ARMA"),
                              pAR=1,qMA=1)
square_root_inv_hat_Sigma=whitening(residuals,"nonparam",
                            pAR=1,qMA=0)
Freqs=variable_selection(Y,X,square_root_inv_hat_Sigma,
                    nb_repli=5,parallel=FALSE,nb.cores=1)
\dontrun{
# Parallel computing
require(doMC)
registerDoMC(cores=4)
Freqs=variable_selection(Y,X,square_root_inv_hat_Sigma,
                    nb_repli=10,parallel=TRUE,nb.cores=4)
}                   
}
