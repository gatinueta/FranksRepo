const int MAX_PR_SNT = 1024;

/* TODO copied def. move to header */
enum pr_status {
        PR_STATUS_RV,
        PR_STATUS_SV,
        PR_STATUS_RT_F
};

static char *gl_errstr = "";

static void addrej(const char *reason) {
	/* TODO */
}

char *pr_errstr()  {
	return gl_errstr;
}

bool get_pr( int *prp ) {
	*prp = (*prp)*2;
	return (*prp)<=MAX_PR_SNT;
}

pr_status check_pr( int pr ) {
	if (pr%2 == 0) {
		return PR_STATUS_RV;
	} else if (pr == MAX_PR_SNT) {
		return PR_STATUS_RT_F;
	} else {
		return PR_STATUS_SV;
	}
}

void handle_pr_status_rv() {
	addrej("IGL");
}
void reject_pr( bool with_tol ) {
	/* TODO */
}

void handle_error( const char *format, ... ) {
	/* TODO */
}


