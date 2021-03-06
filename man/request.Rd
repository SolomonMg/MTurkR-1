\name{request}
\alias{request}
\title{Execute an MTurk API Request}
\description{This is the workhorse function that makes authenticated HTTP requests to the MTurk API. It is only provided for advanced users.}
\usage{
request(keyid, operation, signature, timestamp, GETparameters, 
		version = "2012-03-25", service = "AWSMechanicalTurkRequester", 
		browser = FALSE, log.requests = TRUE, sandbox = FALSE, 
		xml.parse = FALSE, print.errors = TRUE, validation.test = FALSE)
}
\arguments{
  \item{keyid}{An AWS Access Key ID.}
  \item{operation}{The MTurk API operation to be performed.}
  \item{signature}{A base64 encoded HMAC signature, as returned by \code{\link{authenticate}}.}
  \item{timestamp}{A timestamp, as returned by \code{\link{authenticate}}.}
  \item{GETparameters}{An optional character string containing URL query parameters that specify options for the request.}
  \item{version}{The version of the MTurk API to use. Default is \dQuote{2012-03-25}, under which the MTurkR package was built.}
  \item{service}{The MTurk service to which the authenticated request will be sent. Supplied only for advanced users.}
  \item{browser}{Optionally open the request in the default web browser, rather than opening in R. Default is \code{FALSE}.}
  \item{log.requests}{A logical specifying whether API requests should be logged. Default is \code{TRUE}. See \code{\link{readlogfile}} for details.}
  \item{sandbox}{Optionally execute the request in the MTurk sandbox rather than the live server.  Default is \code{FALSE}.}
  \item{xml.parse}{Whether the returned list should contain parsed XML.}
  \item{print.errors}{Whether errors produced by the MTurk API request should be printed.}
  \item{validation.test}{Currently a logical that returns the URL of the specified REST request. Default is \code{FALSE}. May additionally validate the request (and supply information about that validation) in the future.}
}
\details{This is a mostly internal function that executes MTurk API requests. It is made available for use by advanced users to execute custom API requests (in tandem with \code{\link{authenticate}}). Even advanced users, however, should be satisifed with the functionality provided by \code{\link{genericmturkr}}.}
\value{A list containing the URL of the MTurk API REST request (\code{request.url}), the Request ID created by the API reqest (\code{request.id}), a logical indicating whether or not the request was valid and thus executed as intended (\code{valid}), and a character string containing the XML-formatted API response (\code{xml}).}
\references{
\href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMechanicalTurkRequester/MakingRequestsArticle.html}{API Reference}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{\link{authenticate}}

\code{\link{ParseErrorCodes}}
}
%\examples{}
