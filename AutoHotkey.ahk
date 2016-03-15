; AutoHotkey 注释
; ^  ctrl      # Win      ! alt       + Shift 
#Persistent
#SingleInstance Force
; #NoTrayIcon
#NoEnv 

; 闹钟 定时 14:52 
pm_H := 14 
pm_M := 52 
loops := 1 
; 5 分钟 循环一次 
SetTimer, Alarm, 300000 
Alarm:
    if (Mod(loops, 9) == 0) {
        MsgBox, 64, 工作提醒, 已经工作 40 分钟啦 -- 休息一下, 1
        Run, tool\pb.exe
    }
    If (loops == 1) {
    	Init()
    }
    pm_diff := (pm_H - A_Hour) * 60 + (pm_M - A_Min)
    if (pm_diff >0 && pm_diff <= 5) {
        Gupiao()
    }
    loops := loops + 1
Return

Init(){
    SetTitleMatchMode 2
    If !WinExist("ahk_exe QQProtect.exe") Or !WinExist("ahk_exe QQ.exe"){
        Run, D:\Program Files (x86)\Tencent\QQ\QQProtect\Bin\QQProtect.exe
    }
    Sleep, 5000 
    If !WinExist("ahk_exe Wiz.exe"){
        Run, G:\000\App\WizNote\Wiz.exe
    }
    Sleep, 5000
    If !WinExist("ahk_exe netbeans64.exe"){
        Run, C:\Program Files\NetBeans 8.0.2\bin\netbeans64.exe
    }
}

^!r::Reload
^!i::Run, G:\000

; 通用 热字串
:*:yh::「」

; PHP 语法快捷键
:*:ppe::<?php echo $data -> {;} ?>
:*:r4::$
:*:,.::->
:*:.;::{End};{Enter}
:*:[]::['']{Left}{Left}
:*:///::/** {Enter}
:*:/8::/**{Enter} * {Enter}*/{Up}

; 1.按键 替换
CapsLock::Enter
RAlt::AppsKey
+Capslock::Capslock
; 2.用键盘 模拟 鼠标 【上下左右】
; *#Up::MouseMove,0,-10,0,R
; *#Down::MouseMove,0,10,0,R
; *#Left::MouseMove,-10,0,0,R
; *#Right::MouseMove,10,0,0,R
; 3. 用键盘模拟鼠标 左右键单击
*#RCtrl::
    SendEvent {blind}{LButton down}
    KeyWait RCtrl
    SendEvent {blind}{LButton up}
return
*#AppsKey::
    SendEvent {blind}{RButton down}
    KeyWait AppsKey
    SendEvent {blind}{RButton up}
return
; 5.启动 常用程序
^!n::Run notepad
^!g::Gupiao()
; ^!t::Run E:\my software\Console\ConEmu64.exe
^!x::Run tool\QQ2012.exe
^!b::Run www.baidu.com
^!q::Run C:\Program Files (x86)\Tencent\QQ\QQProtect\Bin\QQProtect.exe
; ^!m::Run E:\my software\二维码.exe

^#w::Run E:\my software\WizNote\Wiz.exe

Gupiao() {
    Result := SubStr(UrlDownloadToVar("http://hq.sinajs.cn/list=s_sh000001"), 24, -3)
    Array := StrSplit(Result, ",")
    msg := ["指数名称", "当前点数", "当前价格", "涨 跌 率", "成交量（手）", "成交额（万元）"]
    for index, element in Array { 
        val .= msg[index] . " : " . element . "`n" 
    }
    RunWait, bin\wget.exe http://image.sinajs.cn/newchart/min/n/sh000001.gif -O tmp.gif, , Hide

    SplashImage, tmp.gif, M2 X1024 Y530 fs18, %val%
    Sleep, 60000
    SplashImage, Off
}

^!h::
    ;MsgBox 【Ctrl+Alt】^!n记事本 ^!t终端 ^!x截图 ^!b百度 ^!qQQ ^#w为知笔记 ^!y调试
return

; 6.HTTP
; 使用内置的UrlDownloadToFile命令，在多线程情况下，
; 很容易出现线程退出了，文件却没正常下载的情况。
; 在单进程情况下，很容易卡死在“牛杂网​”上。
; 速度亦远慢于此函数
UrlDownloadToVar(URL,Timeout=-1){
    ComObjError(0)
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", URL, true)   
    ; true为异步获取，默认是false，卡顿的根源！
    WebRequest.Send()
    WebRequest.WaitForResponse(Timeout) 
    ; 修改为异步获取后，平均获取网页速度大幅加快，故不再采用超时（Timeout=-1）。
    ; 在访问 ResponseText 之前调用 WaitForResponse 方法以确保获取的是完整的响应
    Return WebRequest.ResponseText()
}
