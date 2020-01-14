
(define-module (graphaligner)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages protobuf))

(define-public graphaligner
  (let ((version "1.0.10")
        (commit "849a7fb1360e7b1e09d361d65f3f9f1316f33875")
        (package-revision "1"))
    (package
     (name "graphaligner")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/maickrau/GraphAligner.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1skmncd9aan7ffv7fxzzs93dhgjj1hmn8z994m5sqrwsafzd20rm"))))
     (build-system gnu-build-system)
     (arguments
      `(#:tests? #f ; no tests
        #:make-flags '("all")
        #:phases
        (modify-phases
         %standard-phases
         (add-after 'unpack 'patch-source
                    (lambda* (#:key inputs #:allow-other-keys)
                             (let ((sdsl (assoc-ref inputs "sdsl-lite")))
                               (substitute* "makefile"
                                            (("VERSION .*") (string-append "VERSION = " ,version "\n"))))
                             #t))
         (delete 'configure) ; no configure phase
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                           (let ((out (assoc-ref outputs "out")))
                             (for-each
                              (lambda (program)
                                (install-file program (string-append out "/bin")))
                              (find-files "bin" "."))
                             (for-each
                              (lambda (header)
                                (install-file header (string-append out "/include")))
                              (find-files "src" "\\.h(pp)?$")))
                           #t)))))
     (native-inputs
      `(("pkg-config" ,pkg-config)
        ("protobuf" ,protobuf "static")
        ("sdsl-lite" ,sdsl-lite)
        ("sparsehash" ,sparsehash)
        ("zlib" ,zlib "static")))
     (inputs
      `(("boost" ,boost-static)
        ("jemalloc" ,jemalloc)
        ("libdivsufsort" ,libdivsufsort)
        ("mummer" ,mummer)
        ("protobuf" ,protobuf)
        ("zlib" ,zlib)))
     (home-page "https://github.com/maickrau/GraphAligner")
     (synopsis "Seed-and-extend program for aligning  genome graphs")
     (description "Seed-and-extend program for aligning long error-prone reads to
genome graphs.  For a description of the bitvector alignment extension
algorithm, see
@url{https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btz162/5372677
here}.")
     (license license:expat))))

(define-public mummer
  (package
    (name "mummer")
    (version "4.0.0beta2")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://github.com/mummer4/mummer/releases/"
                            "download/v" version "/mummer-" version ".tar.gz"))
        (sha256
         (base32
          "14qvrmf0gkl4alnh8zgxlzmvwc027arfawl96i7jk75z33j7dknf"))))
    (build-system gnu-build-system)
    (inputs
     `(("gnuplot" ,gnuplot)
       ("perl" ,perl)))
    (home-page "http://mummer.sourceforge.net/")
    (synopsis "Efficient sequence alignment of full genomes")
    (description "MUMmer is a versatil alignment tool for DNA and protein sequences.")
    (license license:artistic2.0)))
