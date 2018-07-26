//
// Created by konrad on 12.07.18.
//
#include <iostream>
#include "models/cov_utils.h"

int main() {
    int n = 3;
    cec::mahalanobis_dist_calculator mc(n);
    cec::mat cov(n, n);
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j)
            cov[i][j] = i * n + j;

    cec::vec mean(n);
    cec::vec x(n);
    for (int i = 0; i < n; ++i)
        mean[i] = 0.5 + ((double) i / 10.0);

    for (int i = 0; i < n; ++i)
        x[i] = 0.0 + ((double) i / 10.0);


    std::cout << cov;
    std::cout << mean;
    std::cout << x;
    std::cout << mc.mahalanobis2(cov, mean, x) << std::endl;

}
