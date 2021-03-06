DisableHIT <-
disable <-
function (hit = NULL, hit.type = NULL, response.group = NULL, 
    keypair = credentials(), print = TRUE, browser = FALSE, log.requests = TRUE, 
    sandbox = FALSE) 
{
    if (!is.null(keypair)) {
        keyid <- keypair[1]
        secret <- keypair[2]
    }
    else stop("No keypair provided or 'credentials' object not stored")
    operation <- "DisableHIT"
    if (!is.null(response.group)) {
        if (!response.group %in% c("Minimal", "HITQuestion", 
            "HITDetail", "HITAssignmentSummary")) 
            stop("ResponseGroup must be in c(Minimal,HITQuestion,HITDetail,HITAssignmentSummary)")
    }
    if ((is.null(hit) & is.null(hit.type)) | (!is.null(hit) & 
        !is.null(hit.type))) 
        stop("Must provide 'hit' xor 'hit.type'")
    else if (!is.null(hit)) {
        hitlist <- hit
    }
    else if (!is.null(hit.type)) {
        hitsearch <- SearchHITs(keypair = keypair, print = FALSE, 
            log.requests = log.requests, sandbox = sandbox, return.qual.dataframe = FALSE)
        hitlist <- hitsearch$HITs[hitsearch$HITs$HITTypeId == 
            hit.type, ]$HITId
        if (length(hitlist) == 0) 
            stop("No HITs found for HITType")
    }
    HITs <- data.frame(matrix(ncol = 2))
    names(HITs) <- c("HITId", "Valid")
    for (i in 1:length(hitlist)) {
        GETiteration <- paste("&HITId=", hitlist[i], sep = "")
        if (!is.null(response.group)) {
            if (length(response.group) == 1) 
                GETiteration <- paste(GETiteration, "&ResponseGroup=", 
                  response.group, sep = "")
            else {
                for (i in 1:length(response.group)) {
                  GETiteration <- paste(GETiteration, "&ResponseGroup", 
                    i - 1, "=", response.group[i], sep = "")
                }
            }
        }
        auth <- authenticate(operation, secret)
        if (browser == TRUE) {
            request <- request(keyid, auth$operation, auth$signature, 
                auth$timestamp, GETiteration, browser = browser, 
                sandbox = sandbox)
        }
        else {
            request <- request(keyid, auth$operation, auth$signature, 
                auth$timestamp, GETiteration, log.requests = log.requests, 
                sandbox = sandbox)
            if (request$valid == TRUE) {
                if (is.null(response.group)) 
                  request$ResponseGroup <- c("Minimal")
                else request$ResponseGroup <- response.group
                HITs[i, ] = c(hitlist[i], request$valid)
                if (print == TRUE) 
                  cat(i, ": HIT ", hitlist[i], " Disabled\n", 
                    sep = "")
            }
            else if (request$valid == FALSE & print == TRUE) {
                cat(i, ": Invalid Request for HIT ", hitlist[i], 
                  "\n", sep = "")
            }
        }
    }
    if (print == TRUE) 
        return(HITs)
    else invisible(HITs)
}
