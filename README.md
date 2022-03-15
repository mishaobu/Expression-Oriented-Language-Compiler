# Expression-Oriented-Language-Compiler

This is a compiler for an Expression-Oriented programming language written in OCaml.
The compiler takes as inputs Patina programs [(see formal specification and syntax here)](https://junrui-liu.github.io/patina/ref.html) and outputs valid assembly programs.

Here is a brief example of a program that can be compiled:
~~~
{
	let x : int = 0;
	let break : bool = false;
	while !break {
		let y : int = 0;
		while (!break && y < x){
			if y*y == x && x > 10 then {break = true} else {break = false};
			y = y + 1
		};
		x = x+1
	};
	x-1
}
~~~
