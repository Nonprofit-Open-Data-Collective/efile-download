
library( dplyr )
library( xml2 )
library( rvest )
library( microseq )



### GET DOWNLOAD LINKS

URL <- "https://www.irs.gov/charities-non-profits/form-990-series-downloads"
pg <- read_html(URL)

links <- html_attr( html_nodes( pg, "a" ), "href" )
urls.xml <- grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}zip', links, value = TRUE )
urls.index <-   grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}\\.csv', links, value = TRUE )





## SAVE METADATA
##     dfz

get_filename <- function(x)
{
  strsplit( x, "/" ) %>%
  unlist() %>%
  tail(1)
}

get_year <- function(x)
{
  xml.year <- microseq::gregexpr( 'xml/[0-9]{4}/', x, extract = TRUE ) %>% unlist()
  year <- substr( xml.year, 5, 8 )
  return(year)
}

get_dfz <- function( urls )
{
  year     <- sapply( urls, get_year )
  filename <- sapply( urls, get_filename )
  path     <- paste0( year, "/", filename )
  dfz      <- data.frame( filename, year, path, download.url=urls  )
  rownames( dfz ) <- NULL
  return( dfz )
}

dfz <- get_dfz( urls.xml )




| filename             |year | path                     |
|:---------------------|:----|:--------------------------|
|2023_TEOS_XML_01A.zip |2023 |2023/2023_TEOS_XML_01A.zip |
|2023_TEOS_XML_02A.zip |2023 |2023/2023_TEOS_XML_02A.zip |
|2023_TEOS_XML_03A.zip |2023 |2023/2023_TEOS_XML_03A.zip |
|2023_TEOS_XML_04A.zip |2023 |2023/2023_TEOS_XML_04A.zip |
|2022_TEOS_XML_01A.zip |2022 |2022/2022_TEOS_XML_01A.zip |
|2022_TEOS_XML_01B.zip |2022 |2022/2022_TEOS_XML_01B.zip |

|  download.url                                                        |
|:---------------------------------------------------------------------|
|https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_01A.zip |
|https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_02A.zip |
|https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_03A.zip |
|https://apps.irs.gov/pub/epostcard/990/xml/2023/2023_TEOS_XML_04A.zip |
|https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01A.zip |
|https://apps.irs.gov/pub/epostcard/990/xml/2022/2022_TEOS_XML_01B.zip |




# DIRECTORY SETUP:
# CREATE ONE FOLDER PER YEAR

create_dirs <- function( urls )
{
  dir.create("XML")
  
  yyyy <- 
    urls %>%
    sapply( get_year ) %>% 
    unique() 
    
  paste0( "XML/", yyyy )  %>% 
    lapply( dir.create )
    
  setwd("XML")
  cat( "WORKING DIRECTORY SET TO:\n" )
  return( getwd() )
}

create_dirs()



# downloads to current wd
download_index <- function( url )
{
  year     <- get_year( url )
  filename <- get_filename( url )
  download.file( url, filename, mode="wb" )
}



# downloads to YYYY folders
download_xml <- function( url )
{
  year     <- get_year( url )
  filename <- get_filename( url )
  fp    <- paste0( year, "/", filename )
  download.file( url, fp, mode="wb" )
}

download_xml( urls.xml[1] )



# unzips in YYYY folders
unzip_w_err_handle <- function( url )
{
  year     <- get_year( url )
  filename <- get_filename( url )
  fp    <- paste0( year, "/", filename )
  m <- 
    testthat::capture_warning( unzip( fp, exdir=year ) )
  if( is.null(m) ){ return( NULL ) }
  if( m$message == "error 1 in extracting from zip file" )
  { return( fp ) }
}

failed.paths <- sapply( urls.xml, unzip_w_err_handle )



fail_report <- function( f )
{
  missing <- f[ ! sapply( f, file.exists ) ]
  cat( "\nMISSING CASES: \n\n" )
  cat( paste( missing, collapse=" \n" ) )
  corrupted <-  fails[ sapply( fails, file.exists ) ]
  cat( "\n\nCORRUPTED DOWNLOADS: \n\n" )
  cat( paste( corrupted, collapse=" \n" ) ) 
  cat( "\n\n" ) 
}

fail_report( failed.paths )




# retry download unzip
# df = dfz file
# f = failed paths
retry_dluz <- function( urls )
{
  sapply( urls, download_xml )
  f2 <- sapply( urls.xml, unzip_w_err_handle )
  return( f2 )
}





DOWNLOAD_ALL_EFILE <- function( URL="https://www.irs.gov/charities-non-profits/form-990-series-downloads" )
{
  create_dirs()
  
  pg <- read_html(URL)
  links <- html_attr( html_nodes( pg, "a" ), "href" )
  
  urls.xml <- grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}zip', links, value = TRUE )
  lapply( urls.xml, download_xml )
  
  urls.index <-   grep( 'https://apps\\.irs\\.gov/pub/epostcard/990/xml.{1,70}\\.csv', links, value = TRUE )
  lapply( urls.index, download_index )
  
  fails <- sapply( urls.xml, unzip_w_err_handle )
  fail_report( fails )
  
  year <- get_year( url )
  fn   <- get_filename( url )
  fp   <- paste0( year, "/", fn )
  failed.twice <- retry_dluz( urls.xml[ fp %in% fails ] )
  
  cat( "##  FAILED TWICE: ##\n\n" )
  fail_report( failed.twice )
  
  dfz <- get_dfz( urls.xml )
  dfz$OK <- ! dfz$path %in% failed.twice
  return( dfz )
}









