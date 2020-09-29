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
**define** 是 scheme 中最简单的一种**抽象**

### Evaluating Combinations

给组合求值的过程如下：
1. 给组合的子表达式求值
2. 将最左侧的操作符作用于右边的操作数们
   
哦，自然的**递归**！

**tree accumulation**：自底向上给树状对象求值
