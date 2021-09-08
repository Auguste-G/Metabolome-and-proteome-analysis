### R code from vignette source 'MultiVarSel.Rnw'

###################################################
### code chunk number 1: MultiVarSel.Rnw:40-41
###################################################
options(width=60)


###################################################
### code chunk number 2: loadparameters
###################################################
library(MultiVarSel)


###################################################
### code chunk number 3: loaddata
###################################################
data("copals_camera")
dim(copals_camera)
#### We limit ourselves to the following data
copals = copals_camera[copals_camera$Include == 1, -1]


###################################################
### code chunk number 4: extraction
###################################################
Y  <- as.matrix(copals[, -(1:2)])
X1 <- copals[,   1]
X2 <- copals[,   2]


###################################################
### code chunk number 5: remove
###################################################
rm <- which(X1 %in% c("1155","1551"))
Y <- Y[-rm, ]  
X1 <- X1[-rm]; X1 <- factor(as.character(X1))
X2 <- X2[-rm]; X2 <- factor(as.character(X2))


###################################################
### code chunk number 6: table
###################################################
table(X1,X2)
## -> X1 is useless => We have a one-way MANOVA model with 3 levels


###################################################
### code chunk number 7: design
###################################################
X <- model.matrix(lm(Y ~ X2 + 0))
p <- ncol(X)
n=nrow(X)
n
q=dim(Y)[2] 
q


###################################################
### code chunk number 8: scale
###################################################
Yscaled=scale(Y)
Y=Yscaled


###################################################
### code chunk number 9: truncate
###################################################
Y=Y[,1:200]


###################################################
### code chunk number 10: residuals
###################################################
residuals=lm(as.matrix(Y)~X-1)$residuals


###################################################
### code chunk number 11: test
###################################################
pvalue=whitening_test(residuals)
pvalue


###################################################
### code chunk number 12: whitheningchoice
###################################################
result=whitening_choice(residuals,c("AR1","nonparam","ARMA"),pAR=1,qMA=1)
result


###################################################
### code chunk number 13: sigmahat
###################################################
 square_root_inv_hat_Sigma=whitening(residuals,"nonparam",pAR=1,qMA=0)


###################################################
### code chunk number 14: variable_selection
###################################################
  Frequencies=variable_selection(Y,X,square_root_inv_hat_Sigma,
                                 nb_repli=100,parallel=FALSE)


###################################################
### code chunk number 15: variable_selection (eval = FALSE)
###################################################
## require(doMC)
## registerDoMC(cores=4)
## Freqs=variable_selection(Y,X,square_root_inv_hat_Sigma,
##                     nb_repli=10,parallel=TRUE,nb.cores=4)


###################################################
### code chunk number 16: figure1
###################################################
colnames(Frequencies)<-c('Names_of_Y','Names_of_X','frequency')
# Here we can consider the names of Y as numerical since they correspond 
# to the ratio m/z of the metabolites.
Frequencies$Names_of_X<-sub('X2','',Frequencies$Names_of_X)
Frequencies$Names_of_Y<-as.numeric(gsub('X','',gsub('\\.1$','',Frequencies$Names_of_Y)))
p<-ggplot(data=Frequencies[Frequencies$frequency>=0.95,],
          aes(x=Names_of_Y,y=Names_of_X,color=frequency))+
          geom_tile(size=0.75)+scale_color_gradient2(midpoint=0.95,mid ='orange')+
          theme_bw()+ylab('Levels of X')+xlab('m/z')
p


###################################################
### code chunk number 17: figure2
###################################################
p<-ggplot(data=Frequencies[Frequencies$frequency==1,],
          aes(x=Names_of_Y,y=Names_of_X,color=Names_of_X))+
          geom_point(size=1)+theme_bw()+ylab('Levels of X')+xlab('m/z')
p


###################################################
### code chunk number 18: sessionInfo
###################################################
sessionInfo()


