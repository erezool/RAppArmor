#include <R.h>
#include <Rinternals.h>
#include <Rinterface.h>
#include <R_ext/Rdynload.h>
#include <sys/apparmor.h>
#include <errno.h>
#include <stdbool.h>

void aa_change_profile_wrapper (int *ret, char **profile, bool *verbose) {
  if(*verbose){
	  Rprintf("Switching profiles...\n");
  }
  *ret = aa_change_profile (*profile);
  if(*ret != 0){
    *ret = errno;
  }
}
