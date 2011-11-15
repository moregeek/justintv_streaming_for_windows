rem @echo off
rem **************************************
rem * Parameter einstellen:
rem **************************************
set BASE_FOLDER=C:\stream
set VLC=%BASE_FOLDER%\vlc\vlc.exe
set JTV=%BASE_FOLDER%\jtv\jtvlc.exe
set TEMP=%BASE_FOLDER%\temp

rem **************************************
rem * STREAM abhaengige Einstellungen
rem **************************************
set CAM=cam1
set PLAYLIST=%BASE_FOLDER%\playlist\playlist_%CAM%.xspf
set JTV_USERNAME=your_user_name
set JTV_STREAM_KEY=live_asdfasdfasdfasdfasdfasdfasdfasdfasdf


rem **************************************
rem * Einstellungen für Experten:
rem **************************************
set jtvResolution={width=530,height=300,aspect=16:9}
set jtvX264Param={profile=baseline,level=41,keyint=4,idrint=2}
set jtvBitrateFps=vb=600,fps=20,


rem **************************************
rem * vlc-player starten:
rem **************************************
echo Starting VLC Player...
start /min %VLC% -I dummy "file:///%PLAYLIST%" --extraintf=http --marq-opacity 70 --marq-size=11 --loop --sout-keep --sout-all --ffmpeg-fast --ffmpeg-hurry-up --sout="#transcode{venc=x264%jtvX264Param%,vcodec=h264,%jtvBitrateFps%acodec= mp3,ab=128,channels=2,samplerate=48000,audio-sync,sfilter='marq{marquee=$T,position=9}:marq{marquee=$N,position=8}:marq{ marquee=$L,position=10}',vfilter=canvas%jtvResolution%}:gather:rtp{dst=127.0.0.1,port=1234,sdp=file:///%TEMP%\vlc_stream_%CAM%.sdp}"


rem **************************************
rem * 8 sek. auf die sdp-datei warten:
rem **************************************
echo Waiting for dummy sdp file...
ping -n 8 127.0.0.1 >nul

rem **************************************
rem * jtvlc.exe starten:
rem **************************************
call %JTV% %JTV_USERNAME% %JTV_STREAM_KEY% "file://%TEMP%\vlc_stream_%CAM%.sdp"

pause
