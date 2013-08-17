package TweetYouTubeUploadstream::CMS;
use strict;

use Digest::SHA1 qw( sha1_base64 );
use Net::OAuth;
use TweetYouTubeUploadstream::Util;

sub _mode_tweetyoutubeuploadstream_oauth {
    my $app = shift;
    my $plugin = MT->component( 'TweetYouTubeUploadstream' );
    my $blog = $app->blog or return $app->errtrans( 'Invalid request.' );
    my $blog_id = $blog->id;
    my $tmpl = $plugin->load_tmpl( 'oauth_start.tmpl' );
    my $request_url = 'https://api.twitter.com/oauth/request_token';
    my $request_method = 'GET';
    my $request = Net::OAuth->request( "request token" )->new(
        consumer_key => $plugin->get_config_value( 'consumer_key' ),
        consumer_secret => $plugin->get_config_value( 'consumer_secret' ),
        request_url => $request_url,
        request_method => $request_method,
        signature_method => 'HMAC-SHA1',
        timestamp => time(),
        nonce => sha1_base64( time() . $$ . rand() ),
    );    
    $request->sign;
    $request->verify;
    my $ua = MT->new_ua;
    my $http_header = HTTP::Headers->new( 'Authorization' => $request->to_authorization_header );
    my $http_request = HTTP::Request->new( $request_method, $request_url, $http_header );
    my $res = $ua->request( $http_request );
    if ( $res->is_success ) {
        my $content = $res->decoded_content();
        my ( $request_token ) = $content =~ /(?:\A|&)oauth_token=(.*?)(?:&|\z)/;
        my ( $request_token_secret ) = $content =~ /(?:\A|&)oauth_token_secret=(.*?)(?:&|\z)/;
        my $authorize_url = 'https://api.twitter.com/oauth/authorize?oauth_token=' . $request_token;
        $tmpl->param( 'access_url' => $authorize_url );
        $tmpl->param( 'request_token' => $request_token );
        $tmpl->param( 'request_token_secret' => $request_token_secret );
    } else {
         $tmpl->param( 'error_authorization' => 1 );
    }
     return $tmpl; 
}

sub _mode_tweetyoutubeuploadstream_access_token {
    my $app = shift;
    my $plugin = MT->component( 'TweetYouTubeUploadstream' );
    my $blog = $app->blog or return $app->errtrans( 'Invalid request.' );
    my $blog_id = $blog->id;
    my $tmpl = $plugin->load_tmpl( 'oauth_finished.tmpl' );
    my $request_url = 'https://api.twitter.com/oauth/access_token';
    my $request_method = 'POST';
    my $request = Net::OAuth->request( "access token" )->new(
        consumer_key => $plugin->get_config_value( 'consumer_key' ),
        consumer_secret => $plugin->get_config_value( 'consumer_secret' ),
        request_url => $request_url,
        request_method => $request_method,
        signature_method => 'HMAC-SHA1',
        timestamp => time(),
        nonce => sha1_base64( time() . $$ . rand() ),
        token => $app->param( 'request_token' ),
        token_secret => $app->param( 'request_token_secret' ),
    );
    $request->sign;
    $request->verify;
    my $ua = MT->new_ua;
    my $http_header = HTTP::Headers->new( 'Authorization' => $request->to_authorization_header );
    my $http_request = HTTP::Request->new( $request_method, $request_url, $http_header );
    $http_request->content( $request->to_post_body . '&oauth_verifier=' . $app->param( 'tweetyoutubeuploadstream_pin' ) );
    $http_request->content_type( 'application/x-www-form-urlencoded' );
    my $res = $ua->request( $http_request );
    if ( $res->is_success ) {
        my $response = Net::OAuth->response( 'access token' )->from_post_body( $res->content );
        my $hash = $response->to_hash;
        $tmpl->param( 'verified_screen_name' => $hash->{ screen_name } );
        $tmpl->param( 'verified_user_id' => $hash->{ user_id } );
        $plugin->set_config_value( 'access_token', $hash->{ oauth_token } , 'blog:' . $blog_id );
        $plugin->set_config_value( 'access_token_secret', $hash->{ oauth_token_secret }, 'blog:' . $blog_id );
    } else {
        $tmpl->param( 'error_verification' => 1 );
    }
    $tmpl;
}


1;
