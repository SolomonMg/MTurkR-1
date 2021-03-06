UpdateQualificationScore <-
updatequalscore <-
function (qual, workers, values = NULL, increment = NULL, keypair = credentials(), 
    print = TRUE, browser = FALSE, log.requests = TRUE, sandbox = FALSE) 
{
    if (!is.null(keypair)) {
        keyid <- keypair[1]
        secret <- keypair[2]
    }
    else stop("No keypair provided or 'credentials' object not stored")
    operation <- "UpdateQualificationScore"
    if (!is.null(increment)) {
        values <- NA
        score <- NA
        for (i in 1:length(workers)) {
            score[i] <- GetQualificationScore(qual, workers[i], 
                keypair = keypair, log.requests = log.requests, 
                sandbox = sandbox)$Value[1]
            if (is.null(score[i]) || is.na(score[i])) 
                score[i] <- 0
        }
        values <- as.numeric(score) + as.numeric(increment)
    }
    if (!is.null(values)) {
        for (i in 1:length(values)) {
            if (!is.numeric(as.numeric(values[i]))) 
                stop("Value is non-numeric or not coercible to numeric")
        }
        if (length(values) == 1) 
            values <- rep(values[1], length(workers))
        if (!length(workers) == length(values)) 
            stop("!length(workers)==length(values)")
    }
    else stop("Value(s) is/are missing")
    Qualifications <- data.frame(matrix(nrow = length(workers), 
        ncol = 4))
    names(Qualifications) <- c("QualificationTypeId", "WorkerId", 
        "Value", "Valid")
    for (i in 1:length(workers)) {
        GETparameters <- paste("&QualificationTypeId=", qual, 
            "&SubjectId=", workers[i], "&IntegerValue=", values[i], 
            sep = "")
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
            Qualifications[i, ] <- c(qual, workers[i], values[i], 
                request$valid)
            if (request$valid == TRUE) {
                if (print == TRUE) 
                  cat(i, ": Qualification Score for Worker ", 
                    workers[i], " updated to ", values[i], "\n", 
                    sep = "")
            }
            else if (request$valid == FALSE) {
                if (print == TRUE) 
                  cat(i, ": Invalid Request for worker ", workers[i], 
                    "\n")
            }
        }
    }
    if (print == TRUE) 
        cat(i, " Qualification Scores Updated\n", sep = "")
    invisible(Qualifications)
}
