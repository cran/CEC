print.cec <- function(x, ...)
{
    cat("CEC clustering result: \n")
    cat("\nProbability vector:\n")
    print(x$probability)
    cat("\nMeans of clusters:\n")
    print(x$centers)
    cat("\nCost function:\n")
    print(x$cost)  
    cat("\nNumber of clusters:\n")
    print(x$nclusters)  
    cat("\nNumber of iterations:\n")
    print(x$iterations)
    cat("\nComputation time:\n")
    print(x$time)
    cat("\nAvailable components:\n")
    print(c("data", "cluster", "probabilities", "centers", "cost.function", "nclusters", "iterations", "covariances", "covariances.model", "time" ))
}
