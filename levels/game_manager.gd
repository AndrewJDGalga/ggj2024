extends Node2D

class_name Game_Manager

enum PLAY_STATE {LINE_UP, CASTING, CATCHING, STANDUP_SITDOWN, WALKING, WRESTLING}
var cur_state : PLAY_STATE = PLAY_STATE.LINE_UP

