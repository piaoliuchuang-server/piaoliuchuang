<?php
//create-time 2012-4-08 16:31:28
class Game_user_info {
	private $game_id;
	private $user_id;
	function setGame_id($game_id) {
		$this->game_id=$game_id;
	}
 
	function getGame_id() {
		return $this->game_id;
	}
	function setUser_id($user_id) {
		$this->user_id=$user_id;
	}
 
	function getUser_id() {
		return $this->user_id;
	}
}
?>