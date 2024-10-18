= Optimization

minimize or maximize depending on the context, there is alwasy a cost function and a decision x

== Gradient descent

== Denoising

Techniques base on total variation and also minimazion problems

// optimal trasnport

== On differentiability: of $f: RR --> RR$

Def: Let $I subset.eq RR$ be and interval of $RR$ a function $f : I --> RR$ is said to be differentiable at $x in I$ if $lim_(h -> 0) frac((f(x + h) -f(x)), h)$ exists. If this quantity exists, we call it derivative of $f$ at $x$ and denote it by $f'(x)$. If $f' : I --> RR$ is also continuous, we say that $f$ is of class $C^1$ on $I$. If $f' : I --> RR$ is continuous and differentiable, we say that $f$ is of class $C^k$ on $I$.

== Gradient of a function

Let $U subset.eq RR^n$ open subset.

$f : U --> RR, x = (x_1, ..., x_n) |--> f(x)$

For every $x in I$ the $i^("th")$ partial funciton is defined

$
  integral.cont_(i, x) : I --> RR, h |--> integral.cont_(i, x)(h) = f(x_1, ..., x_{i-1}, x_i + h, x_{i+1}, ..., x_n)
$

If $integral.cont_(i, x)$ is differentiable at $x_i forall i$, we say that $f$ is differentiable at $x$ and we denote it by $D f(x)$ or $gradient f(x)$.

== Jacobian of a mapping: $RR^m --> RR^n$

$U subset.eq RR^m --> RR^n, x = (x_1, ..., x_ n) |--> (c_1(x), ..., c_n(x))$ is said to be differentiable at $x$ if for every $i = 1, ..., n$, the function $c_i$ is differentiable ($frac((partial c_i), (partial x_j))(x)$ exists).

We define the Jacobian matrix $J(x)$ as the matrix whose $(i,j)$ entry is given by $frac((partial c_i),(partial x_j)(x))$.

== Chain rule

Let $f: U subset.eq RR^n --> RR^p$ and $g: V subset.eq RR^p --> RR^m$ be differentiable functions. Then the composition $g circle f: U --> RR^m$ is differentiable at $x$ and we have:

$gradient f circle g (x) = J_g(x)^T gradient f(g(x))$

== Hessian Matrix: $f: U subset.eq RR^n --> RR$

If $f$ is differentiable twice at $x$, the Hessian is defined as the matrix $H(x)$ whose $(i,j)$ entry is given by $frac((partial^2 f),((partial x_i)(partial x_j)))(x)$. The matrix is symmetric.