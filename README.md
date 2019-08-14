# Terror

A Nix-Aware Build System for C/C++.

All the best build systems stike fear into the hearts of the users.

## What's This?

Most modern programming language communities have at their disposal one or more
package manager(s) with at least some of these features:

- Declarative specification of dependencies and build outputs.
- Automatic fetching, building, and linking of dependencies.
- Sharing or caching of already built dependencies among projects, if you're
  lucky.
- Control of the compilation, linking, and other assembly of build artifacts.
- Integration with an external facility for hosting packages in source and/or
  binary form.

There have been [various](https://conan.io/) [attempts](https://buckaroo.pm/) to
create a package manager in this style for the C/C++ ecosystem, but all leave
something to be desired. To be fair, providing such a tool that is
cross-platform and sufficiently flexible is a massive undertaking.

Enter [Nix](https://nixos.org). Nix is in many respects an ideal package manager
(at least on paper). It supports hybrid source and binary distribution,
transparent sharing of artifacts among packages, and guarantees reproducibility
by construction. However, it is different from modern language-specific package
managers; less like `cabal`, `stack`, or `cargo`; more like `apt`, `pacman`, or
`emerge`.

Nix has strong integration with language-specific package managers. If you've
got a working `cabal` package, you're just a `cabal2nix` call away from a
working Nix pagkage. Nix also has integration for packages built with GNU
autotools and CMake, although non-trivial packages are likely to require
signifiacant fiddling to get working. This is in part due to the massive
configuration space of autotools, CMake, and other general-purpose build
systems. A `cabal` or `cargo` file is less of a build script and more of a
compact configuration; this is clearly not true of any non-trivial Makefile.

Packaging a C/C++ project with Nix solves most of the problems autotools and
CMake are designed to solve. There's no need to chase dependnecies, compile test
programs to determine the features of the compiler or libc, and no need to call
pkgconfig to determine what flags are necessary. Nix provides a `$CC` that
magically knows how to include and link with the requested dependencies. The
only work left to do is determining how to call the compiler based on the
desired artifacts, structure of the source tree, and perhaps some supplementary
configuration information supplied by the Nix expression for the package.

The goal of this project is to leverage Nix to provide a `cabal` or `cargo`-like
build system for C/C++. Nix provides the package management bits, this program
provides the artifact building bits.

## Goals

- Fast builds with exact dependency tracking yielding trustworthy incremental
  builds. [Shake](https://shakebuild.com/) provides all of these properties.
- A declarative build specification that is flexible, non-repetitive, and is
  sufficiently structured to provide good error reporting.
  [Dhall](https://dhall-lang.org/) provides all of these properties.
- Transparently pipe in build-time configuration from Nix. Running a single
  command inside a `nix-shell` should be all that's needed to perform a build.
- Simple support for defining and running tests, without any opinions w.r.t. how
  tests should be written, like `cabal test`.
- Support for other languages that tend to lean on make/autotools/CMake/etc.,
  e.g. FORTRAN, Objective-C, ATS, CUDA, assembly, etc.
- Support for cross-compilation. This is almost free thanks to Nix.

So all we have to do is generate a set of Shake rules from a Dhall config file
and information from the environment provided by Nix. Piece of cake.

## Non-Goals

- Support for running builds without Nix. Life is so much simpler inside the
  walled garden.
- Interoperability with other build system execution engines, i.e. no generating
  files for `make` or `ninja` to execute.
- Unlimited flexibiltiy w.r.t. project structure, or build parameterization. No
  running scripts to determine build parameters or generating headers full of
  constants.
- Support for executing sub-builds, i.e. recursive make/CMake. This technique is
  usually used to build vendored dependencies, which are a scourge to begin
  with. Get your dependencies from Nix.
- Support for build-time code generation. If you want fine-grained
  build-configuration-parametric code, use CPP instead of generated headers.
- Support for ad-hoc compiler-like-things, e.g. the Protocol Buffer compiler.
  Package such generated things separately (and reconsider your dependency
  choices).

I'll probably change my mind about those last two.
