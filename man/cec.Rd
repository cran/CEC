% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cec.R
\name{cec}
\alias{cec}
\alias{cec-class}
\title{Cross-Entropy Clustering}
\usage{
cec(
  x,
  centers,
  type = c("covariance", "fixedr", "spherical", "diagonal", "eigenvalues", "mean", "all"),
  iter.max = 25,
  nstart = 1,
  param,
  centers.init = c("kmeans++", "random"),
  card.min = "5\%",
  keep.removed = FALSE,
  interactive = FALSE,
  threads = 1,
  split = FALSE,
  split.depth = 8,
  split.tries = 5,
  split.limit = 100,
  split.initial.starts = 1,
  readline = TRUE
)
}
\arguments{
\item{x}{A numeric matrix of data. Each row corresponds to a distinct
observation; each column corresponds to a distinct variable/dimension. It
must not contain \code{NA} values.}

\item{centers}{Either a matrix of initial centers or the number of initial
 centers (\code{k}, single number \code{cec(data, 4, ...)}) or a vector for
 variable number of centers (\code{cec(data, 3:10, ...)}). It must not
 contain \code{NA} values.

 If \code{centers} is a vector, \code{length(centers)} clusterings will be
 performed for each start (\code{nstart} argument) and the total number of
 clusterings will be \code{length(centers) * nstart}.

 If \code{centers} is a number or a vector, initial centers will be generated
 using a method depending on the \code{centers.init} argument.}

\item{type}{The type (or types) of clustering (density family). This can be
 either a single value or a vector of length equal to the number of centers.
 Possible values are: "covariance", "fixedr", "spherical", "diagonal",
 "eigenvalues", "all" (default).

 Currently, if the \code{centers} argument is a vector, only a single type can
 be used.}

\item{iter.max}{The maximum number of iterations of the clustering algorithm.}

\item{nstart}{The number of clusterings to perform (with different initial
 centers). Only the best clustering (with the lowest cost) will be returned.
 A value grater than 1 is valid only if the \code{centers} argument is a
 number or a vector.

 If the \code{centers} argument is a vector, \code{length(centers)}
 clusterings will be performed for each start and the total number of
 clusterings will be \code{length(centers) * nstart}.

 If the split mode is on (\code{split = TRUE}), the whole procedure (initial
 clustering + split) will be performed \code{nstart} times, which may take
 some time.}

\item{param}{The parameter (or parameters) specific to a particular type of
clustering. Not all types of clustering require parameters. The types that
require parameter are: "covariance" (matrix parameter), "fixedr" (numeric
parameter), "eigenvalues" (vector parameter). This can be a vector or a list
(when one of the parameters is a matrix or a vector).}

\item{centers.init}{The method used to automatically initialize the centers.
Possible values are: "kmeans++" (default) and "random".}

\item{card.min}{The minimal cluster cardinality. If the number of
observations in a cluster becomes lower than card.min, the cluster is
removed. This argument can be either an integer number or a string ending
with a percent sign (e.g. "5\%").}

\item{keep.removed}{If this parameter is TRUE, the removed clusters will be
visible in the results as NA in the "centers" matrix (as well as the
corresponding values in the list of covariances).}

\item{interactive}{If \code{TRUE}, the result of clustering will be plotted after
every iteration.}

\item{threads}{The number of threads to use or "auto" to use the default
 number of threads (usually the number of available processing units/cores)
 when performing multiple starts (\code{nstart} parameter).

 The execution of a single start is always performed by a single thread, thus
 for \code{nstart = 1} only one thread will be used regardless of the value
 of this parameter.}

\item{split}{If \code{TRUE}, the function will attempt to discover new
 clusters after the initial clustering, by trying to split single clusters
 into two and check whether it lowers the cost function.

 For each start (\code{nstart}), the initial clustering will be performed and
 then splitting will be applied to the results. The number of starts in the
 initial clustering before splitting is driven by the
 \code{split.initial.starts} parameter.}

\item{split.depth}{The cluster subdivision depth used in split mode. Usually,
a value lower than 10 is sufficient (when after each splitting, new clusters
have similar sizes). For some data, splitting may often produce clusters
that will not be split further, in that case a higher value of
\code{split.depth} is required.}

\item{split.tries}{The number of attempts that are made when trying to split
a cluster in split mode.}

\item{split.limit}{The maximum number of centers to be discovered in split
mode.}

\item{split.initial.starts}{The number of 'standard' starts performed before
starting the splitting process.}

\item{readline}{Used only in the interactive mode. If \code{readline} is
TRUE, at each iteration, before plotting it will wait for the user to press
<Return> instead of the standard 'before plotting' waiting
(\code{graphics::par(ask = TRUE)}).}
}
\value{
An object of class \code{cec} with the following attributes:
 \code{data}, \code{cluster}, \code{probability}, \code{centers},
 \code{cost.function}, \code{nclusters}, \code{iterations}, \code{cost},
 \code{covariances}, \code{covariances.model}, \code{time}.
}
\description{
\code{cec} performs Cross-Entropy Clustering on a data matrix. 
 See \code{Details} for an explanation of Cross-Entropy Clustering.
}
\details{
Cross-Entropy Clustering (CEC) aims to partition \emph{m} points
 into \emph{k} clusters so as to minimize the cost function (energy
 \emph{\strong{E}} of the clustering) by switching the points between
 clusters. The presented method is based on the Hartigan approach, where we
 remove clusters which cardinalities decreased below some small prefixed
 level.

 The energy function \emph{\strong{E}} is given by:

 \deqn{E(Y_1,\mathcal{F}_1;...;Y_k,\mathcal{F}_k) = \sum\limits_{i=1}^{k}
 p(Y_i) \cdot (-ln(p(Y_i)) + H^{\times}(Y_i\|\mathcal{F}_i))}{ E(Y1, F1; ...;
 Yk, Fk) = \sum(p(Yi) * (-ln(p(Yi)) + H(Yi | Fi)))}

 where \emph{Yi} denotes the \emph{i}-th cluster, \emph{p(Yi)} is the ratio
 of the number of points in \emph{i}-th cluster to the total number points,
 \emph{\strong{H}(Yi|Fi)} is the value of cross-entropy, which represents the
 internal cluster energy function of data \emph{Yi} defined with respect to a
 certain Gaussian density family \emph{Fi}, which encodes the type of
 clustering we consider.

 The value of the internal energy function \emph{\strong{H}} depends on the
 covariance matrix (computed using maximum-likelihood) and the mean (in case
 of the \emph{mean} model) of the points in the cluster. Seven
 implementations of \emph{\strong{H}} have been proposed (expressed as a type
 - model - of the clustering):

 \describe{
  \item{"all": }{All Gaussian densities. Data will form ellipsoids with
  arbitrary radiuses.}
  \item{"covariance": }{Gaussian densities with a fixed given covariance. The
  shapes of clusters depend on the given covariance matrix (additional
  parameter).}
  \item{"fixedr": }{Special case of 'covariance', where the covariance matrix
  equals \emph{rI} for the given \emph{r} (additional parameter). The
  clustering will have a tendency to divide data into balls with approximate
  radius proportional to the square root of \emph{r}.}
  \item{"spherical": }{Spherical (radial) Gaussian densities (covariance
  proportional to the identity). Clusters will have a tendency to form balls
  of arbitrary sizes.}
  \item{"diagonal": }{Gaussian densities with diagonal covariane. Data will
  form ellipsoids with radiuses parallel to the coordinate axes.}
  \item{"eigenvalues": }{Gaussian densities with covariance matrix having
  fixed eigenvalues (additional parameter). The clustering will try to divide
  the data into fixed-shaped ellipsoids rotated by an arbitrary angle.}
  \item{"mean": }{Gaussian densities with a fixed mean. Data will be covered
  with ellipsoids with fixed centers.}
 }

 The implementation of \code{cec} function allows mixing of clustering types.
}
\examples{
## Example of clustering a random data set of 3 Gaussians, with 10 random
## initial centers and a minimal cluster size of 7\% of the total data set.

m1 <- matrix(rnorm(2000, sd = 1), ncol = 2)
m2 <- matrix(rnorm(2000, mean = 3, sd = 1.5), ncol = 2)
m3 <- matrix(rnorm(2000, mean = 3, sd = 1), ncol = 2)
m3[,2] <- m3[, 2] - 5
m <- rbind(m1, m2, m3)

plot(m, cex = 0.5, pch = 19)

## Clustering result:
Z <- cec(m, 10, iter.max = 100, card.min = "7\%")
plot(Z)

# Result:
Z

## Example of clustering mouse-like set using spherical Gaussian densities.
m <- mouseset(n = 7000, r.head = 2, r.left.ear = 1.1, r.right.ear = 1.1,
left.ear.dist = 2.5, right.ear.dist = 2.5, dim = 2)
plot(m, cex = 0.5, pch = 19)
## Clustering result:
Z <- cec(m, 3, type = 'sp', iter.max = 100, nstart = 4, card.min = '5\%')
plot(Z)
# Result:
Z

## Example of clustering data set 'Tset' using 'eigenvalues' clustering type.
data(Tset)
plot(Tset, cex = 0.5, pch = 19)
centers <- init.centers(Tset, 2)
## Clustering result:
Z <- cec(Tset, 5, 'eigenvalues', param = c(0.02, 0.002), nstart = 4)
plot(Z)
# Result:
Z

## Example of using cec split method starting with a single cluster.
data(mixShapes)
plot(mixShapes, cex = 0.5, pch = 19)
## Clustering result:
Z <- cec(mixShapes, 1, split = TRUE)
plot(Z)
# Result:
Z

}
\references{
Spurek, P. and Tabor, J. (2014) Cross-Entropy Clustering
 \emph{Pattern Recognition} \bold{47, 9} 3046--3059
}
\seealso{
\code{\link{CEC-package}}, \code{\link{plot.cec}}, 
 \code{\link{print.cec}}
}
\keyword{cluster}
\keyword{models}
\keyword{multivariate}
\keyword{package}
