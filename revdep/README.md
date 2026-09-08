# Reverse dependencies

Checked 1 reverse import on CRAN: **econdataverse**.

econdataverse attaches imfapi and does not call its internals. After installing
imfapi 0.1.3 over the CRAN 0.1.2 binary, `library(econdataverse)` succeeded and
`tools::testInstalledPackage("econdataverse", types = "tests")` returned 0.
