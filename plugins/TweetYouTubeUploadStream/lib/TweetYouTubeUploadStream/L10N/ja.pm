package TweetYouTubeUploadstream::L10N::ja;
use strict;
use base qw( TweetYouTubeUploadstream::L10N MT::L10N MT::Plugin::L10N );
use vars qw( %Lexicon );

%Lexicon = (
    'Tweet new uploaded video of YouTube account.' => 'タスク実行によって自動的に YouTube に新しくアップロードした動画をツイートします。',
    'TweetYouTubeUploadstream Task' => 'TweetYouTubeUploadstream のタスク',
    'Failed to get response from [_1], ([_2])' => '[_1]から応答を得られません。([_2])',
    'Authorize error' => '認証エラー',
    'Authorize this plugin and enter the PIN#.' => 'アプリケーションの認証を行い、取得されるPIN番号を入力してください。',
    'Get authentication' => '認証を行う',
    'Done' => '実行',
    'Authentication' => '認証',
    'You need authentication about Twitter.' => 'Twitter への認証を行う',
    'Authentication finished.' => '認証が完了しました。ダイアログを閉じると画面の再読み込みが行われます。',
    'Authentication failed.' => '認証に失敗しました。',
    'Already authenticated.' => 'すでに認証されています。',
    'Get authentication again.' => '再度認証を行う',
    'Settings for Twitter' => 'Twitter に関する設定',
    'Settings for YouTube' => 'YouTube に関する設定',
    'YouTube account' => 'YouTube アカウント',
    'Tweet format' => 'ツイートのフォーマット',
    'Update twitter success: [_1]' => 'ツイートしました: [_1]',
    'Tweet limit' => 'ツイートの最大数',
);

1;
