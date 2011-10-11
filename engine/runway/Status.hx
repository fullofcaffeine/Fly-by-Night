/*
  cloned from haxe.unit.TestStatus
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
import haxe.Stack;
import haxe.PosInfos;
import logger.TerminalColor;
using logger.TerminalColors;

class Status {
	public var done : Bool;
	public var success : Bool;
	public var pending : Bool;
	public var error : String;
	public var method : String;
	public var classname : String;
	public var posInfos : PosInfos;
	public var backtrace : String;

	public function new() 	{
		done = success = pending = false;
	}
  
  public inline function toString(  ):String
  {
    var buf = new StringBuf();
    
    if(success){
      #if color 
      buf.add(TerminalColor.GREEN.value());
      #end
      buf.add("[S] "); 
  		// buf.add(classname);
  		// buf.add("::");
  		if(StringTools.startsWith(method,"it_")){
  		  buf.add(StringTools.replace(method.substr(3),"_"," "));
  		}else{
  		  buf.add(StringTools.replace(method,"_"," "));
  		}
  		buf.add("\n");

  		#if color 
      buf.add(TerminalColor.DEFAULT_COLOR.value());
      #end
    }else if(pending){
      #if color 
	    buf.add(TerminalColor.YELLOW.value());
	    #end
	    buf.add("[P] "); 
			// buf.add(classname);
			// buf.add("::");
			if(StringTools.startsWith(method,"it_")){
			  buf.add(StringTools.replace(method.substr(3),"_"," "));
			}else{
			  buf.add(StringTools.replace(method,"_"," "));
			}
			buf.add("\n");
			
			#if color 
	    buf.add(TerminalColor.DEFAULT_COLOR.value());
	    #end
	    
    }else{ // failure
      #if color 
	    buf.add(TerminalColor.REDBG_WHITE.value());
	    #end
			buf.add("[F] ");
			// buf.add(classname);
			// buf.add("::");
			if(StringTools.startsWith(method,"it_")){
			  buf.add(StringTools.replace(method.substr(3),"_"," "));
			}else{
			  buf.add(StringTools.replace(method,"_"," "));
			}
			buf.add("\n");
      #if color 
	    buf.add(TerminalColor.DEFAULT_COLOR.value());
	    #end
			if (backtrace != null) {
			  #if color 
  	    buf.add(TerminalColor.LIGHT_RED.value());
  	    #end
			  buf.add("ERROR: ");
			  if( posInfos != null ){
			    buf.add(posInfos.fileName);
			    buf.add(":");
			    buf.add(posInfos.lineNumber);
			    buf.add("(");
			    buf.add(posInfos.className);
			    buf.add(".");
			    buf.add(posInfos.methodName);
			    buf.add(") - ");
			  }
			  #if color 
		    buf.add(TerminalColor.LIGHT_RED.value());
		    #end
			  buf.add(error);
			  buf.add("\n");
		    #if color 
		    buf.add(TerminalColor.BLACKBG_WHITE.value());
		    #end
		    buf.add(backtrace);
		    #if color 
		    buf.add(TerminalColor.DEFAULT_COLOR.value());
		    #end
		    buf.add("\n");
		  }
      
    }
    
    return buf.toString();
  }
  
}
