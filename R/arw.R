.arw <- function (x, m0, c0, alpha, pcrit, ...){
  
  n <- nrow(x)
  p <- ncol(x)
  if (missing(pcrit)) {
    if (p <= 10) 
      pcrit <- (0.24 - 0.003 * p)/sqrt(n)
    if (p > 10) 
      pcrit <- (0.252 - 0.0018 * p)/sqrt(n)
  }
  if (missing(alpha)) 
    delta <- qchisq(0.975, p)
  else delta <- qchisq(1 - alpha, p)
  d2 <- mahalanobis(x, m0, c0)
  d2ord <- sort(d2)
  dif <- pchisq(d2ord, p) - (0.5:n)/n
  i <- (d2ord >= delta) & (dif > 0)
  if (sum(i) == 0) 
    alfan <- 0
  else alfan <- max(dif[i])
  if (alfan < pcrit) 
    alfan <- 0
  if (alfan > 0) 
    cn <- max(d2ord[n - ceiling(n * alfan)], delta)
  else cn <- Inf
  w <- d2 < cn
  if (sum(w) == 0) {
    m <- m0
    c <- c0
  }
  else {
    m <- apply(x[w, ], 2, mean)
    c1 <- as.matrix(x - rep(1, n) %*% t(m))
    c <- (t(c1) %*% diag(w) %*% c1)/sum(w)
  }
  list(m = m, c = c, cn = cn, w = w)

}
