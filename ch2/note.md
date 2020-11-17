# 2 Building Abstractions with Data

construct **compound data** objects:
- 提高设计程序的概念层级
- 提高设计的模块化
- 增强语言的表现力

**data abstraction**：将 数据对象如何表示（如何由原始数据对象组成） 与 如何使用数据对象 分离

## 2.1 Introduction to Data Abstraction

### 2.1.1 Example: Arithmetic Operations for Rational Numbers

假定我们有以下 constructor & selector:

- `(make-rat <n> <d>)` 返回分子为 n 分母为 d 的有理数
- `(numer <n>)` 返回有理数 x 的分子
- `(denom <x>)` 返回有理数 x 的分母

那我们可以定义加减乘除操作如下

```scheme
(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))
(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))
(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))
```

接下来就是如何定义 make-rat numer denom

```scheme
;pair
(define x (cons 1 2))
(car x) ;1
(cdr x) ;2
```

cons 把两个参数组合成一个新的 data object，称作 pair，可以通过 car 和 cdr 访问两个元素（cons 称作构造器，car/cdr 称作选择器）。由 pair 组合成的 data object 称作 **list-structured** data

```scheme
(define (make-rat n d) (cons n d))
(define (numer x) (car x))
(define (denom x) (cdr x))
```

### 2.1.2 Abstraction Barriers

> In general, the underlying idea of data abstraction is to identify for each type of data object a basic set of operations in terms of which all manipulations of data objects of that type will be expressed, and then to use only those operations in manipulating the data.

嗯，就是把数据和操作封装起来的意思，之后就只通过接口去操作数据..从而可以形成分层的抽象，层与层之间通过接口沟通...设计的时候要考虑哪个操作放在哪一层，分的不好的话就会造成改动/debug都比较费劲..

### 2.1.3 What Is Meant by Data?

> In general, we can think of data as defined by some collection of selectors and constructors, together with specified conditions that these procedures must fulfill in order to be a valid representation.

```scheme
;our own cons
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1: CONS" m))))
  dispatch) ;注意，cons返回的是个函数
(define (car z) (z 0))
(define (cdr z) (z 1))
```

当然，Lisp 实际不是这样运行 cons 的（出于效率考虑，Lisp 直接实现，更加高效），但是我们看到 it could work this way，从而说明*将函数视作对象的能力自动提供了表示组合数据的能力（the ability to manipulate procedures as objects automatically provides the ability to represent compound data）*。

### 2.1.4 Extended Exercise: Interval Arithmetic

```scheme
(define (add-interval x y)
  (make-interval (+ (lower-bound x)
                    (lower-bound y))
                 (+ (upper-bound x)
                    (upper-bound y))))
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x)
               (lower-bound y)))
        (p2 (* (lower-bound x)
               (upper-bound y)))
        (p3 (* (upper-bound x)
               (lower-bound y)))
        (p4 (* (upper-bound x)
               (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
(define (div-interval x y)
  (mul-interval x
                (make-interval
                 (/ 1.0 (upper-bound y))
                 (/ 1.0 (lower-bound y)))))
```

## 2.2 Hierarchical Data and the Closure Property

**closure property** of cons: the ability to create pairs whose elements are pairs. 

普遍而言，当一个结合数据的操作的返回结果又可以被这个操作本身继续结合，我们就说操作具有 closure property。有了 closure 我们就能够创造多层结构（hierarchical structures）。

### 2.2.1 Representing Sequences

**sequence**: an ordered collection of data objects

```scheme
;一个直观的表示方法（就是链表）
(cons 1
  (cons 2
    (cons 3
      (cons 4 nil))))
;这种方法等效的语法表示
(list 1 2 3 4)
;对应的 selector
(define one-through-four (list 1 2 3 4))
(car one-through-four) ;1
(cdr one-through-four) ;(2,3,4)
(car (cdr one-through-four)) ;2
(cons 10 one-through-four) ;(10 1 2 3 4)
;我们可以再定义一些 operation
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1)
            (append (cdr list1) list2))))
```

we can define operation **map**!

> Map is an important construct, not only because it captures a common pattern, but because it establishes a higher level of abstraction in dealing with lists...Map helps establish an abstraction barrier that isolates the implementation of procedures that transform lists from the details of how the elements of the list are extracted and combined.

```scheme
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))
```

```scheme
(define (scale-list items factor)
  (map (lambda (x) (* x factor)) items))
```

### 2.2.2 Hierarchical Structures

可以把 list 的项也定义成 list，这样就形成了树状结构

```scheme
;计算树有多少叶子节点
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))
```

> Just as map is a powerful abstraction for dealing with sequences, map together with recursion is a powerful abstraction for dealing with trees.

```scheme
;just like scale-list
(define (scale-tree tree factor)
  (cond ((null? tree) nil)
        ((not (pair? tree))
         (* tree factor))
        (else
         (cons (scale-tree (car tree) factor)
               (scale-tree (cdr tree) factor)))))
;map version
;对子树做 map
(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))
```

### 2.2.3 Sequences as Conventional Interfaces

把过程抽象成几个步骤（express programs as sequence operations），数据在其中流动...just as signal-flow

> The value of expressing programs as sequence operations is that this helps us make program designs that are **modular**, that is, designs that are constructed by combining relatively independent pieces. We can encourage modular design by providing a library of standard components together with a **conventional interface** for connecting the components in flexible ways.

```scheme
;一些重要的 component
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))
(define (accumulate op initial sequence)
  (newline)
  (display sequence)
  (if (null? sequence)
      initial ;递归到底的时候是 (last, nil) 这种，所以会返回 initial，然后一层层向回传
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
```

**conventional interfaces**：在本例中指的是 sequence(lists)，这种接口让我们可以把一系列的步骤（modules）连接到一起
