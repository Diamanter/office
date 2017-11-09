package com.sigma.socialgame.model.social
{
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	
	import flash.events.IEventDispatcher;

	public interface ISocialNetworkDelegate extends IEventDispatcher
	{
		function getMe() : void;
		
		function getFriends() : void;
		function getAppFriends() : void;
		
		function get me() : FriendSocialData;
		
		function publish(quest : String, str : String, imgStr : String) : void;
		function invite(arr:Array) : void;
		
		function get friends() : Vector.<FriendSocialData>;
		function get appFriends() : Vector.<FriendSocialData>;
	}
}