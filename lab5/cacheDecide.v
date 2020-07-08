
`timescale 100ps/1ps
module cacheDecide (numout , cacheWR, valid1, valid2, match1, match2, rst, cs, index);
	parameter 	   index_size = 0; //default value
    
    input          rst, cacheWR;
    input	   	   valid1, valid2, match1, match2;
    input          [index_size-1:0]index; //目前input的address的index
	input          [3:0]cs;
	
	output         numout;  		//決定要replace的way

    wire           numout;
    wire           hit1, hit2; //way0 hit, way1 hit
    wire	       readHit;//read hit on dcache
	
	reg		   	   [511:0]mru_list; //mru flag for all set in dcache
	
    assign         readHit = (cs == 4'd9);//read hit condition
	assign         hit1 = match1 & valid1;
	assign         hit2 = match2 & valid2;
	assign         numout = mru_list[index]; //參考mru_list決定要replace哪一個way

    always@(posedge rst or posedge cacheWR or posedge readHit)begin
        if(rst) begin
            mru_list = 512'd0;
        end else begin
            if(cacheWR) begin		//cache write (read miss, write miss, write hit)
                if(!valid1 & valid2 ) begin  //way0 data is invalid
					if(match2) begin  			//way1's tag matched
						mru_list[index] <= 1'b1;
					end else begin
						mru_list[index] <= 1'b0;
					end
				end else if (valid1 & !valid2) begin //way1 data is invalid
					if(match1) begin 			//way0's tag matched
						mru_list[index] <= 1'b0;
					end else begin
						mru_list[index] <= 1'b1;
					end
				end else if(valid1 & valid2) begin //both way are valid
					if(match1 & !match2)  		//way0's tag matched
						mru_list[index] <= 1'b0;
					else if(!match1 & match2)  	//way1's tag matched
						mru_list[index] <= 1'b1;
					else						//both way missed
						mru_list[index] <= ~mru_list[index];
				end else							//both way are invalid
					mru_list[index] <= ~mru_list[index];
            end else if(readHit) begin // read hit
				if(hit1 & !hit2)		//way0 hit
					mru_list[index] <= 1'b0;
				else if(!hit1 & hit2)	//way1 hit
					mru_list[index] <= 1'b1;
				else					//both hit or both miss
					mru_list[index] <= ~mru_list[index];
			end
        end
    end
endmodule
