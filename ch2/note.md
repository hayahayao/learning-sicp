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
