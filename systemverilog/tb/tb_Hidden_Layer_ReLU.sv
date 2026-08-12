`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2026 10:38:22
// Design Name: 
// Module Name: tb_Hidden_Layer_ReLU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import NN_types::*;
 
module tb_Hidden_Layer_ReLU;
 
    // ---------------------------------------------------------------
    // Sinais de conexao com o DUT (Device Under Test)
    // ---------------------------------------------------------------
    logic clk;
    logic reset;
 
    logic [15:0] x0, x1, x2, x3;
    array_10x16  w0_array, w1_array, w2_array, w3_array, b_array;
    array_10x16  y_array;
 
    // ---------------------------------------------------------------
    // Instanciacao do DUT
    // ---------------------------------------------------------------
    Hidden_Layer dut (
        .clk       (clk),
        .reset     (reset),
        .x0        (x0),
        .x1        (x1),
        .x2        (x2),
        .x3        (x3),
        .w0_array  (w0_array),
        .w1_array  (w1_array),
        .w2_array  (w2_array),
        .w3_array  (w3_array),
        .b_array   (b_array),
        .y_array   (y_array)
    );
 
    // ---------------------------------------------------------------
    // Geracao do clock: periodo de 10ns (100 MHz), 50% duty cycle
    // ---------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;
 
    // ---------------------------------------------------------------
    // Task auxiliar: aplica um vetor de teste identico nos 10 neuronios
    // e espera N ciclos de latencia antes de imprimir o resultado.
    // ---------------------------------------------------------------
    task automatic run_vector(
        input string       label,
        input logic [15:0] tx0, tx1, tx2, tx3,
        input logic [15:0] tw0, tw1, tw2, tw3,
        input logic [15:0] tb,
        input int           latency_cycles
    );
        int i;
        begin
            // Aplica as entradas logo apos uma borda de subida,
            // para nao haver ambiguidade sobre "quando" a amostra entrou.
            @(posedge clk);
            #1;
            x0 = tx0; x1 = tx1; x2 = tx2; x3 = tx3;
            for (i = 0; i < 10; i++) begin
                w0_array[i] = tw0;
                w1_array[i] = tw1;
                w2_array[i] = tw2;
                w3_array[i] = tw3;
                b_array[i]  = tb;
            end
 
            // Espera exatamente "latency_cycles" bordas de subida
            repeat (latency_cycles) @(posedge clk);
            #1; // pequena folga para o sinal assentar antes de ler
 
            $display("---------------------------------------------------");
            $display("Vetor: %s", label);
            $display("  x0=%0d x1=%0d x2=%0d x3=%0d", $signed(tx0), $signed(tx1), $signed(tx2), $signed(tx3));
            $display("  w0=%0d w1=%0d w2=%0d w3=%0d  b=%0d", $signed(tw0), $signed(tw1), $signed(tw2), $signed(tw3), $signed(tb));
            $display("  y_array[0] = 0x%h (%0d)", y_array[0], $signed(y_array[0]));
            $display("  y_array[9] = 0x%h (%0d)", y_array[9], $signed(y_array[9]));
        end
    endtask
 
    // ---------------------------------------------------------------
    // Sequencia principal de estimulos
    // ---------------------------------------------------------------
    initial begin
        // Estado inicial
        reset = 1;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0;
        for (int i = 0; i < 10; i++) begin
            w0_array[i] = 0; w1_array[i] = 0;
            w2_array[i] = 0; w3_array[i] = 0;
            b_array[i]  = 0;
        end
 
        // Mantem reset por alguns ciclos, depois libera
        repeat (3) @(posedge clk);
        #1;
        reset = 0;
 
        // ---------------- Vetores "faceis" ----------------
 
        // V1: tudo zero -> soma = 0 -> ReLU(0) = 0
        run_vector("V1 - tudo zero", 16'sd0, 16'sd0, 16'sd0, 16'sd0,
                                       16'sd0, 16'sd0, 16'sd0, 16'sd0,
                                       16'sd0, 3);
 
        // V2: x0=1.0, w0=1.0, resto zero -> soma = 1.0 -> ReLU positivo, passa direto
        run_vector("V2 - produto simples 1.0*1.0", 16'sd256, 16'sd0, 16'sd0, 16'sd0,
                                                     16'sd256, 16'sd0, 16'sd0, 16'sd0,
                                                     16'sd0, 3);
 
        // V3: soma fortemente negativa -> ReLU deve zerar a saida
        run_vector("V3 - saturacao negativa (ReLU->0)", 16'sd256, 16'sd256, 16'sd256, 16'sd256,
                                                          -16'sd500, -16'sd500, -16'sd500, -16'sd500,
                                                          -16'sd1000, 3);
 
        // V4: soma positiva moderada, todos os canais contribuindo
        run_vector("V4 - soma positiva moderada", 16'sd128, 16'sd64, 16'sd32, 16'sd16,
                                                    16'sd256, 16'sd256, 16'sd256, 16'sd256,
                                                    16'sd50, 3);
 
        // ---------------- Vetores "aleatorios" (mistura de sinais) ----------------
 
        run_vector("V5 - aleatorio 1", 16'sd300, -16'sd150, 16'sd75, -16'sd40,
                                        16'sd100, 16'sd200, -16'sd90, 16'sd60,
                                        16'sd20, 3);
 
        run_vector("V6 - aleatorio 2", -16'sd200, 16'sd400, -16'sd60, 16'sd10,
                                        -16'sd80, 16'sd150, 16'sd70, -16'sd120,
                                        -16'sd30, 3);
 
        run_vector("V7 - aleatorio 3", 16'sd512, 16'sd512, -16'sd512, -16'sd512,
                                        16'sd256, -16'sd256, 16'sd256, -16'sd256,
                                        16'sd0, 3);
 
        run_vector("V8 - aleatorio 4", -16'sd100, -16'sd50, -16'sd25, -16'sd10,
                                        16'sd300, 16'sd300, 16'sd300, 16'sd300,
                                        16'sd5, 3);
 
        $display("---------------------------------------------------");
        $display("Simulacao concluida.");
        $stop;
    end
 
endmodule
