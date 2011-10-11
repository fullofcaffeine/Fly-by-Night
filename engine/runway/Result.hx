/*
  cloned from haxe.unit.TestResult

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
import logger.TerminalColor;
using logger.TerminalColors;

class Result {

	var m_tests : List<Status>;
	public var success(default,null) : Bool;

	public function new() {
		m_tests = new List();
		success = true;
	}

	public function add( t:Status ) : Void {
		m_tests.add(t);
		if( !t.success )
			success = false;
	}

	public function toString() : String 	{
		var buf = new StringBuf();
		var failures = 0;
		var pendings = 0;
		for ( test in m_tests ){
		  if (test.pending){
		    pendings++;
		  }else if (!test.success){
		   	buf.add("\n");
        buf.add(test);
				buf.add("\n");
				buf.add("\n");
				failures++;
			}
		}
		buf.add("\n");
		
		if (failures == 0){
		  #if color 
      buf.add(TerminalColor.LIGHT_GREEN.value());
      buf.add("OK ");
      #end
		}else{
		  #if color 
      buf.add(TerminalColor.LIGHT_RED.value());
      #end
      buf.add("FAILED ");
		}

		buf.add(m_tests.length);
		buf.add(" tests, ");
		buf.add(failures);
		buf.add(" [F]ailed, ");
		buf.add(pendings);
		buf.add(" [P]ending, ");
		buf.add( (m_tests.length - failures - pendings) );
		buf.add(" [S]uccess");
		#if color 
    buf.add(TerminalColor.DEFAULT_COLOR.value());
    #end
		buf.add("\n");
		return buf.toString();
	}

}
