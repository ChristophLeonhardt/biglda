% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as.instance_list.R
\name{as.instance_list}
\alias{as.instance_list}
\alias{as.instance_list,partition_bundle-method}
\alias{as.instance_list,list-method}
\alias{mallet_instance_list_store}
\alias{mallet_instance_list_load}
\title{Interface to mallet topicmodelling.}
\usage{
as.instance_list(x, ...)

\S4method{as.instance_list}{partition_bundle}(x, p_attribute = "word", verbose = TRUE)

\S4method{as.instance_list}{list}(x, corpus, p_attribute = "word")

mallet_instance_list_store(x, filename = tempfile())

mallet_instance_list_load(filename)
}
\arguments{
\item{x}{A \code{partition_bundle} object.}

\item{...}{further parameters}

\item{p_attribute}{The p_attribute to use, typically "word" or "lemma".}

\item{verbose}{A \code{logical} value, whether to be verbose.}

\item{corpus}{A CWB indexed corpus, defined either by corpus ID, or
\code{corpus} object.}

\item{filename}{Where to store the Java-object.}
}
\description{
Functionality to support the following workflow (see examples): (a) Turn
\code{partition_bundle}-object into mallet instance list, (b) store the
resulting \code{jobjRef}-object, (c) run mallet topic modelling and (d)
turn ParallelTopicModel Java object into \code{LDA_Gibbs} object from
package \code{topicmodels}.
}
\details{
The function \code{mallet_instance_list_load} will load a Java
  InstanceList object that has been saved to disk (e.g. by using the
  \code{mallet_instance_list_store} function). The return value is a
  \code{jobjRef} object. Internally, the function reuses code of the function
  \code{load.mallet.instances} from the R package \code{mallet}.
}
\examples{
 
# Preparations: Create instance list

if (!mallet_is_installed()) mallet_install()

polmineR::use("polmineR")
speeches <- polmineR::as.speeches("GERMAPARLMINI", s_attribute_name = "speaker")

  instance_list <- as.instance_list(speeches)

  lda <- rJava::.jnew("cc/mallet/topics/ParallelTopicModel", 25L, 5.1, 0.1)
  lda$addInstances(instance_list)
  lda$setNumThreads(1L)
  lda$setTopicDisplay(50L, 10L)
  lda$setNumIterations(150L)
  lda$estimate()
  # lda$write(rJava::.jnew("java/io/File", destfile))

# Load topicmodel and turn it into LDA_Gibbs

# mallet_lda <- mallet_load_topicmodel(destfile)
topicmodels_lda <- as_LDA(lda)

library(polmineR)
use("polmineR")
speeches <- as.speeches("GERMAPARLMINI", s_attribute_name = "speaker")
speeches_instance_list <- as.instance_list(speeches, p_attribute = "word")
speeches <- as.speeches("GERMAPARLMINI", s_attribute_name = "speaker")
id_list <- p_attributes(speeches, p_attribute = "word", decode = FALSE)
instance_list <- as.instance_list(id_list, corpus = "GERMAPARLMINI", p_attribute = "word")
}
