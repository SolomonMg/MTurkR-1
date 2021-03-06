\name{AssignQualification}
\alias{AssignQualification}
\alias{AssignQualifications}
\alias{assignqual}
\title{Assign Qualification}
\description{Assign a Qualification to one or more workers. The QualificationType should have already been created by \code{\link{CreateQualificationType}}, or the details of a new QualificationType can be specified atomically. This function also provides various options for automatically specifying the value of a worker's QualificationScore based upon a worker's statistics.}
\usage{
AssignQualification(qual, workers, value = "1", notify = FALSE, 
					name = NULL, description = NULL, keywords = NULL, 
					status = NULL, retry.delay = NULL, 
					test = NULL, answerkey = NULL, test.duration = NULL, 
					auto = NULL, auto.value = NULL, 
					conditional.statistic = NULL, conditional.comparator = NULL, 
					conditional.value = NULL, conditional.period = NULL, 
					set.statistic.as.value = FALSE, 
					keypair = credentials(), print = FALSE, browser = FALSE, 
					log.requests = TRUE, sandbox = FALSE)
}
\arguments{
  \item{qual}{A character string containing a QualificationTypeId.}
  \item{workers}{A character string containing a WorkerId, or a vector of character strings containing multiple WorkerIds.}
  \item{value}{A character string containing the value to be assigned to the worker(s) for the QualificationType.}
  \item{notify}{A logical indicating whether workers should be notified that they have been assigned the qualification. Default is \code{FALSE}.}
  \item{name}{An optional character string specifying a name for a new QualificationType. This is visible to workers. Cannot be modified by \code{UpdateQualificationType}.}
  \item{description}{An optional character string specifying a longer description of the QualificationType. This is visible to workers. Maximum of 2000 characters.}
  \item{keywords}{An optional character string containing a comma-separated set of keywords by which workers can search for the QualificationType. Cannot be modified by \code{UpdateQualificationType}. Maximum of 1000 characters.}
  \item{status}{A character vector of \dQuote{Active} or \dQuote{Inactive}, indicating whether the QualificationType should be active and visible.}
  \item{retry.delay}{An optional time (in seconds) indicating how long workers have to wait before requesting the QualificationType after an initial rejection.}
  \item{test}{An optional character string consisting of a QuestionForm data structure, used as a test a worker must complete before the  QualificationType is granted to them.}
  \item{answerkey}{An optional character string consisting of an AnswerKey data structure, used to automatically score the test.}
  \item{test.duration}{An optional time (in seconds) indicating how long workers have to complete the test.}
  \item{auto}{A logical indicating whether the Qualification is automatically granted to workers who request it. Default is \code{FALSE}.}
  \item{auto.value}{An optional parameter specifying the value that is automatically assigned to workers when they request it (if the Qualification is automatically granted).}
  \item{conditional.statistic}{An optional character string containing the name of a statistic (see \code{\link{ListStatistics}} that should be used to conditionally assign the QualificationType to workers.}
  \item{conditional.comparator}{An optional character string containing a comparator by which a worker's score of a qualification is compared to the specified \code{value}. One of \code{<},\code{<=},\code{>},\code{>=},\code{==},\code{!=},\code{Exists}.}
  \item{conditional.value}{An optional numeric or character string value against which workers scores will be compared. The QualificationType will only be assigned to those whose score on the specified statistic meet the comparison to this value.}
  \item{conditional.period}{An optional character string specifying the period for the statistic. Must be one of: \dQuote{OneDay}, \dQuote{SevenDays}, \dQuote{ThirtyDays}, \dQuote{LifeToDate}. Default is \dQuote{LifeToDate}.}
  \item{set.statistic.as.value}{An optional logical specifying whether the worker's value of the statistic should be used as the value they are assigned for the QualificationType. Default is \code{FALSE} and \code{value} is used instead.}
  \item{keypair}{A two-item character vector containing an AWS Access Key ID in the first position and the corresponding Secret Access Key in the second position. Set default with \code{\link{credentials}}.}
  \item{print}{Optionally print the results of the API request to the standard output. Default is \code{TRUE}.}
  \item{browser}{Optionally open the request in the default web browser, rather than opening in R. Default is \code{FALSE}.}
  \item{log.requests}{A logical specifying whether API requests should be logged. Default is \code{TRUE}. See \code{\link{readlogfile}} for details.}
  \item{sandbox}{Optionally execute the request in the MTurk sandbox rather than the live server.  Default is \code{FALSE}.}
}
\details{
A very robust function to assign a Qualification to one or more workers. The simplest use of the function is to assign a Qualification of the specified value to one worker, but assignment to multiple workers is possible. Workers can be assigned a Qualification previously created by \code{\link{CreateQualificationType}} or with the characteristics of a new QualificationType specified atomically. Qualifications can also be assigned conditional on each worker's value of a specified statistic (including assigning the value of the specified statistic as the worker's score for the Qualification).

\code{AssignQualifications()} and \code{assignqual()} are aliases.
}
\value{A dataframe containing the list of workers, the QualificationTypeId, the value each worker was assigned, whether they were notified of their QualificationType assignment, and whether the request was valid.}
\references{
\href{http://docs.amazonwebservices.com/AWSMechTurk/latest/AWSMturkAPI/ApiReference_AssignQualificationOperation.html}{API Reference}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{\link{CreateQualificationType}}

\code{\link{UpdateQualificationScore}}
}
\examples{
\dontrun{
# assign qualification to single worker
a <- AssignQualification("2YCIA0RYNJ9262B1D82MPTUEXAMPLE","A1RO9UJNWXMU65",values="50")

# assign a new qualification (defined atomically) to multiple workers
b <- AssignQualification(
workers=c("A1RO9UJNWXMU65","A9MZ9UJN4DMU78"),
title="Worked for me before",
description="This qualification is for people who have worked for me before",
keywords="Worked for me before")

# assign a qualification to a list of workers based upon their worker statistics
c <- AssignQualification("2YCIA0RYNJ9262B1D82MPTUEXAMPLE",
workers=c("A1RO9UJNWXMU65","A9MZ9UJN4DMU78","AE4Q9UYN4UI97D"),
conditional.statistic="NumberAssignmentsApproved",
conditional.comparator=">", conditional.value="5", 
conditional.period="LifeToDate", set.statistic.as.value=TRUE)
}
}
\keyword{Qualifications}