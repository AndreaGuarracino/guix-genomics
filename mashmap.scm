(define-module (mashmap)
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

(define-public mashmap
  (let ((version "2.0")
        (commit "c25a059329b9211d817319377f00d8e23414a978")
        (package-revision "1"))
    (package
     (name "mashmap")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/MashMap.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1d82w9nvkayvai4vyphl98y4sinvs1196c1q8gs7y53chbjw8kam"))))
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
     (synopsis "A fast approximate aligner for long DNA sequences")
     (description "MashMap implements a fast and approximate algorithm for computing local alignment boundaries between long DNA sequences.")
     (home-page "https://github.com/marbl/MashMap")
     (license license:expat))))
