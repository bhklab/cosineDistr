library(cosineDistr)


makeTheoryPlots <- function(outdir = ".", figdir ="."){

  #### Case 1 simulation: Run cosineDistSpherical 
  if (!file.exists(file.path(outdir, "simulCase1CosVsDim.rds"))){
    cosDim <- cosineDistSpherical(ndim=seq(1000))
    cosDim$theoryVar <- 1/cosDim$dim
    saveRDS(cosDim, file.path(outdir, "simulCase1CosVsDim.rds"))
  } else {
    cosDim <- readRDS(file.path(outdir, "simulCase1CosVsDim.rds"))
  }
  
  pdf(file.path(figdir, "simulCase1CosVsDim.pdf"), width=6, height=6)
  print(ggplot(cosDim, aes(x=sd^2, y=theoryVar, color=dim)) + geom_point() + theme_minimal() + 
    scale_x_continuous(trans="log10") + scale_y_continuous(trans="log10") + xlab("Observed variance") + 
    ylab("Theoretical variance") + ggtitle("Variance of cosine similarity for multivariate standard normals") + 
    geom_abline(slope = 1, intercept=0, lty=2, col="grey") + 
    guides(color=guide_legend(title="Dimension")))
  dev.off()

  #### Approximation of normal length simulation
  
  # Load the latest version from H4H; placeholder
  if (!file.exists(file.path(outdir, "simulCase2NormLength_iter=3_distiter=10.rds"))){
    nLen <- cosineDistr::getNormalLength(ndim=c(seq(100, 1000, 100), seq(1500, 3000, 500)), iter=3, distiter = 10)
    saveRDS(nLen, file.path(outdir, "simulCase2NormLength_iter=3_distiter=10.rds"))
  } else {
    nLen <- readRDS(file.path(outdir, "simulCase2NormLength_iter=3_distiter=10.rds"))
  }
  
  
  pdf(file.path(figdir, "simulCase2MeanLengthConvergence.pdf"), width=6, height=6)
  print(ggplot(nLen, aes(x=ndim, y=meanLen/theoryLength)) + geom_point(col="royalblue4") + theme_minimal() + xlab("Dimension") + 
    ylab("Mean Length / Theory") + ggtitle("Approximation of Length of multivariate normal vectors") + 
    ylim(c(0.9, 1.05)) + geom_hline(yintercept=1, lty=2, col="grey"))
  dev.off()
  
  pdf(file.path(figdir, "simulCase2sdLenConvergence.pdf"), width=6, height=6)
  print(ggplot(nLen, aes(x=ndim, y=sdLen/meanLen)) + geom_point(col="orangered3") + theme_minimal() + xlab("Dimension") +
    ylab("SD Length / Mean Length") + ggtitle("Convergence of SD Length/Mean Length for multivariate normal vectors"))
  dev.off()
  
  
  #### Case 2 simulation
  
  #### Case 3 simulation
  if (!file.exists(file.path(outdir, "simulCase3CosVsDim.rds"))){
    gVar2 <- sampleGenVarCos(iter=1, distiter=100)
    saveRDS(gVar2, file.path(outdir, "simulCase3CosVsDim.rds"))
  } else {
    gVar2 <- readRDS(file.path(outdir, "simulCase3CosVsDim.rds"))
  }
  
  pdf(file.path(figdir, "simulCase3CosVsDim.pdf"), width=6, height=6)
  print(ggplot(gVar2, aes(x=-log10(obsVar), y=-log10(theoryVar), color=as.factor(ndim))) + geom_point() + 
    xlim(c(0, 12)) + ylim(c(0,12)) + geom_abline(intercept=0, slope=1, col="grey", lty=2) + 
    theme_minimal() + xlab("-Log10 Observed Variance") + ylab("-Log10 Theoretical Variance") + 
    ggtitle(sprintf("Case 3 Variance simulation, Pearson = %0.4f", cor(gVar2$obsVar, gVar2$theoryVar))) + 
    guides(color=guide_legend(title="Dimension")))
  dev.off()
  
  pdf(file.path(figdir, "simulCase3CosVsDimLinear.pdf"), width=6, height=6)
  print(ggplot(gVar2, aes(x=obsVar, y=theoryVar, color=as.factor(ndim))) + geom_point() + 
    xlim(c(0, 0.061)) + ylim(c(0,0.061)) + geom_abline(intercept=0, slope=1, col="black", lty=2) + 
    theme_minimal() + xlab("Observed Variance") + ylab("Theoretical Variance") + 
    ggtitle(sprintf("Case 3 Variance simulation, Pearson = %0.4f", cor(gVar2$obsVar, gVar2$theoryVar))) + 
    guides(color=guide_legend(title="Dimension")))
  dev.off()

}
