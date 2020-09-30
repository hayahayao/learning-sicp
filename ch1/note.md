# Building Abstractions with Procedures

## The Elements of Programming

> A powerful programming language is more than just a means for instructing a computer ot perform tasks. The language also serves as a framework within which we organize our ideas about processes.

每个好的语言都需要实现以下三点：
- 基本表达式：语言的最简单实体（两种元素：过程（procedure）和数据（data））
- 组合：将简单元素组合成合成元素
- 抽象：将合成元素命名并作为单元进行操作

### Expressions

```scheme
1 ]=> (+ 2.7 10)
;Value: 12.7
```
一对**小括号**即为上述的**组合**。一个元素的操作符永远在最左侧，且这个元素的边界以小括号决定（所以可以一次操作多个参数，不止二元操作）（😯看起来很像函数耶）

### Naming and the Environment

```scheme
(define size 2)
```
**define** 是 scheme 中最简单的一种**抽象**（注意 define 不是组合，因为它不是在求值，而是把一个元素进行命名）

### Evaluating Combinations

给组合求值的过程如下：
1. 给组合的子表达式求值
2. 将最左侧的操作符作用于右边的操作数们
   
哦，自然的**递归**！

**tree accumulation**：自底向上给树状对象求值

### Compound Procedures

**procedure definition**：也是一种抽象，把一系列的复杂操作组合起来并命名

```scheme
(define (square x) (* x x))
(square 21)
;Value: 441
```

### The Substitution Model for Procedure Application

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

### Conditional Expressions and Predicates

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

### Example: Square Roots by Newton's Method

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

### Procedures as Black-Box Abstractions

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
