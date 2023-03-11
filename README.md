# sicp-notes
## 参考
- [本书的内容，以及我们能从中学到什么](https://book.douban.com/review/4559081/)
- [《计算机程序的构造和解释（SICP）》讨论的核心问题是什么？](https://www.zhihu.com/question/26549715)
- [我如何用二十天刷完 SICP](http://numbbbbb.com/2016/03/28/20160328_%E6%88%91%E5%A6%82%E4%BD%95%E7%94%A8%E4%B8%A4%E5%91%A8%E6%97%B6%E9%97%B4%E5%88%B7%E5%AE%8C%20SICP/)
- https://web.mit.edu/6.001/6.037/sicp.pdf
- https://github.com/DeathKing/Learning-SICP
### 习题参考
- https://sicp-solutions.net/
- https://sicp.readthedocs.io/en/latest/
- https://github.com/jiacai2050/sicp


## 1. Building Abstractions with Procedures
### 1.1 The Elements of Programming
程序概念
- expression
    - 由操作符和操作数组成 operator and operand
- naming
    - 变量及函数命名用 define 关键字
- evaluating combinations
    - Evaluate the subexpressions of the combination.
    - Apply the procedure that is the value of the lemost subexpres- sion (the operator) to the arguments that are the values of the other subexpressions (the operands).
- compound procedure
- the subsitution model for procedure application
    - applicative order(lisp and scheme is this type)
        - procedure 执行之前先计算所有的参数
    - normal order
        - 需要的时候再计算参数
- conditional expression


### 1.2 Procedures and the Processes They Generate
- Linear Recursion and Iteration
    - linear recursive process
    - linear iterative process
    - 总结
        - 线性递归即普通递归，调用时会增加函数栈的使用，当调用层数很大时，会导致爆栈
        - 尾递归即线性递归的一种特殊情况，通过给函数传递计算好的参数来规避多层函数栈的使用，但是只有当编程语言支持优化尾递归时才有效果，如果不支持优化，那么还是跟普通的线性递归一样（优化的方式一般是将尾递归优化成迭代）
        - 迭代一般是循环执行某一计算，不会有函数的调用和函数栈的使用
    - Ref
        - [Tial Recursion](https://stackoverflow.com/questions/33923/what-is-tail-recursion)
        - [递归、尾递归、迭代的区别](https://zhuanlan.zhihu.com/p/36587160)
- Tree Recursion
    - Examples
        - Computing the sequence of Fibonacci numbers
            ```
            线性递归
            (define (fib n)
                (cond ((= n 0) 0)
                    ((= n 1) 1)
                    (else (+ (fib (- n 1))
                            (fib (- n 2))))))

            尾递归（可被优化成线性迭代）
            (define (fib n)
                (fib-iter 1 0 n))
            (define (fib-iter a b count)
                (if (= count 0)
                    b
                    (fib-iter (+ a b) a (- count 1))))
            ```
        - Countinng change
            ```
            (define (count-change amount) (cc amount 5))

            (define (cc amount kinds-of-coins)
                (cond ((= amount 0) 1)
                    ((or (< amount 0) (= kinds-of-coins 0)) 0)
                    (else (+ (cc amount
                                 (- kinds-of-coins 1))
                             (cc (- amount
                                    (first-denomination
                                     kinds-of-coins))
                                kinds-of-coins)))))

            (define (first-denomination kinds-of-coins)
                (cond ((= kinds-of-coins 1) 1) ((= kinds-of-coins 2) 5)
                    ((= kinds-of-coins 3) 10)
                    ((= kinds-of-coins 4) 25)
                    ((= kinds-of-coins 5) 50)))
            ```

            ```
            (count-change 1) 1
            (count-change 2) 1
            (count-change 3) 1
            (count-change 4) 1
            (count-change 5) 2
            (count-change 100) 292
            ```
    - 总结
        - 线性递归比较容易理解，尽管效率比迭代差很多
- Order of Growth
    - 总结：时间复杂度和空间复杂度
- Exponentiation
    - 幂与快速幂
- Greatest Common Divisors
    欧几里得算法
    ```
    (define (gcd a b)
        (if (= b 0)
            a
            (gcd b (remainder a b))))
    ```
- Example: Testing for Primality
    素数特性相关


### 1.3 Formulating Abstractions with Higher-Order Procedures
- Procedures as Arguments
  - 函数作为参数
- Constructing Procedures Using lambda
  - 使用匿名函数
- Procedures as General Methods
  - 程序作为普通方法
- Procedures as Returned Values
  - 程序作为函数返回值


## 2. Building Abstractions with Data
### 2.1 Introduction to Data Abstraction
数据抽象即将低层级的数据对象抽象为更高层级的数据对象

**Pair**
cons takes two arguments and returns a compound data object that contains the two arguments as parts.
```
(define x (cons 1 2))
(car x)
1
(cdr x)
2
```

```
(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))
(car (car z))
1
(car (cdr z))
3
```

- [cons](https://en.wikipedia.org/wiki/Cons)
- [CAR and CDR](https://en.wikipedia.org/wiki/Cons)

### 2.2 Hierarchical Data and the Closure Property

**Representing Sequences**

list 概念
```
(list ⟨a1⟩ ⟨a2⟩ . . . ⟨an⟩)
等价于
(cons ⟨a1⟩
    (cons ⟨a2⟩
        (cons . . .
            (cons ⟨an⟩
                nil). . .)))
```

list 操作示例
```
(define one-through-four (list 1 2 3 4))

one-through-four
(1 2 3 4)

(car one-through-four)
1

(cdr one-through-four)
(2 3 4)

(car (cdr one-through-four))
2

(cons 10 one-through-four)
(10 1 2 3 4)

(cons 5 one-through-four)
(5 1 2 3 4)
```

List operations

Print n-th element in list
```
(define (list-ref items n)
    (if (= n 0)
        (car items)
        (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(list-ref squares 3)
16
```

Compoute list length (recursive)
```
(define (length items)
    (if (null? items)
        0
        (+ 1 (length (cdr items)))))

(define odds (list 1 3 5 7))

(length odds)
4
```

Compoute list length (iterative)
```
(define (length items)
    (define (length-iter a count)
        (if (null? a)
            count
            (length-iter (cdr a) (+ 1 count))))
    (length-iter items 0))
```

Append to list
```
(define (append list1 list2)
    (if (null? list1)
        list2
        (cons (car list1) (append (cdr list1) list2))))
```

map
```
(map + (list 1 2 3) (list 40 50 60) (list 700 800 900))
(741 852 963)

(map (lambda (x y) (+ x (* 2 y)))
    (list 1 2 3)
    (list 4 5 6))
(9 12 15)
```

for-each
```
(for-each (lambda (x)
            (newline)
            (display x))
          (list 57 321 88))
57
321
88
```

Tree (use list)
```
(define (count-leaves x)
    (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define x (cons (list 1 2) (list 3 4))) (length x)
3
(count-leaves x)
4


(list x x)
(((1 2) 3 4) ((1 2) 3 4))
(length (list x x))
2
(count-leaves (list x x))
8
```

参考
- [从“八皇后”到amb](https://lvsq.net/2020/05/n-queens/)

### 2.3 Symbolic Data
**Quotaion**

```
(define a 1)
(define b 2)
(list a b)
(1 2)
(list 'a 'b)
(a b)
(list 'a b)
(a 2)
```


```
(car '(a b c))
a
(cdr '(a b c))
(b c)
```

If the symbol is not contained in the list (i.e., is not eq? to any item in the list), then memq returns false. Other- wise, it returns the sublist of the list beginning with the first occurrence of the symbol.
```
(define (memq item x)
    (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))
(memq 'apple '(pear banana prune))
is false, whereas the value of
(memq 'apple '(x (apple sauce) y apple pear)) is (apple pear).
is (apple pear).
```

**Sets**

```
(define (element-of-set? x set)
    (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
    (if (element-of-set? x set)
        set
        (cons x set)))
```

intersection-set
```
(define (intersection-set set1 set2)
    (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
            (cons (car set1) (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))
```

union-set

**ordered sets**
```
(define (element-of-set? x set)
    (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))
```

```
(define (intersection-set set1 set2)
    (if (or (null? set1) (null? set2))
        '()
        (let ((x1 (car set1)) (x2 (car set2)))
            (cond ((= x1 x2)
                (cons x1 (intersection-set (cdr set1)
                                          (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))
```

**ordered binary tree**


### 2.4 Multiple Representations for Abstract Data

### 2.5 Systems with Generic Operations


## 3. Modularity, Objects, and State
### 3.1 Assignment and Local State
### 3.2 The Environment Model of Evaluation
### 3.3 Modeling with Mutable Data
### 3.4 Concurrency: Time Is of the Essence
- Serialization
- Mutex
### 3.5 Streams


## 4. Metalinguistic Abstraction
### 4.1 The Metacircular Evaluator
### 4.2 Variations on a Scheme — Lazy Evaluation
### 4.3 Variations on a Scheme — Nondeterministic Computing
### 4.4 Logic Programming
- TODO relearn


## 5. Computing with Register Machines
### 5.1 Designing Register Machines

几个例子
- GCD
- Factorail
- Fibonacci

```
(define (gcd a b)
    (if (= b 0) a (gcd b (remainder a b))))
```

```
(define (factorial n)
    (if (= n 1) 1 (* (factorial (- n 1)) n)))
```

```
(define (fib n)
    (if (< n 2)
        n
        (+ (fib (- n 1)) (fib (- n 2)))))
```

### 5.2 A Register-Machine Simulator
### 5.3 Storage Allocation and Garbage Collection
### 5.4 The Explicit-Control Evaluator
- The Core of the Explicit-Control Evaluator
  - Evaluating procedure applications
### 5.5 Compilation (TODO re-learn)
- 5.5.1 Structure of the Compiler
  - Targets and linkages
  - Instruction sequences and stack usage
- 5.5.2 Compilling Expressions
  - linkage code
  - simple expressions
  - conditional expressions
  - sequences
- 5.5.3 Compiling Combinations
  - Applying procedures
  - Applying compiled procedures
    - using the stack for variables and arguments is that it avoids the need for garbage collection in languages that would not otherwise require it, and is generally believed to be more efficient. (C use stack, Lisp Use Memory to be garbage-collected)
- 5.5.4 Combining Instruction Sequences
  - lambda expressions
- 5.5.5 An Example of Compiled Code
- 5.5.6 Lexical Addressing
- 5.5.7 Interfacing Compiled Code to the Evaluator
  - Interpretation and compilation
