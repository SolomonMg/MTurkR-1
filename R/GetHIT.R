GetHIT <-
gethit <-
hit <-
function (hit, response.group = NULL, keypair = credentials(), 
    print = TRUE, browser = FALSE, log.requests = TRUE, sandbox = FALSE, 
    return.hit.dataframe = TRUE, return.qual.dataframe = TRUE) 
{
    if (!is.null(keypair)) {
        keyid <- keypair[1]
        secret <- keypair[2]
    }
    else stop("No keypair provided or 'credentials' object not stored")
    operation <- "GetHIT"
    GETparameters <- paste("&HITId=", hit, sep = "")
    if (!is.null(response.group)) {
        if (!response.group %in% c("Request", "Minimal", "HITDetail", 
            "HITQuestion", "HITAssignmentSummary")) 
            stop("ResponseGroup must be in c(Request,Minimal,HITDetail,HITQuestion,HITAssignmentSummary)")
        if (length(response.group) == 1) 
            GETparameters <- paste(GETparameters, "&ResponseGroup=", 
                response.group, sep = "")
        else {
            for (i in 1:length(response.group)) {
                GETparameters <- paste(GETparameters, "&ResponseGroup", 
                  i - 1, "=", response.group[i], sep = "")
            }
        }
    }
    auth <- authenticate(operation, secret)
    if (browser == TRUE) {
        request <- request(keyid, auth$operation, auth$signature, 
            auth$timestamp, GETparameters, browser = browser, 
            sandbox = sandbox)
    }
    else {
        request <- request(keyid, auth$operation, auth$signature, 
            auth$timestamp, GETparameters, log.requests = log.requests, 
            sandbox = sandbox)
        if (request$valid == TRUE) {
            z <- HITsToDataFrame(xml = request$xml)
            if (print == TRUE) 
                cat("HIT (", hit, ") Retrieved\n", sep = "")
            if (return.hit.dataframe == TRUE & return.qual.dataframe == 
                TRUE) 
                return.list <- list(HITs = z$HITs, QualificationRequirements = z$QualificationRequirements)
            else if (return.hit.dataframe == TRUE & return.qual.dataframe == 
                FALSE) 
                return.list <- list(HITs = z$HITs)
            else if (return.hit.dataframe == FALSE & return.qual.dataframe == 
                TRUE) 
                return.list <- list(QualificationRequirements = z$QualificationRequirements)
            else return.list <- NULL
        }
        else {
            if (print == TRUE) 
                cat("No HITs Retrieved\n", sep = "")
            return.list <- NULL
        }
        invisible(return.list)
    }
}
