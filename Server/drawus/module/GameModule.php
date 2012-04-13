<?php
/**
 * 游戏--公用业务逻辑
 */
class GameModule
{
	private $game_infoDAO;
	private $game_user_infoDAO;
	
	function _construct()
	{
		$this->game_infoDAO = new Game_infoDAO();
		$this->game_user_infoDAO = new Game_user_infoDAO();
	}
	
	/**
	 * 创建新游戏
	 */
	function createGameInfo($user_id, $password,$user_score)
	{
		
	}
}
?>