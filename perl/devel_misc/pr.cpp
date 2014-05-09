enum pr_status {
	PR_STATUS_RV,
	PR_STATUS_SV,
	PR_STATUS_RT_F
};

char *pr_errstr();
bool get_pr( int *prp );
pr_status check_pr( int pr );
void handle_pr_status_rv();
void reject_pr( bool with_tol );
void handle_error( const char *format, ... );

int main(int argc, char **argv) 
{
	int pr;

	if (!get_pr( &pr )) {
		handle_error("can't get pr: %s", pr_errstr() );
		return 1;
	}
	pr_status v = check_pr( pr );

	switch( v ) {
	case PR_STATUS_RV:
		handle_pr_status_rv();
		break;
	case PR_STATUS_SV:
		reject_pr( true );
		break;
	case PR_STATUS_RT_F:
		reject_pr( false );
		break;
	default:
		handle_error("unknown pr_status %d", v );
		reject_pr( false );
	
	}
}		

