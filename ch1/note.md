# 1 Building Abstractions with Procedures

## 1.1 The Elements of Programming

> A powerful programming language is more than just a means for instructing a computer ot perform tasks. The language also serves as a framework within which we organize our ideas about processes.

每个好的语言都需要实现以下三点：
- 基本表达式：语言的最简单实体（两种元素：过程（procedure）和数据（data））
- 组合：将简单元素组合成合成元素
- 抽象：将合成元素命名并作为单元进行操作

### 1.1.1 Expressions

```scheme
1 ]=> (+ 2.7 10)
;Value: 12.7
```
一对**小括号**即为上述的**组合**。一个元素的操作符永远在最左侧，且这个元素的边界以小括号决定（所以可以一次操作多个参数，不止二元操作）（😯看起来很像函数耶）

### 1.1.2 Naming and the Environment

```scheme
(define size 2)
```
**define** 是 scheme 中最简单的一种**抽象**（注意 define 不是组合，因为它不是在求值，而是把一个元素进行命名）

### 1.1.3 Evaluating Combinations

给组合求值的过程如下：
1. 给组合的子表达式求值
2. 将最左侧的操作符作用于右边的操作数们
   
哦，自然的**递归**！

**tree accumulation**：自底向上给树状对象求值

### 1.1.4 Compound Procedures

**procedure definition**：也是一种抽象，把一系列的复杂操作组合起来并命名

```scheme
(define (square x) (* x x))
(square 21)
;Value: 441
```

### 1.1.5 The Substitution Model for Procedure Application

**substitution model**（替换模型）：

> To apply a compound procedure to arguments, evaluate the body of the procedure with each formal parameter replaced by the corresponding argument.

描述了 procedure 求值的过程，简单来说就是不断替换形参直到求出值（注意，只是为了理解方便，实际的解释器不是这样工作的，而是给形参建立局部环境...）

- normal-order evaluation：完全展开然后自底向上求值，需要时才会被求值。"fully expand and then reduce"
- applicative-order evaluation：lisp 解释器实际的工作方式，立即求值并替换。"evaluate the arguments and then apply"

```scheme
;normal-order evaluation，我们看到这里 (+ 5 1) 会被求值两次
(sum-of-squares (+ 5 1) (* 5 2))

(+ (square (+ 5 1))
   (square (* 5 2)))

(+ (* (+ 5 1) (+ 5 1))
   (* (* 5 2) (* 5 2)))

;applicative-order evaluation，遇到能求值的就求出来替换掉，而不是一直带着带到底
(sum-of-squares (+ 5 1) (* 5 2))

(+ (square 6) (square 10))

(+ (* 6 6) (* 10 10))
```

### 1.1.6 Conditional Expressions and Predicates

**case analysis**

```scheme
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))
```

求值顺序从上到下，先判断符不符合第一个条件再判断第二个...

- **predicate**：条件
- **expression**：符合条件时要执行的语句

```scheme
;else的写法
(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

;类似三元表达式
(define (abs x)
  (if (< x 0)
      (- x)
      x))
```

逻辑符 `and or not`（注意 and 和 or 其实不是 procedure，因为它们的定义就不是要求出所有子表达式的值再返回，而 not 是普通的 procedure）

```scheme
;自己定义 predicate
(define (>= x y)
  (or (> x y) (= x y)))
```

### 1.1.7 Example: Square Roots by Newton's Method

> In mathematics we are usually concerned with declarative (what is) descriptions, whereas in computer science we are usually concerned with imperative (how to) descriptions.

牛顿法开平方根

```scheme
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x) x)))
(define (improve guess x)
  (average guess (/ x guess)))
(define (average x y)
  (/ (+ x y) 2))
(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
;entrance
(define (sqrt x)
  (sqrt-iter 1.0 x))
```

哇哦，没有循环，而是 procedure 之间的互相调用

### 1.1.8 Procedures as Black-Box Abstractions

黑箱抽象

> A procedure definition should be able to suppress detail. A user should not need to know how the procedure is implemented in order to use it.

- **bound variable**：形参的名字。我们称一个 procedure 的定义**绑定**了它的形参。
- **free variable**：没有绑定的变量（也就是非形参，函数内部自己定义的一些变量/全局变量）

**block structure**，将辅助函数/变量定义在内部，对外只暴露一个 sqrt 函数

```scheme
(define (sqrt x)
  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess x)
    (average guess (/ x guess)))
  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))
  (sqrt-iter 1.0 x))
```

**lexical scoping**

上述的定义其实 x 都是一个，那么直接在 sqrt 的词法作用域里找 x 就行了

```scheme
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))
```

## 1.2 Procedures and the Processes They Generate

### 1.2.1 Liner Recursion and Iteration

- **recursive process**：递归过程。特征是一系列的延迟操作
- **linear recursive process**：线性递归，递归栈的规模随 n 线性增长

- **iterative process**：迭代过程
- **linear iterative process**

每次迭代都提供了足够的参数描述当前状态，所以可以中止可以通过记录参数保存当前状态；但递归有一些隐含的信息（在解释器中，而不是在程序的变量中）

递归和迭代的本质区别在于实际运行时是如何运行的，而不是语法上调用了自身就是递归。但是很多语言的实现中都是把语法递归直接处理成递归栈...但是 Scheme 会把语法递归但实际迭代的程序处理成常数空间的正常迭代（可以通过尾递归优化来实现，尾递归这种写法本质上就是个语法糖，告诉解释器去按迭代处理）

```scheme
;一个语法上是递归但实际运行是迭代的栗子
;因为每次我们都给 fact-iter 提供了足够的参数表示状态，它不依赖上下的结果，这些参数也是用完这次就可以扔了
(define (factorial n)
  (fact-iter 1 1 n))
(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))
```

### 1.2.2 Tree Recursion

规模随 n 指数增长（2^n）

### 1.2.3 Orders of Growth

复杂度计算

### 1.2.4 Exponentiation

直觉的幂运算

```scheme
;递归版本，空间和时间复杂度都为 o(n)
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
;迭代版本，空间复杂度降为 o(1)
(define (expt b n)
  (expt-iter b n 1))
(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b
                 (- counter 1)
                 (* b product))))
```

改进：**successive squaring**（b^8 = b^4 * b^4）

```scheme
;时间和空间复杂度都降为 o(lgn)
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n)
         (square (fast-expt b (/ n 2))))
        (else
         (* b (fast-expt b (- n 1))))))
```

### 1.2.5 Greatest Common Divisors

最大公约数GCD 欧几里得算法（o(lgn)）

```scheme
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
```

### 1.2.6 Example: Testing for Primality

检查一个数是否为质数

方法1：找出 n 的约数，复杂度为 o(n^(1/2))

```scheme
(define (smallest-divisor n) ;find the smallest divisor of n
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n)
         n)
        ((divides? test-divisor n)
         test-divisor)
        (else (find-divisor
               n
               (+ test-divisor 1)))))
(define (divides? a b) ;b能否整除a
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
```

方法2：The Fermat test，复杂度为 o(lgn)

基于费马小定理...

> 如果 n 是素数且 a 是任意小于 n 的正整数，则 a^n 与 a 模 n 同余。

采用以下算法：对于一个 n，随机选取一个 a < n 并计算 a^n 模 n 的余数，如果这个余数不等于 a（即 a 模 n 的余数就是 a 本身），那么这个数不是质数，否则继续测试...

这是个**概率算法**，概率算法存在的意义在于它可以由人控制错误概率到任意小

```scheme
;用了 successive squaring
;(((a^n) mod m) * a) mod m = (a^(n+1)) mod m
;((a^n) mod m)^2 mod m = (a^(2n)) mod m
(define (expmod base exp m) ;calculate (base^exp) mod m
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder
          (* base (expmod base (- exp 1) m))
          m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n)
         (fast-prime? n (- times 1)))
        (else false)))
```
