\name{readlogfile}
\alias{readlogfile}
\title{Read the MTurkR Logfile}
\description{A log of all MTurk API requests are stored in a tab-separated value file in the current working directory called \sQuote{MTurkRLog.tsv}. This function reads this MTurkR logfile into R as a dataframe, using \code{read.delim}.}
\usage{
%readlogfile(filename = NULL, fix = FALSE, shell = FALSE)
readlogfile(filename = NULL, shell = FALSE)
}
\arguments{
  \item{filename}{An optional character string specifying the name of an MTurkR log file to read into R. The default is \file{MTurkRlog.tsv} in the working directory.}
  %\item{fix}{A logical specifying whether the R data editor window (normally called by \code{fix}) should be opened immediately upon function execution. Default is \code{FALSE}.}
  \item{shell}{A logical specifying whether the log file should be opened using the workstation's default program for the log's file type (tab-separated value file) rather than loading into R. Default is \code{FALSE}.}
}
\details{By default, MTurkR stores a record of all MTurk API requests in a local file in the working directory. This fucntion reads the locally stored MTurkR log file (\file{MTurkRlog.tsv}) into R as a dataframe. This is useful for error checking and reviewing prior requests. A convenient, visual interface for the logfile is provided by \code{\link{MTurkR.Wizard}}.}
\value{A dataframe containing details of previous (logged, non-browser) MTurk API requests (including RequestId, Operation performed, REST query parameters, and MTurk response XML as a character string).}
%\references{}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{\link{request}}
}
\examples{
\dontrun{
log <- readlogfile()
%# automatically creates an 'mturkrlog' dataframe in the global environment
}
}
\keyword{IO}