# Smooth Fano Toric Varieties

This is the companion Github repository to my undergraduate thesis in Informatics Civil Engineering at Federico Santa María Technical University, Valparaíso, Chile, titled "A computational approach to classification of additive smooth Fano polytopes".

## Contents
### google-colab
This directory contains the Python code, which produced most of the results present in the text. It is also the most faithful implementation of the processes and algorithms described therein, and its files roughly match its sections.

You may also view the contents directly on Google Colab:
* [STFV - Web scraping the GRDB.ipynb](https://colab.research.google.com/drive/1jJmtj-r_GvUUSV7cKxyjsWTPE13TGznt?usp=sharing)
* [STFV - Proposed Solution, Results.ipynb](https://colab.research.google.com/drive/14KTj1bKBH5ughdn6RjZzYDRIAxrDSZz-?usp=sharing)
* [STFV - Results Validation.ipynb](https://colab.research.google.com/drive/1dd1CuzIt6PFGWblrz7yVGRfYzwvpDKPf?usp=sharing)

### macaulay2
This directory contains version 0.1 of AdditiveProjectiveToricVarieties, a new Macaulay2 package with methods for working with additive actions on projective toric varieties.

To install the package, simply open a terminal in ``macaulay2`` and run:
```bash
M2
installPackage("AdditiveProjectiveToricVarieties")
```

To see the docs, run:
```bash
M2
viewHelp
```
and open the link to the package docs.

To run the tests:
```bash
M2
check AdditiveProjectiveToricVarieties
```

### v-encuentro-teoria-de-numeros
This folder contains a beamer and abstract from a talk at [V-Encuentro Teoría de Números](http://ima.ucv.cl/congreso/v-encuentro/).

### classifier, data.npy
These files contain pre-processed and processed data from the [GRDB](http://www.grdb.co.uk/forms/toricsmooth) and M Obro, "An algorithm for the classification of smooth Fano polytopes", arXiv:0704.0049 (2007).
