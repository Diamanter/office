package com.sigma.socialgame.common.math
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.Logger;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class IsometricMath
	{
		private static var _matToIso : Matrix3D;
		private static var _matFromIso : Matrix3D;
		
		private static const _toIsoRotY : Number = -45;
//		private static const _toIsoRotX : Number = 35.264;
		private static var _toIsoRotX : Number;
		
		private static var ratio:Number = 1.7;
		
		public static function fromIsometric (screenPt:Vector3D):Vector3D
		{
			var z:Number = screenPt.z;
			var y:Number = screenPt.y - screenPt.x / ratio + screenPt.z;
			var x:Number = screenPt.x / ratio + screenPt.y + screenPt.z;
			
			return new Vector3D(x, y, z);
		}
		
		/**
		 * @inheritDoc
		 */
		public static function toIsometric (spacePt:Vector3D):Vector3D
		{
			var z:Number = spacePt.z;
			var y:Number = (spacePt.x + spacePt.y) / ratio - spacePt.z;
			var x:Number = spacePt.x - spacePt.y;
			
			return new Vector3D(x, y, z);
		}
		
/*		public static function toIsometric(vec_ : Vector3D) : Vector3D
		{
			if (vec_ == null)
			{
				Logger.message("IsometricMath.toIsometric: Null vector.", "IsometricMath", LogLevel.Error); 
				
				return null;
			}
			
			var newVec : Vector3D = matToIso.transformVector(vec_);
			
			return newVec;
		}
		
		public static function fromIsometric(vec_ : Vector3D) : Vector3D
		{
			if (vec_ == null)
			{
				Logger.message("IsometricMath.fromIsometric: Null vector.", "IsometricMath", LogLevel.Error); 
				
				return null;
			}
			
			var newVec : Vector3D = matFromIso.transformVector(vec_);
			
			return newVec;
		}

		protected static function get matToIso():Matrix3D
		{
			if (_matToIso == null)
				initMatrix();			
			
			return _matToIso;
		}
		
		protected static function get matFromIso():Matrix3D
		{
			if (_matFromIso == null)
				initMatrix();			
			
			return _matFromIso;
		}
		
		protected static function initMatrix() : void
		{
			_toIsoRotX = Math.asin(Math.tan(Math.PI / 6)) * 180 / Math.PI;
			
			_matToIso = new Matrix3D();
			
			_matToIso.appendRotation(_toIsoRotY, Vector3D.Y_AXIS);
			_matToIso.appendRotation(_toIsoRotX, Vector3D.X_AXIS);
			
			_matFromIso = _matToIso.clone();
			_matFromIso.invert();
		}
*/	}
}