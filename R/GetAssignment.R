assignment <-
assignments <-
GetAssignment <-
GetAssignments <-
function (assignment = NULL, hit = NULL, hit.type = NULL, status = NULL, 
    return.all = FALSE, pagenumber = "1", pagesize = "10", sortproperty = "SubmitTime", 
    sortdirection = "Ascending", response.group = NULL, keypair = credentials(), 
    print = TRUE, browser = FALSE, log.requests = TRUE, sandbox = FALSE, 
    return.assignment.dataframe = TRUE) 
{
    if (!is.null(keypair)) {
        keyid <- keypair[1]
        secret <- keypair[2]
    }
    else stop("No keypair provided or 'credentials' object not stored")
    if (!sortproperty %in% c("AcceptTime", "SubmitTime", "AssignmentStatus")) 
        stop("'sortproperty' must be 'AcceptTime' | 'SubmitTime' | 'AssignmentStatus'")
    if (!sortdirection %in% c("Ascending", "Descending")) 
        stop("'sortdirection' must be 'Ascending' | 'Descending'")
    if (as.numeric(pagesize) < 1 || as.numeric(pagesize) > 100) 
        stop("'pagesize' must be in range (1,100)")
    if (as.numeric(pagenumber) < 1) 
        stop("'pagenumber' must be > 1")
    GETresponsegroup <- ""
    if (!is.null(response.group)) {
        if (!is.null(assignment)) {
            if (!response.group %in% c("Request", "Minimal", 
                "AssignmentFeedback", "HITDetail", "HITQuestion")) 
                stop("ResponseGroup must be in c(Request,Minimal,AssignmentFeedback,HITDetail,HITQuestion)")
        }
        else {
            if (!response.group %in% c("Request", "Minimal", 
                "AssignmentFeedback")) 
                stop("ResponseGroup must be in c(Request,Minimal,AssignmentFeedback)")
        }
        if (length(response.group) == 1) 
            GETresponsegroup <- paste("&ResponseGroup=", response.group, 
                sep = "")
        else {
            for (i in 1:length(response.group)) {
                GETresponsegroup <- paste("&ResponseGroup", i - 
                  1, "=", response.group[i], sep = "")
            }
        }
    }
    if (!is.null(assignment)) {
        operation <- "GetAssignment"
        for (i in 1:length(assignment)) {
            GETparameters = paste("&AssignmentId=", assignment[i], 
                GETresponsegroup, sep = "")
            auth <- authenticate(operation, secret)
            if (browser == TRUE) {
                request <- request(keyid, auth$operation, auth$signature, 
                  auth$timestamp, GETparameters, browser = browser, 
                  sandbox = sandbox, log.requests = log.requests)
            }
            else {
                request <- request(keyid, auth$operation, auth$signature, 
                  auth$timestamp, GETparameters, log.requests = log.requests, 
                  sandbox = sandbox)
                QualificationRequirements <- list()
                if (request$valid == TRUE) {
                  a <- AssignmentsToDataFrame(xml = request$xml)$assignments
                  #h <- HITsToDataFrame(xml = request$xml)
                  a$Answer <- NULL
                  if (i == 1) {
                    Assignments <- a
                    #HITs <- h$HITs
                    #QualificationRequirements <- h$QualificationRequirements
                  }
                  else {
                    Assignments <- merge(Assignments, a, all=TRUE)
                    #HITs <- merge(HITs, h$HITs,all=TRUE)
                    #QualificationRequirements <- c(QualificationRequirements, 
                    #  h$QualificationRequirements)
                  }
                  if (print == TRUE) 
                    cat(i, ": Assignment ", assignment[i], " Retrieved\n", 
                      sep = "")
                }
			}
        }
		invisible(Assignments)#, HITs = HITs, 
			#QualificationRequirements = QualificationRequirements))
    }
    else {
        operation <- "GetAssignmentsForHIT"
        if ((is.null(hit) & is.null(hit.type)) | (!is.null(hit) & 
            !is.null(hit.type))) 
            stop("Must provide 'assignment' xor 'hit' xor 'hit.type'")
        else if (!is.null(hit)) {
            hitlist <- hit
        }
        else if (!is.null(hit.type)) {
            hitsearch <- SearchHITs(keypair = keypair, print = FALSE, 
                log.requests = log.requests, sandbox = sandbox, 
                return.qual.dataframe = FALSE)
            hitlist <- hitsearch$HITs$HITId[hitsearch$HITs$HITTypeId==hit.type]
			if (length(hitlist) == 0)
                stop("No HITs found for HITType")
        }
        if (return.all == TRUE | length(hitlist)>1) {
            sortproperty <- "SubmitTime"
            sortdirection <- "Ascending"
            pagesize <- "100"
            pagenumber <- "1"
        }
        batch <- function(batchhit, pagenumber) {
            GETiteration <- ""
            if (!is.null(status)) {
                if (status %in% c("Approved", "Rejected", "Submitted")) 
                  GETiteration <- paste(GETiteration, "&AssignmentStatus=", 
                    status, GETresponsegroup, sep = "")
                else
					status <- NULL
            }
            GETiteration <- paste("&HITId=", batchhit, "&PageNumber=", 
                pagenumber, "&PageSize=", pagesize, "&SortProperty=", 
                sortproperty, "&SortDirection=", sortdirection, 
                GETiteration, sep = "")
            auth <- authenticate(operation, secret)
            batch <- request(keyid, auth$operation, auth$signature, 
                auth$timestamp, GETiteration, log.requests = log.requests, 
                sandbox = sandbox)
            batch$total <- as.numeric(strsplit(strsplit(batch$xml, 
                "<TotalNumResults>")[[1]][2], "</TotalNumResults>")[[1]][1])
            batch$batch.total <- length(xpathApply(xmlParse(batch$xml), 
                "//Assignment"))
            if (batch$batch.total > 0 & return.assignment.dataframe == TRUE) {
                batch$assignments <- AssignmentsToDataFrame(xml = batch$xml)$assignments
                batch$assignments$Answer <- NULL
            }
            else if (batch$batch.total > 0 & return.assignment.dataframe == 
                FALSE) 
                batch$assignments <- NULL
            else
				batch$assignments <- NA
            return(batch)
        }
        cumulative <- 0
		for (i in 1:length(hitlist)) {
            if (i == 1){
				request <- batch(hitlist[i], pagenumber)
				runningtotal <- request$batch.total
			}
			else{
				pagenumber <- 1
				nextrequest <- batch(hitlist[i], pagenumber)
				request$total <- request$total + nextrequest$total
#				request$request.id <- c(request$request.id, 
#                    nextrequest$request.id)
#				request$request.url <- c(request$request.url, 
#                    nextrequest$request.url)
#				request$valid <- c(request$valid, nextrequest$valid)
#				request$xml <- c(request$xml, nextrequest$xml)
				if (return.assignment.dataframe == TRUE) 
                    request$assignments <- merge(request$assignments, 
                      nextrequest$assignments, all=TRUE)
				request$pages.returned <- pagenumber
                runningtotal <- nextrequest$batch.total
			}
            if (return.all == TRUE) {
				pagenumber <- 2
                while (request$total > runningtotal) {
					nextbatch <- batch(hitlist[i], pagenumber)
#					request$request.id <- c(request$request.id, 
#						nextbatch$request.id)
#					request$request.url <- c(request$request.url, 
#						nextbatch$request.url)
#					request$valid <- c(request$valid, nextbatch$valid)
#					request$xml <- c(request$xml, nextbatch$xml)
					if (return.assignment.dataframe == TRUE) 
						request$assignments <- merge(request$assignments, 
						  nextbatch$assignments, all=TRUE)
					request$pages.returned <- pagenumber
					runningtotal <- runningtotal + nextbatch$batch.total
					pagenumber <- pagenumber + 1
                }
            }
			cumulative <- cumulative + runningtotal
			request$batch.total <- NULL
			if (!is.null(hit.type))
				request$assignments$HITTypeId <- hit.type
        }
        if (print == TRUE) 
            cat(cumulative, " of ", request$total, " Assignments Retrieved\n", 
                sep = "")
        invisible(request$assignments)
    }
}
