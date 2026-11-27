---
name: update-site-cv
description: >-
  Rebuilds cv_source/cv_TianyiGu_2_page_web and replaces the site CV
  (TianyiGu_CV.pdf) linked from index.html. Use when the user asks to update
  the website CV, publish the 2-page web CV, or replace TianyiGu_CV.pdf.
---

# Update site CV

`index.html` links to `TianyiGu_CV.pdf` at the repository root (`href="TianyiGu_CV.pdf"`). That file is a copy of the 2-page web CV. Do not change the href or the published filename.

## Update

From the repository root, run:

```bash
.cursor/skills/update-site-cv/scripts/update_cv_pdf.sh
```

The script compiles `cv_source/cv_TianyiGu_2_page_web/cv_TianyiGu_2_page_web.tex` with `pdflatex`, copies `cv_TianyiGu_2_page_web.pdf` over `TianyiGu_CV.pdf`, and exits with an error if `index.html` no longer contains `href="TianyiGu_CV.pdf"`.

Do not copy any other CV (`cv_TianyiGu_1_page`, `cv_TianyiGu_2_page`, or `cv_TianyiGu_Full`) onto the site file. The public CV is the web version only: email and website in the header, no phone number.
