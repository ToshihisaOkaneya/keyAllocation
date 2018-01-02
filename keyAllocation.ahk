#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force	;このスクリプトが再度呼び出されたらリロードして置き換え
#InstallKeybdHook		;virtual key/scan code確認用
#Persistent
#UseHook


;無変換+[hjkl] => 左下上右
;無変換+ctrl+[hjkl] => shift+左下上右

;無変換+(h or s) => 左
vk1Dsc07B & h::
;vk1Dsc07B & s::
	if GetKeyState("ctrl", "P"){
		Send +{Left}
	}else if GetKeyState("shift", "P"){
		Send ^{Left}
	}else{
		Send {Left}
	}
	return
;無変換+(j or d) => 下
vk1Dsc07B & j::
;vk1Dsc07B & d::
	if GetKeyState("ctrl", "P"){
		Send +{Down}
	}else if GetKeyState("shift", "P"){
		Send ^{Down}
	}else{
		if WinActive("ahk_class Framework::CFrame") {
			; One Noteで上下キーSendが効かないので代用
			Send ^{Down}
		} else {
			Send {Down}
		}
	}
	return
;無変換+(k or e) => 上
vk1Dsc07B & k::
;vk1Dsc07B & e::
	If GetKeyState("ctrl", "P"){
		Send +{Up}
	}else if GetKeyState("shift", "P"){
		Send ^{Up}
	}else{
		if WinActive("ahk_class Framework::CFrame") {
			; One Noteで上下キーSendが効かないので代用
			Send ^{Up}
		} else {
			Send {Up}
		}
	}
	return
;無変換+(l or f) => 右
vk1Dsc07B & l::
;vk1Dsc07B & f::
	If GetKeyState("ctrl", "P"){
		Send +{Right}
	}else if GetKeyState("shift", "P"){
		Send ^{Right}
	}else{
		Send {Right}
	}
	return


;無変換+m => 下に行を挿入
vk1Dsc07B & m::
	if WinActive("ahk_class SWT_Window0") {
		Send {Esc}
		Send {Esc}
	}
	Send {End}
	Send {Enter}
	return


;無変換+io => Home,End
vk1Dsc07B & i::
	if GetKeyState("ctrl", "P"){
		Send +{Home}
	}else if GetKeyState("shift", "P"){
		Send ^{Home}
	}else{
		Send {Home}
	}
	return

;無変換+o => End
vk1Dsc07B & o::
	if GetKeyState("ctrl", "P"){
		Send +{End}
	}else if GetKeyState("shift", "P"){
		Send ^{End}
	}else{
		Send {End}
	}
	return


;無変換+p => PageUp
;無変換+p+ctrl => Shift+PageUp
vk1Dsc07B & p::
	if GetKeyState("ctrl", "P"){
		Send +{pgup}
	}else if GetKeyState("alt", "P"){
		Send !{pgup}
	}else{
		Send {pgup}
	}
	return
;無変換+{;キー} => PageDown
;無変換+{;キー}+ctrl => Shift+PageDown
vk1Dsc07B & vkBBsc027::
	if GetKeyState("ctrl", "P"){
		Send +{pgdn}
	}else if GetKeyState("alt", "P"){
		Send !{pgdn}
	}else{
		Send {pgdn}
	}
	return

;変換+e => Esc
vk1Csc079 & e::
	Send {Esc}
	return

;アプリケーションキー+[ => page up
;アプリケーションキー+] => page down
;AppsKey+[ => PgUp
AppsKey & vkDBsc01B::Send {PgUp}
;AppsKey+] => PgDn
AppsKey & vkDDsc02B::Send {PgDn}

;メモ帳,excel,chrome,sakuraエディタではF1キー無効化
;F1=>半角/全角
F1::
	if WinActive("ahk_class Notepad")
	|| WinActive("ahk_class XLMAIN")
	|| WinActive("ahk_class Chrome_WidgetWin_1")
	|| WinActive("ahk_class TextEditorWindowW166") {
		return
	}
	Send {F1}
	return

;Excelでalt+p→ctrl+PageUp
!p::
	if WinActive("ahk_class XLMAIN") {
		Send ^{pgup}
	}
	return
;Excelでalt+:→ctrl+PageDown
!vkBBsc027::
	if WinActive("ahk_class XLMAIN") {
		Send ^{pgdn}
	}
	return
;Excel VBEでctrl+k→自動構文チェックon/off切り替え
^k::
	if WinActive("ahk_class wndclass_desked_gsk") {
		Send !t
		Send +o
		Send +k
		Send {Enter}
	} else {
		Send ^k
	}
	return

;メモ帳で ctrl+w=>alt+F4
;桜エディタで ctrl+w=>ctrl+F4
^w::
	if WinActive("ahk_class Notepad") {
		Send !{F4}
		return
	} else if WinActive("ahk_class TextEditorWindowW166") {
		Send ^{F4}
		return
	} else if WinActive("ahk_class TextEditorWindowW142") {
		Send ^{F4}
		return
	}
	Send ^w
	return
	
;eclipseでAlt+h=>Alt+左
!h::
	if WinActive("ahk_class SWT_Window0") {
		Send !{Left}
	}
	return
;eclipseでAlt+l=>Alt+右
!l::
	if WinActive("ahk_class SWT_Window0") {
		Send !{Right}
	}
	return

;右Win→Alt
vk5Csc15C::vkA4sc038

;chrome上でctrl+("+" or "-")による拡大無効化
#If WinActive("ahk_class Chrome_WidgetWin_1")
^vkBBsc027::
	return
^vkBDsc00C::
	return
#IfWinActive

;変換+無変換=>スクリプトリロード
vk1Dsc07B & vk1Csc079::Reload

;ctrl+vで張り付け(cygwin用)
;パスをコピペする時に \ → / に変換して貼り付け
#If WinActive("ahk_class mintty")
^v::
	sendStr := Clipboard
	num := RegExMatch(sendStr, "[a-zA-Z]:\\")
	if(num = 1){
		StringReplace, out, sendStr, \, /, All
		out := """" . out . """"
		PasteString(out)
	} else {
		PasteString(sendStr)
	}
	return
#IfWinActive

;ctrl+vで貼り付け(bash on Ubuntu on Windows)
#If WinActive("ahk_exe bash.exe")
^v::
	SendInput {Raw}%clipboard%
	return
#IfWinActive

;ctrl+vで張り付け(コマンドプロンプト用)
#If WinActive("ahk_exe cmd.exe")
^v::
	Send !{Space}ep	;貼り付け
	return
#IfWinActive

;;;;;;bootcamp対応;;;;;;

;無変換+e→英語
vk1Dsc07B & e::
	Send {sc03a}
	return

;変換+l→日本語
vk1Csc079 & l::
	Send {sc070}
	return

;無変換+d→delete
vk1Dsc07B & d::
	Send {Delete}
	return

;alt+F2→alt+F4
!F2::
	Send !{F4}
	return

;;;;;;util関数;;;;;;
;文字列張り付け用関数
PasteString(String){
	Backup := ClipboardAll
	Clipboard := String
	If WinActive("ahk_class mintty"){
		Send +{Insert}
	}else{
		Send ^v
	}
	Sleep,70
	Clipboard := Backup
}
