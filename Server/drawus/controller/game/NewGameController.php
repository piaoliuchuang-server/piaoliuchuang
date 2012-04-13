<?php
/**
 * 新建游戏
 */
class NewGameController extends Controller
{
	function __construct()
	{
		parent::__construct();
	}
	
	function run()
	{
		$founder_id = $_POST[User_post_Params::GAME_FOUNDER];
		$parter_id = $_POST[User_post_Params::GAME_PARTNER];
		
		$user_module = new UserModule();
		//取游戏玩家的信息
		$parter = $user_module -> getUserInfoByUserId($parter_id);
		if(is_null($parter))
		{
			$this->_addErrorCode(User_error_Params::PLAYER_NOT_EXIST);
			$this->AddUserResultHandle(false);
			return false;	
		}
		else
		{
			
		}
		
	}
	
	/**
	 * 处理增加用户结果,为Http服务
	 * 
	 * @param $status为false时说明有错误，true时为添加用户成功
	 */
	private function AddUserResultHandle($status)
	{
		header("Content-type:text/plain");
		header("Cache-Control: no-cache");
		$jsonResult = new Http_handle_result();
		if (!$status)
		{
			$jsonResult->message = $this->_errorToString();
			$jsonResult->data = '';
		}
		else 
		{
			$jsonResult->message = strval(User_error_Params::SUCESS);
			$jsonResult->data = '';
		}
		echo json_encode($jsonResult);
		
	}
	
	//=================================================================
	//  错误代码操作 Begin
	//
	//==================================================================
	/**
	 * 存放错误代码
	 * 
	 * @var int[]
	 */
	private $_errorCode;
	
	/**
	 * 初始化错误代码数组
	 */
	private function _initErrorCode()
	{
		 $this->_clearErrorCode();
	}
	
	/**
	 * 清理错误代码数组
	 */
	private function _clearErrorCode()
	{
		 $this->_errorCode = array();
	}
	
	/** 
	 * 增加错误代码至$errorCode
	 * 
	 * @param int $errorCode  错误代码
	 */
	private function _addErrorCode($errorCode)
	{
		 $this->_errorCode[count( $this->_errorCode)] = $errorCode;
	}
	
	/**
	 * 判断当前是否包含错误
	 * 
	 * @return bool 
	 */
	private function _existError()
	{
		return count( $this->_errorCode) > 0;
	}
	
	/**
	 *将当前错误代码用 逗号 拼接成字符串
	 *
	 * @return string
	 */
	private function _errorToString()
	{
		return implode(',',  $this->_errorCode);
	}
	//===========================错误代码操作 	End===========================
}

?>