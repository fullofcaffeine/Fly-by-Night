/*

macro: always include a test class in /runway named "RunwayRoutes.hx" with all paths in /config/routes.yml have their controller.actions created

/engine/runway/Runner.hx runs the tests

test function names do not have to start with "it_" as long as they have metadata set
function names that do start with "it_" are tested even if they have no metadata

this class is a clone of haxe.unit.TestCase geared towards RSpec style unit tests

*/
/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package runway;
import haxe.PosInfos;

class Integration implements haxe.Public
{


  /*
    exact clone of haxe.unit.TestCase haxe 2.07
  */
  public var currentTest : Status;

	public function new( )
	{
	
	}

	public function setup() : Void
	{
	
	}

	public function tearDown() : Void 
	{
	
	}

	private function print( v : Dynamic ) 
	{
		Runner.print(v);
	}

	private function assertTrue( b:Bool, ?c : PosInfos ) : Void 
	{
		currentTest.done = true;
		if (b == false){
			currentTest.success = false;
			currentTest.error   = "expected true but was false";
			currentTest.posInfos = c;
			throw currentTest;
		}
	}

	private function assertFalse( b:Bool, ?c : PosInfos ) : Void 
	{
		currentTest.done = true;
		if (b == true){
			currentTest.success = false;
			currentTest.error   = "expected false but was true";
			currentTest.posInfos = c;
			throw currentTest;
		}
	}

	private function assertEquals<T>( expected: T , actual: T,  ?c : PosInfos ) : Void 	
	{
		currentTest.done = true;
		if (actual != expected){
			currentTest.success = false;
			currentTest.error   = "expected '" + expected + "' but was '" + actual + "'";
			currentTest.posInfos = c;
			throw currentTest;
		}
	}
}