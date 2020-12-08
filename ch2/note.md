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
  (if (null? sequence)
      initial ;递归到底的时候是 (last, nil) 这种，所以会返回 initial，然后一层层向回传
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
```

**conventional interfaces**：在本例中指的是 sequence(lists)，这种接口让我们可以把一系列的步骤（modules）连接到一起。把 accumulate filter map...组合起来可以解决很多问题，中间通过 conventional interfaces 连接，普遍的范式一般这样：

```scheme
(define
  (product-of-squares-of-odd-elements sequence)
  (accumulate
   *
   1
   (map square (filter odd? sequence))))
;从语义上也很好理解
;filter 把 sequence 中的奇数筛出来
;map 对这些奇数做平方
;accumulate 将这些平方加起来
```

这种 sequence 范式可以用于解决很多用嵌套循环表达的问题，例如：

> 给定 n，找出所有的数对 `(i,j)`，满足 `1<=j<i<=n` 且 `i+j` 是素数
>
> 可以这样分析，对于每个 `i<=n`，我们枚举出所有的 `j<i`，然后生成一个固定 i 和所有 j 的 `(i,j)` 数对 list；把每个 list 都 append 到一起，最后 filter

```scheme
(accumulate ;number[][] => number[], flatmap!
 append
 nil
 (map (lambda (i) ;这步map: number[] => number[][]
        (map (lambda (j) (list i j)) ;这步map：number[] => number[]
             (enumerate-interval 1 (- i 1))))
      (enumerate-interval 1 n)))
;一些实用工具
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))
```

这里很重要的范式是 **nested mappings**，通过 map 的嵌套达到嵌套循环的效果（理解时可以先将外层固定理解内层）。配合 `flatmap` 使用防止最后结果的 list 嵌套

### 2.2.4 Example: A Picture Language

> the importance of describing a language:
> - primitives
> - means of combination
> - means of abstraction

这一节定义了一个简单的语言：
- 唯一元素：painter（画出一幅平行四边形的画）e.g.`wave`, `rogers`
- 组合：把给定的 painters 组合成新的 painters（满足 closure） e.g.`besides`, `below`, `flip-vert`, `flip-horiz`
- 抽象：函数作为另一个函数的参数

下面讨论怎么实现 painter 和它的各种组合操作

- 先定义 frame（可以理解为画框）：由三个向量组成，分别表示原点到起点，以及由起点开始的两条边向量
- 然后给出将一个原点坐标系的向量转化到画框起点坐标系的方法 `frame-coord-map`。

```scheme
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect 
      (scale-vect (xcor-vect v)
                  (edge1-frame frame))
      (scale-vect (ycor-vect v)
                  (edge2-frame frame))))))
```

从而我们可以将 painter 表示为，给定一个画框，将一幅画移动缩放到画框中（调用 `frame-coord-map` 方法，相当于将原点坐标系的画（一堆向量）转化到画框坐标系中）

painter 上的操作：改变画框的位置，然后在新画框中调用原有的 painter。这些操作无需知道 painter 是怎么运行的，只需要改变原有的 frame。这个过程可以统一抽象成下面的方法：

```scheme
(define (transform-painter 
         painter origin corner1 corner2) ;origin表示新画框的原点，corner1/2 分别表示其两条边的终点
  (lambda (frame) ;返回一个接受frame（旧画框）的函数，把旧画框转化为新画框然后调用painter
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame new-origin ;新的frame
                  (sub-vect (m corner1) 
                            new-origin)
                  (sub-vect (m corner2)
                            new-origin)))))))
```

从而各种操作都可以定义成 transform-painter

```scheme
;垂直翻转 也就是变换画框的坐标系
(define (flip-vert painter)
  (transform-painter
   painter
   (make-vect 0.0 1.0)   ;new origin
   (make-vect 1.0 1.0)   ;new end of edge1
   (make-vect 0.0 0.0))) ;new end of edge2
```

**stratified design**：分层设计，每层以下层提供的原语组合起来构造新的部分，构造出的结果成为对上层提供的原语。每一层所用的语言都有与该层次的细节相适应的基本要素、组合、抽象。

分层设计提高了程序的鲁棒性，即一个小的需求变动只会对应改动程序的一小部分

## 2.3 Symbolic Data

### 2.3.1 Quotation

通过在对象前加上一个单引号 `'` 来表示引用这个对象

```scheme
(define a 1)
(define b 2)

(list a b) ;(1 2)
(list 'a 'b) ;(a b)
(list 'a b) ;(a 2)

(car '(a b c)) ;a
(cdr '(a b c)) ;(b c)
```

```scheme
(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(memq 'apple '(pear banana prune)) ;false
(memq 'apple '(x (apple sauce) y apple pear)) ;(apple pear)
```

### 2.3.2 Example: Symbolic Differentiation

Symbolic Differentiation：符号求导，例如给出 ax^2+bx+c 和 x（要求对 x 求导），得出 2ax+b
