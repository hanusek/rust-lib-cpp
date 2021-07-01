all: rust_lib/target/debug/librust_lib.a
	cbindgen  ./rust_lib -o ./include/example.h
	g++ -o run ./main.cpp ./rust_lib/target/debug/librust_lib.a -ldl -lpthread -I./include
	LD_LIBRARY_PATH=./rust_lib/target/debug/ ./run

rust_lib/target/debug/librust_lib.a: rust_lib/src/lib.rs rust_lib/Cargo.toml
	cd rust_lib && cargo build

clean:
	rm -rf target
	rm -rf run
