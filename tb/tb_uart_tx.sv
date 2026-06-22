module tb_uart_tx;

logic clk;
logic rst;
logic baud_tick;
logic tx_start;
logic [7:0] tx_data;
logic [1:0] cfg_parity;

logic tx;
logic tx_busy;

uart_tx dut(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .cfg_parity(cfg_parity),
    .tx(tx),
    .tx_busy(tx_busy)
);

// Clock Generation
always #5 clk = ~clk;

// Baud Tick Generation
always begin
    baud_tick = 0;
    #20;
    baud_tick = 1;
    #10;
    baud_tick = 0;
end

//--------------------------------------------------
// SystemVerilog Task
//--------------------------------------------------
task automatic verify_frame(
    input logic [7:0] expected_data,
    input logic [1:0] parity_mode
);

    logic [7:0] received_data;
    logic received_parity;
    logic expected_parity;
    integer i;

    begin

        // Wait until transmission starts
        wait(tx_busy == 1);

         // START bit
 @(posedge baud_tick);
 @(posedge baud_tick);
 #1;

 if(tx != 0)
     $display("FAIL : START BIT ERROR");
        
        
          

        for(i=0; i<8; i=i+1)
begin
    @(posedge baud_tick);
    #5;
    received_data[i] = tx;
end
        

        // DATA check
        if(received_data == expected_data)
            $display("PASS : DATA MATCH (%h)", received_data);
        else
            $display("FAIL : DATA Expected=%h Received=%h",
                     expected_data, received_data);

        // PARITY
        if(parity_mode != 2'b00)
        begin
            @(posedge baud_tick);
            #1;
            received_parity = tx;

            case(parity_mode)

                2'b01:
                begin
                    expected_parity = ~(^expected_data);

                    if(received_parity == expected_parity)
                        $display("PASS : ODD PARITY VERIFIED");
                    else
                        $display("FAIL : ODD PARITY ERROR");
                end

                2'b10:
                begin
                    expected_parity = (^expected_data);

                    if(received_parity == expected_parity)
                        $display("PASS : EVEN PARITY VERIFIED");
                    else
                        $display("FAIL : EVEN PARITY ERROR");
                end

            endcase
        end

        // STOP bit
        @(posedge baud_tick);
        #1;

        if(tx == 1)
            $display("PASS : STOP BIT VERIFIED");
        else
            $display("FAIL : STOP BIT ERROR");

    end

endtask

      

//--------------------------------------------------
// Test Sequence
//--------------------------------------------------
initial begin

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 0;
    cfg_parity = 0;

    $display("=================================");
    $display("UART TRANSMITTER TEST STARTED");
    $display("=================================");

    #20;
    rst = 0;

    // TEST 1
    $display("\nTEST 1 : NO PARITY");

fork
    verify_frame(8'h55,2'b00);
join_none

tx_data = 8'h55;
cfg_parity = 2'b00;
tx_start = 1;

#10;
tx_start = 0;

#500;

    // TEST 2
    $display("\nTEST 2 : ODD PARITY");

fork
    verify_frame(8'hA5,2'b01);
join_none

tx_data = 8'hA5;
cfg_parity = 2'b01;
tx_start = 1;

#10;
tx_start = 0;

#500;

    // TEST 3
   $display("\nTEST 3 : EVEN PARITY");

fork
    verify_frame(8'h3C,2'b10);
join_none

tx_data = 8'h3C;
cfg_parity = 2'b10;
tx_start = 1;

#10;
tx_start = 0;

#500;

    
   

    $display("\n=================================");
    $display("ALL TESTS COMPLETED");
    $display("=================================");

    $finish;

end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_uart_tx);
end

endmodule
