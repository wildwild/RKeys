@echo off
setlocal enabledelayedexpansion 

set ip=127.0.0.1
set port=6379
set ptn=*

set cur_p=""

set d=1

set name=%0

@REM goto eof

echo ---------------------------


:loop
IF not "%1"=="" (
    if "%1" == "--help" (
        echo %name% pattren of redis keys [-h ip] [-p port]
        echo this cmd will get all the keys match the pattern and output the  keys and values
        goto eof
    )
    
    IF "%1"=="-h" (
        if not "%2"=="" (
            SET ip=%2
            SHIFT
        )
    ) else (
    IF "%1"=="-p" (
        if not "%2"=="" (
            SET port=%2
            SHIFT
        )
    ) else (

        set unknown_p=%1
        @REM echo unknown_p --- !unknown_p!

        if "!unknown_p:~0,1!"=="-" (
            @REM echo unknown para !unknown_p! pass 
            SHIFT

        set unknown_p=%2
            if "!unknown_p:~0,1!"=="-"  (
            goto loop
            ) else (
        @REM echo unknown value  !unknown_p! pass
                SHIFT
                goto loop
            )
        ) else (

            @REM echo ---------------------%1
            if not "%1"=="" (
                set ptn=%1
                echo now parsing %1 ,will recover previous values
            ) )
        )
    )
    SHIFT

    GOTO :loop
)


echo %ip% %port% 

echo now dealing pattern is [%ptn%]


echo ---------------------------

set result=
set n=0

(for /f "delims=" %%i in ('redis-cli -h %ip% -p %port% keys %ptn%') do (  
    set keys=!keys! %%i
    set result[!n!].k=%%i
    @REM echo !result[!!n!!].k!
    set /A n+=1
))

if %n%==0 (
    goto eof
)

@REM echo "-----------" %keys%

set n=0
(for /f "delims=" %%i in ('redis-cli -h %ip% -p %port% mget %keys%') do (    
    set result[!n!].v=%%i
    set /A n+=1
))

echo dealing result is below
echo ************

@REM echo %result[0].v% %result[1].v% %result[2].v%


@rem tail is included
set /A n-=1  
set k=0
for  /l %%x in (0,1,%n%) do (
    @REM echo %%x "------"
    echo !result[%%x].k! : !result[%%x].v!
)

    
echo ---------------------------

:eof

@REM xcopy d:mp3 e:mp3 /s/e/i/y
