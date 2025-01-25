# MyCompiler
Compiler for generating three-address code from arithmetic expressions with custom operator precedence and number handling rules.
Features include:

Handles integers, operators (+, -, *, /), parentheses, and whitespace.
Reverses non-multiples of 10 during input and calculations, while retaining multiples of 10 as-is.
Drops fractional parts of results during calculations.
Implements custom operator precedence: addition/subtraction > multiplication/division.
Supports right-to-left associativity for addition/subtraction and left-to-right for multiplication/division.
Assumes error-free input.
