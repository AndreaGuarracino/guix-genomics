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
  (let ((version "0.2.2")
        (commit "47a1b0709b7bd0adcf744f42b3dc387a756e32d9")
        (package-revision "4"))
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
                "1b30n376r1663yknb7bdziirj4xcbiyflbhmbvaidwh18c73lc29"))))
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
        ("gcc" ,gcc-10)
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
