%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.21.1

-ifndef(proto_game).
-define(proto_game, true).

-define(proto_game_gpb_version, "4.21.1").


-ifndef('STARTGAMEREQ_PB_H').
-define('STARTGAMEREQ_PB_H', true).
-record('StartGameReq',
        {
        }).
-endif.

-ifndef('STARTGAMERESP_PB_H').
-define('STARTGAMERESP_PB_H', true).
-record('StartGameResp',
        {err_code = 0           :: integer() | undefined % = 1, optional, 32 bits
        }).
-endif.

-ifndef('GAMEOVERREQ_PB_H').
-define('GAMEOVERREQ_PB_H', true).
-record('GameOverReq',
        {
        }).
-endif.

-ifndef('GAMEOVERRESP_PB_H').
-define('GAMEOVERRESP_PB_H', true).
-record('GameOverResp',
        {err_code = 0           :: integer() | undefined % = 1, optional, 32 bits
        }).
-endif.

-ifndef('GAMEQUITREQ_PB_H').
-define('GAMEQUITREQ_PB_H', true).
-record('GameQuitReq',
        {
        }).
-endif.

-ifndef('GAMEQUITRESP_PB_H').
-define('GAMEQUITRESP_PB_H', true).
-record('GameQuitResp',
        {err_code = 0           :: integer() | undefined % = 1, optional, 32 bits
        }).
-endif.

-ifndef('SYNCGAMEOVERSTATERESP_PB_H').
-define('SYNCGAMEOVERSTATERESP_PB_H', true).
-record('SyncGameOverStateResp',
        {
        }).
-endif.

-ifndef('SYNCPACKDATAREQ_PB_H').
-define('SYNCPACKDATAREQ_PB_H', true).
-record('SyncPackDataReq',
        {pack_type = 'None'     :: 'None' | 'Level' | 'NewLevel' | 'LevelRefresh' | 'InitPlayerInfo' | integer() | undefined, % = 1, optional, enum PackType
         pack_data = <<>>       :: iodata() | undefined % = 2, optional
        }).
-endif.

-ifndef('SYNCPACKDATARESP_PB_H').
-define('SYNCPACKDATARESP_PB_H', true).
-record('SyncPackDataResp',
        {pack_type = 'None'     :: 'None' | 'Level' | 'NewLevel' | 'LevelRefresh' | 'InitPlayerInfo' | integer() | undefined, % = 1, optional, enum PackType
         pack_data = <<>>       :: iodata() | undefined % = 2, optional
        }).
-endif.

-endif.