(define-module (edyeet)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
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
  (let ((version "v0.1")
        (commit "63663eb033e67accb01e75c9bdd18ab3e0cd3cc6")
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
                "1h5rfq1pq21c4hc8bbzhbrmd3shnsigxk0ngsp0y0dp2x5701kwm"))))
     ;(patches (search-patches "mashmap-make-the-aligner-as-well.patch"))))
     (build-system gnu-build-system)
     (arguments
      `(#:make-flags 
        '("CC=gcc" "CXX=g++")
        #:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (native-inputs
      `(("gsl" ,gsl)
        ("autoconf" ,autoconf)
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
