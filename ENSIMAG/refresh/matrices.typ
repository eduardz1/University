= Matrices

1. Vector spaces
2. Dimensions
  - ${v_1, ..., v_2}$ is called a span of $EE: forall x in EE, exists $
3. Norms: function that satisfies positivity
  1. non-negativity: $|| x || >= 0 forall x in EE$
  2. positive homogeneity
  3. triangle negativity
4. Inner Product: an inner product of $EE$ is
  1. $<.,.>: EE times EE -> B^+ $ st:
    1. Commutativity:
5. Column space:
  1. sum of column Matrices
  2. product of a constant with a column Vector
  3. The family ${e_1, ..., e_2}$ is called the canonical basis of $BB^n$
    1. The most used inner product in $RR^n: <x, y> = sum^n_(i=1)(x_i y_i)$
    2. The induced norm by scalar product is $||x||_2 = <x, x>^(1/2)$
    3. For $p >= 1, ||x||_p = (sum(|x_i|^p)^(1/p))$
6. Subsets of $BB^n$
  - The nonnegativity orthent of $BB^n: BB^n_+ = { (x_1, ..., x_n) in BB^n, x_i >= 0 forall i = 1, ..., n}$
7. The space of matrices
  1. If a square matrix $A in M_(n, n)$, its inverse if it exists satisfies: $A A^(-1) = A^(-1) A = I_n$
  2. A is invertible $<=> det(A) != 0$
8. Transpose of a matrix
9. Trace of a matrix
10. The dot product on $M_(m, n): <A,B> = "Tr"(A^T B) = sum_(i=1)^n sum_(j=1)^n (a_(i j) b_(i j))$
11. Special matrices, the determinand is just the porduct of all the diagonal elements $"det"(A) = Pi^n_(i = 1, j= 1) (a_(i j))$
  - Diagonal
  - Upper triangular
  - Lower tirangular (can be obtained as the traspose of an Upper triangular)
12. Subsets of $M_(m, n)$
  - symmetric matrices
  - positive semi-definite matrices $S_n^+$
  - orthogonal matrices

== Norms on spaces of matrices $M_(m, n)$

- Frobenius norms
- Induced norms
- 1-norm
- $inf$-norm

$ |(|| A |||_2)| = || A ||_(2, 2) = (lambda_max (A^T A))^(1/2) = sigma_max (A)$

== Linear systems

=== Reminders on linear systems

== Factorization

This is called forward step Ly, V is the backwards step

=== Chonsky Factorization

let $A in S^n_(++) => exists R "as upper triangular matrix st.:" A = B^T R $

== Eigenvalues and Eigenvectors

=== Eigenvalues decomposition (for symmetric matrices)

$P D P^T "where" P in O(n) and D in M_(n,n) "is diagonal"$

we have $D = "diag"(lambda_1, ..., lambda_n) and P = (P_1, ..., P_n)$

where $P_i$ is the eigenvector associated t $lambda_i$

1. if $lambda in $