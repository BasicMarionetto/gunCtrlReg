//Diary record に下記説明文を記載してください。

//説明文
//GunControlRegulationScript
//武器を所持している時に敵に発見されている。<br/>
//何者かを殺害する場面を目撃されている。<br/>
//以上の場合敵に攻撃を受けます。<br/>
//武器はバックパックにある場合は判定されません。<br/>
//<br/>
//Copyright (c) 2019 Marionetto<br/>
//Released under the MIT license<br/>

//使い方
//パラメータ１ Unit 対象ユニット
//パラメータ２ Boolean 民間人も対象とするか？
//[this,true] execVM "gunCtrlReg.sqf";


//注意事項
//ratingに関する減算加算はすべて敵対行為をしたと判定されます。
//マルチプレイヤーの場合民間人ユニットが壁を貫通してプレイヤーを検知します。
//車両での轢き殺しは判定されづらいようです。

hint "GunControllRegulation Enable";

if(isDedicated || isServer) then {
	_user = _this select 0;
	_civExclusion = _this select 1;
	_detected = false;
	_knowVal = 0;
	_sideArray = [EAST,WEST,resistance,civilian];
	_sideArray = _sideArray - [side _user];
	if (_civExclusion) then {
		_sideArray = _sideArray - [civilian];
	};

	BNRG_fnc_setRating = {
		_setRating = _this select 0;
		_unit = _this select 1;
		_getRating = rating _unit;
		_addVal = _setRating - _getRating;
		_unit addRating _addVal;
	};//Create By Benargee

	while {!_detected} do {
		_priWeapon = primaryWeapon _user;
		_subWeapon = secondaryWeapon _user;
		_handWeapon = handgunWeapon _user;

		if (rating _user != 0 || _priWeapon != "" || _subWeapon != "" || _handWeapon != "") then {
			_user setCaptive false;
			{
				_knowVal = _x knowsAbout vehicle _user;
				if (_knowVal == 4) then {
					_detected = true;
				};
			} forEach _sideArray;//発見しているキャラクターがいるかの全件検索
			[0,_user] call BNRG_fnc_setRating;
		}else{
			_user setCaptive true;
		};
	//hint format ["%1",_detected];
	sleep 1;
	};
};
//[["mrk1","mrk2","mrk3"],_user] execVM "respawn.sqf";