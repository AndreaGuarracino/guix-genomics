(define-module (edyeet)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression))

(define-public edyeet
  (let ((version "0.2.1")
        (commit "057b141b38db1868a24f87c1a4204ed62a5f2ba2")
        (package-revision "1"))
    (package
     (name "edyeet")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/edyeet.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1kv6v4ipvma40iqcclx1p9a3ayd7339p4yhxsyjj03i93kp9bw9p"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))
        ;;#:configure-flags '("-DBUILD_TESTING=false")
        #:make-flags (list "CC=gcc CXX=g++")))
     (native-inputs
      `(("cmake" ,cmake)
        ("gsl" ,gsl)
        ("zlib" ,zlib)))
     (synopsis "base-accurate DNA sequence alignments using edlib and mashmap2")
     (description "edyeet is a fork of MashMap that implements
base-level alignment using edlib. It completes an alignment module in
MashMap and extends it to enable multithreaded operation. A single
command-line interface simplfies usage. The PAF output format is
harmonized and made equivalent to that in minimap2, and has been
validated as input to seqwish.")
     (home-page "https://github.com/ekg/edyeet")
     (license license:expat))))
