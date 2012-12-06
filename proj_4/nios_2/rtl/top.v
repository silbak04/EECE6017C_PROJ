module top (

    input CLOCK_50,

    input [3:0] KEY,
    input [9:0] SW,

    output [7:0] LEDG,
    output [9:0] LEDR,

    output [6:0] HEX3,
    output [6:0] HEX2,
    output [6:0] HEX1,
    output [6:0] HEX0,

    output [31:0] GPIO_0,
    output [31:0] GPIO_1,

    output [11:0] DRAM_ADDR,

    output DRAM_BA_1, DRAM_BA_0, DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK,
    output DRAM_CKE, DRAM_CS_N, DRAM_WE_N, DRAM_UDQM, DRAM_LDQM,

    inout [15:0] DRAM_DQ
);

wire toggle_clock;

    nios_sys u0 (
        .hex3_external_connection_export        (HEX3),                         // hex3_external_connection.export
        .hex2_external_connection_export        (HEX2),                         // hex2_external_connection.export
        .hex1_external_connection_export        (HEX1),                         // hex1_external_connection.export
        .hex0_external_connection_export        (HEX0),                         // hex0_external_connection.export
        .sdram_0_wire_addr                      (DRAM_ADDR),                    // sdram_0_wire.addr
        .sdram_0_wire_ba                        ({DRAM_BA_1, DRAM_BA_0}),       // .ba
        .sdram_0_wire_cas_n                     (DRAM_CAS_N),                   // .cas_n
        .sdram_0_wire_cke                       (DRAM_CKE),                     // .cke
        .sdram_0_wire_cs_n                      (DRAM_CS_N),                    // .cs_n
        .sdram_0_wire_dq                        (DRAM_DQ),                      // .dq
        .sdram_0_wire_dqm                       ({DRAM_UDQM, DRAM_LDQM}),       // .dqm
        .sdram_0_wire_ras_n                     (DRAM_RAS_N),                   // .ras_n
        .sdram_0_wire_we_n                      (DRAM_WE_N),                    // .we_n
        .altpll_0_inclk_interface_clk           (CLOCK_50),                     // altpll_0_inclk_interface.clk
        .altpll_0_c2_clk                        (toggle_clock),                 // altpll_0_c2.clk
        .clock_bridge_0_out_clk_1_clk           (DRAM_CLK),                     // clock_bridge_0_out_clk_1.clk
        .ledg_external_connection_export        (LEDG),                         // ledg_external_connection.export
        .red_leds_external_connection_export    (LEDR),                         // red_leds_external_connection.export
        .buttons_external_connection_export     (KEY),                          // buttons_external_connection.export
        .switches_external_connection_export    (SW),                           // switches_external_connection.export
        .gpio_0_external_connection_export      (GPIO_0),                       // gpio_0_external_connection.export
        .gpio_1_external_connection_export      (GPIO_1)                        // gpio_1_external_connection.export
    );

endmodule
