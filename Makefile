.PHONY: all
all: byte native result.install

result.ml: which_result.ml
	cp `ocaml which_result.ml` result.ml

.PHONY: byte
byte: result.ml
	ocamlc -c result.ml
	ocamlc -a -o result.cma result.cmo

.PHONY: native
native: result.ml
	ocamlopt -c result.ml
	ocamlopt -a -o result.cmxa result.cmx
	ocamlopt -shared -linkall -o result.cmxs result.cmxa || true

result.install: result.cma
	echo -n "lib: [ \"META\"" > result.install
	for fn in result.*; do \
	  test "$$fn" != "result.install" && echo -n " \"$$fn\""; \
	done >> result.install
	echo " ]" >> result.install

.PHONY: install
install:
	ocamlfind remove result 2> /dev/null || true
	ocamlfind install result META result.*

.PHONY: uninstall
uninstall:
	ocamlfind remove result

.PHONY: clean
clean:
	rm -f result.*
