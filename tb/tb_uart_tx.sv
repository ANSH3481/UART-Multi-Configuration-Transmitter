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
task automatic check_parity(
    input logic [7:0] data,
    input logic [1:0] parity_mode
);

    logic expected_parity;

    begin

        case(parity_mode)

            2'b00:
                $display("PASS : NO PARITY MODE");

            2'b01:
            begin
                expected_parity = ~(^data);

                if(expected_parity == dut.parity_bit)
                    $display("PASS : ODD PARITY");
                else
                    $display("FAIL : ODD PARITY");
            end

            2'b10:
            begin
                expected_parity = (^data);

                if(expected_parity == dut.parity_bit)
                    $display("PASS : EVEN PARITY");
                else
                    $display("FAIL : EVEN PARITY");
            end

        endcase

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
    tx_data = 8'h55;
    cfg_parity = 2'b00;
    tx_start = 1;
    #10;
    tx_start = 0;

    #400;
    check_parity(tx_data,cfg_parity);

    // TEST 2
    $display("\nTEST 2 : ODD PARITY");
    tx_data = 8'hA5;
    cfg_parity = 2'b01;
    tx_start = 1;
    #10;
    tx_start = 0;

    #400;
    check_parity(tx_data,cfg_parity);

    // TEST 3
    $display("\nTEST 3 : EVEN PARITY");
    tx_data = 8'h3C;
    cfg_parity = 2'b10;
    tx_start = 1;
    #10;
    tx_start = 0;

    #400;
    check_parity(tx_data,cfg_parity);

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
