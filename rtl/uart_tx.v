module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    input  wire [1:0] cfg_parity, // 00=No, 01=Odd, 10=Even

    output reg        tx,
    output reg        tx_busy
);

reg [2:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;
reg       parity_bit;

localparam IDLE   = 3'b000,
           START  = 3'b001,
           DATA   = 3'b010,
           PARITY = 3'b011,
           STOP   = 3'b100;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state      <= IDLE;
        tx         <= 1'b1;
        tx_busy    <= 1'b0;
        bit_index  <= 3'd0;
        data_reg   <= 8'd0;
        parity_bit <= 1'b0;
    end
    else
    begin
        case(state)

        //--------------------------------------------------
        // IDLE
        //--------------------------------------------------
        IDLE:
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin
                tx_busy   <= 1'b1;
                data_reg  <= tx_data;
                bit_index <= 3'd0;

                case(cfg_parity)

                    // Odd Parity
                    2'b01:
                        parity_bit <= ~(^tx_data);

                    // Even Parity
                    2'b10:
                        parity_bit <= (^tx_data);

                    default:
                        parity_bit <= 1'b0;

                endcase

                state <= START;
            end
        end

        //--------------------------------------------------
        // START BIT
        //--------------------------------------------------
        START:
        begin
            if(baud_tick)
            begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        //--------------------------------------------------
        // DATA BITS
        //--------------------------------------------------
        DATA:
        begin
            if(baud_tick)
            begin
                tx <= data_reg[bit_index];

                if(bit_index == 3'd7)
                begin
                    bit_index <= 3'd0;

                    if(cfg_parity == 2'b00)
                        state <= STOP;
                    else
                        state <= PARITY;
                end
                else
                begin
                    bit_index <= bit_index + 1'b1;
                end
            end
        end

        //--------------------------------------------------
        // PARITY BIT
        //--------------------------------------------------
        PARITY:
        begin
            if(baud_tick)
            begin
                tx <= parity_bit;
                state <= STOP;
            end
        end

        //--------------------------------------------------
        // STOP BIT
        //--------------------------------------------------
        STOP:
        begin
            if(baud_tick)
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                state <= IDLE;
            end
        end

        //--------------------------------------------------
        // DEFAULT
        //--------------------------------------------------
        default:
        begin
            state <= IDLE;
        end

        endcase
    end
end

endmodule
