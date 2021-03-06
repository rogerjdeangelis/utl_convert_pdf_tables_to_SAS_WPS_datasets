SAS Forum: Convert pdf tables to SAS WPS datasets

WPS/Proc R or IML/R

SAS FORUM (2 posts)
https://tinyurl.com/y93699d2
https://communities.sas.com/t5/SAS-Text-and-Content-Analytics/Need-to-extract-data-from-pdf-file/m-p/483338

https://tinyurl.com/ycl2otqy
https://communities.sas.com/t5/Base-SAS-Programming/PDF-to-SAS-Dataset/m-p/401636

you may need to install Xpdf - I did not
http://www.xpdfreader.com/download.html


INPUT ( PDF file with the table below)
======================================

see for input
https://tinyurl.com/yau53g7c
https://github.com/rogerjdeangelis/utl_convert_pdf_tables_to_SAS_WPS_datasets/blob/master/utl_convert_pdf_tables_to_SAS_WPS_datasets.pdf

d:/pdf/utl_convert_pdf_tables_to_SAS_WPS_datasets.pdf

  NAME        SEX     AGE    HEIGHT   WEIGHT

  Alfred       M       14        69    112.5
  Alice        F       13      56.5       84
  Barbara      F       13      65.3       98
  Carol        F       14      62.8    102.5
  Henry        M       14      63.5    102.5
  James        M       12      57.3       83
  Jane         F       12      59.8     84.5
  Janet        F       15      62.5    112.5
  Jeffrey      M       13      62.5       84
  John         M       12        59     99.5
  Joyce        F       11      51.3     50.5
  Judy         F       14      64.3       90
  Louise       F       12      56.3       77
  Mary         F       15      66.5      112
  Philip       M       16        72      150
  Robert       M       12      64.8      128
  Ronald       M       15        67      133
  Thomas       M       11      57.5       85
  William      M       15      66.5      112


EXAMPLE OUTPUT (SAS/WPS dataset - you willl need parse)

 WORK.WANT total obs=20

                LINES

   NAME    SEX AGE HEIGHT  WEIGHT
   Alfred  M    14    69.0   112.5
   Alice   F    13    56.5    84.0
 ....
   Ronald  M    15    67.0   133.0
   Thomas  M    11    57.5    85.0
   William M    15    66.5   112.0


PROCESS  (WORKING CODE)
========================

  file <- "d:/pdf/class.pdf";
  Rpdf <- readPDF(control = list(text = "-layout"));
  corpus <- VCorpus(URISource(file), readerControl = list(reader = Rpdf));
  classtext <- as.data.frame(content(content(corpus)[[1]]));  ** first table;


OUTPUT
======
 WORK.WANT total obs=20

                LINES

   NAME    SEX AGE HEIGHT  WEIGHT
   Alfred  M    14    69.0   112.5
   Alice   F    13    56.5    84.0
   Barbara F    13    65.3    98.0
 ....
   Ronald  M    15    67.0   133.0
   Thomas  M    11    57.5    85.0
   William M    15    66.5   112.0

    Variables in Creation Order

   #    Variable    Type    Len

   1    LINES       Char     31

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

* create a pdf;
title;footnote;
ods pdf file="d:/pdf/utl_convert_pdf_tables_to_SAS_WPS_datasets.pdf";
proc print data=sashelp.class noobs;
run;quit;
ods pdf close;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

library("slam");

* xpdf executables have to be in the path;
%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library("tm");
file <- "d:/pdf/utl_convert_pdf_tables_to_SAS_WPS_datasets.pdf";
Rpdf <- readPDF(control = list(text = "-layout"));
corpus <- VCorpus(URISource(file),
      readerControl = list(reader = Rpdf));
want <- as.data.frame(content(content(corpus)[[1]]));
colnames(want)<-"lines";
lines <- as.data.frame(strsplit(as.character(want$lines), split="\\r\\n"));
colnames(lines)<-"lines";
endsubmit;
import r=lines data=wrk.want;
run;quit;
');

LOG

> source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T)
> .libPaths(c(.libPaths(), "d:/3.3.2", "d:/3.3.2_usr"))
> options(tigris_use_cache = TRUE)
> options(help_type = "html")
> library("tm")
Loading required package: NLP
> file <- "d:/pdf/utl_convert_pdf_tables_to_SAS_WPS_datasets.pdf"
> Rpdf <- readPDF(control = list(text = "-layout"))
> corpus <- VCorpus(URISource(file),      readerControl = list(reader = Rpdf))
> want <- as.data.frame(content(content(corpus)[[1]]))
> colnames(want)<-"lines"
> lines <- as.data.frame(strsplit(as.character(want$lines), split="\\r\\n"))
> colnames(lines)<-"lines"

NOTE: Processing of R statements complete

16        import r=lines data=wrk.want;
NOTE: Creating data set 'WRK.want' from R data frame 'lines'
NOTE: Column names modified during import of 'lines'
NOTE: Data set "WRK.want" has 20 observation(s) and 1 variable(s)



