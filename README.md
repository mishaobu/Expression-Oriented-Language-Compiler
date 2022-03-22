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

Not only will the program be compiled, but this compiler automatically performs some optimizations on the input code including [Constant Folding](https://en.wikipedia.org/wiki/Constant_folding) and [Constant Propogation](https://cran.r-project.org/web/packages/rco/vignettes/opt-constant-propagation.html).

---

Instructions to execute on MacOS:

1. Install dependencies:
~~~
brew install gpatch
brew install opam

opam switch create compiler ocaml-base-compiler.4.13.0
opam install dune
eval $(opam env)
~~~
2. Compile the Patina program. Some examples exist in the "tests" folder.
~~~
 dune exec ./patina.exe -- <filename>
~~~
