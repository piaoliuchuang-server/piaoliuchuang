<?php
//create-time 2012-4-08 16:31:28
class User_info {
	private $user_id;
	private $password;
	private $register_time;
	private $user_score;
	function setUser_id($user_id) {
		$this->user_id=$user_id;
	}
 
	function getUser_id() {
		return $this->user_id;
	}
	function setPassword($password) {
		$this->password=$password;
	}
 
	function getPassword() {
		return $this->password;
	}
	function setRegister_time($register_time) {
		$this->register_time=$register_time;
	}
 
	function getRegister_time() {
		return $this->register_time;
	}
	function setUser_score($user_score) {
		$this->user_score=$user_score;
	}
 
	function getUser_score() {
		return $this->user_score;
	}
}
?>