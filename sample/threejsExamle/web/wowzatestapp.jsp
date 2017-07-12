
<html>
  <head>
    <title>HTML5 VOD Streaming Test</title>
    <script type="text/javascript" src="//player.wowza.com/player/latest/wowzaplayer.min.js"></script>
  </head>
  <body>
  <div id="playerElement" style="width:100%; height:0; padding:0 0 56.25% 0"></div>
  
    
  <script type="text/javascript">
WowzaPlayer.create('playerElement',
    {
    "license":"PLAY1-deuuX-yhvdH-uacCR-yPMhN-uR89T",
    "title":"",
    "description":"",
    "sourceURL":"http%3A%2F%2F192.168.1.164%3A1935%2Fvodtest%2F_definst_%2Fmp4%3Asample.mp4%2Fplaylist.m3u8",
    "autoPlay":false,
    "volume":"75",
    "mute":false,
    "loop":false,
    "audioOnly":false,
    "uiShowQuickRewind":true,
    "uiQuickRewindSeconds":"30"
    }
);
</script>
  </body>
</html>
