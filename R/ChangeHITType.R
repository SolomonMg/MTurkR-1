ChangeHITType <-
changehittype <-
function (hit = NULL, old.hit.type = NULL, new.hit.type = NULL, 
    title = NULL, description = NULL, reward = NULL, duration = NULL, 
    keywords = NULL, auto.approval.delay = NULL, qual.req = NULL, 
    keypair = credentials(), print = TRUE, browser = FALSE, log.requests = TRUE, 
    sandbox = FALSE) 
{
    if (!is.null(keypair)) {
        keyid <- keypair[1]
        secret <- keypair[2]
    }
    else stop("No keypair provided or 'credentials' object not stored")
    operation <- "ChangeHITTypeOfHIT"
    if ((is.null(hit) & is.null(old.hit.type)) | (!is.null(hit) & 
        !is.null(old.hit.type))) 
        stop("Must provide 'hit' xor 'old.hit.type'")
    if (!is.null(new.hit.type)) {
        if (!is.null(new.hit.type) & (!is.null(title) || !is.null(description) || 
            !is.null(reward) || !is.null(duration))) 
            warning("HITType specified, HITType parameters (title, description, reward, duration) ignored")
    }
    else {
        if (is.null(title) || is.null(description) || is.null(reward) || 
            is.null(duration)) 
            stop("Must specify new HITType xor new HITType parameters (title, description, reward, duration)")
        else {
            register <- RegisterHITType(keypair, title, description, 
                reward, duration, keywords = keywords, auto.approval.delay = auto.approval.delay, 
                qual.req = qual.req, print = print, log.requests = log.requests, 
                sandbox = sandbox)
            if (register$valid == FALSE) 
                stop("Could not RegisterHITType(), check parameters")
            else new.hit.type <- register$HITTypeId
        }
    }
    if (!is.null(hit)) {
        hitlist <- hit
    }
    else if (!is.null(old.hit.type)) {
        hitsearch <- SearchHITs(keypair = keypair, print = FALSE, 
            log.requests = log.requests, sandbox = sandbox, return.qual.dataframe = FALSE)
        hitlist <- hitsearch$HITs[hitsearch$HITs$HITTypeId == 
            old.hit.type, ]$HITId
        if (length(hitlist) == 0) 
            stop("No HITs found for HITType")
    }
    HITs <- data.frame(matrix(ncol = 4))
    names(HITs) <- c("HITId", "oldHITTypeId", "newHITTypeId", 
        "Valid")
    for (i in 1:length(hitlist)) {
        GETparameters <- paste("&HITId=", hitlist[i], "&HITTypeId=", 
            new.hit.type, sep = "")
        auth <- authenticate(operation, secret)
        if (browser == TRUE) {
            x <- request(keyid, auth$operation, auth$signature, 
                auth$timestamp, GETparameters, browser = browser, 
                sandbox = sandbox)
        }
        else {
            x <- request(keyid, auth$operation, auth$signature, 
                auth$timestamp, GETparameters, log.requests = log.requests, 
                sandbox = sandbox)
            if (is.null(old.hit.type)) 
                HITs[i, ] <- c(hitlist[i], NA, new.hit.type, 
                  x$valid)
            else HITs[i, ] <- c(hitlist[i], old.hit.type, new.hit.type, 
                x$valid)
            if (print == TRUE) {
                if (x$valid == TRUE) {
                  cat(i, ": HITType of HIT ", hitlist[i], " Changed to: ", 
                    new.hit.type, "\n", sep = "")
                }
                else if (x$valid == FALSE) {
                  cat(i, ": Invalid Request for HIT ", hitlist[i], 
                    "\n", sep = "")
                }
            }
        }
    }
    if (print == TRUE) 
        return(HITs)
    else invisible(HITs)
}
