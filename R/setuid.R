#' Get/Set UID
#' 
#' Wrappers for getuid and setuid in Linux.
#' 
#' @param uid UID or username as specified in /etc/passwd
#' @param verbose print some C output (TRUE/FALSE)
#' @aliases getuid
#' @references http://manpages.ubuntu.com/manpages/precise/man2/setuid.2.html
#' @export setuid getuid
setuid <- function(uid, verbose=FALSE){
	if(is.character(uid)){
		uid <- userinfo(uid)$uid
	}
	verbose <- as.integer(verbose);
	uid <- as.integer(uid);
	ret <- integer(1);
	output <- .C('setuid_wrapper', ret, uid, verbose, PACKAGE="RAppArmor")
	
	if(output[[1]] != 0) {
		ermsg <- errno(output[[1]]);
		ermsg <- switch(ermsg,
			EAGAIN = "This uid brings processover its RLIMIT_NPROC resource limit.",
			EPERM = "The user is not privileged (CAP_SETUID). Usually only root can use setuid.",
			ermsg
		);
		stop("Failed to set uid. ", ermsg);
	}		
	invisible();	
}

getuid <- function(){
	ret <- integer(1);
	output <- .C('getuid_wrapper', ret, PACKAGE="RAppArmor")
	return(output[[1]]);
}
