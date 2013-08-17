package TweetYouTubeUploadstream::Callbacks;
use strict;

sub _cb_ts_tweetyoutubeuploadstream_config_blog {
	my ( $cb, $app, $tmpl ) = @_;
	my $app_uri = $app->base . $app->uri;
	$$tmpl =~ s/\*app_uri\*/$app_uri/;
}

1;
